require "json"
require "open-uri"
require "open3"
require "pp"

require_relative "bundix/dependency"
require_relative "bundix/version"
require_relative "bundix/source"
require_relative "bundix/nixer"

PLATFORM_MAPPING = {}

{
  "ruby" => [{ engine: "ruby" }, { engine: "rbx" }, { engine: "maglev" }],
  "mri" => [{ engine: "ruby" }, { engine: "maglev" }],
  "rbx" => [{ engine: "rbx" }],
  "jruby" => [{ engine: "jruby" }],
  "mswin" => [{ engine: "mswin" }],
  "mswin64" => [{ engine: "mswin64" }],
  "mingw" => [{ engine: "mingw" }],
  "truffleruby" => [{ engine: "ruby" }],
  "x64_mingw" => [{ engine: "mingw" }],
}.each do |name, list|
  PLATFORM_MAPPING[name] = list
  %w(1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 3.0 3.1 3.2).each do |version|
    PLATFORM_MAPPING["#{name}_#{version.sub(/[.]/, "")}"] = list.map do |platform|
      platform.merge(:version => version)
    end
  end
end

class Bundix
  NIX_INSTANTIATE = "nix-instantiate"
  NIX_PREFETCH_URL = "nix-prefetch-url"
  NIX_PREFETCH_GIT = "nix-prefetch-git"
  NIX_HASH = "nix-hash"
  NIX_SHELL = "nix-shell"

  SHA256_32 = %r(^[a-z0-9]{52}$)

  attr_reader :options
  attr_accessor :fetcher

  def initialize(options)
    @options = { quiet: false, tempfile: nil }.merge(options)
    @fetcher = Fetcher.new
  end

  # Convert the content of Gemfile.lock to bundix's output schema
  def convert
    old_gemset = parse_gemset
    gemfile, lockfile = options.values_at(:gemfile, :lockfile)
    deps, lock = parse_gemfiles(gemfile, lockfile)

    gems = Hash.new { |h, k| h[k] = [] }

    lock.specs.each do |spec|
      gem = build_gemspec(spec, deps)
      if spec.dependencies.any?
        gem[:dependencies] = spec.dependencies.map(&:name) - ["bundler"]
      end
      gems[spec.name] << gem
    end

    gems.map do |name, variants|
      primary = nil
      targets = []
      variants.each do |v|
        target = v.dig(:source, :target)
        if target == "ruby" or target.nil?
          primary = v
          primary[:source][:target] = "ruby" if target.nil?
        else
          targets << v[:source]
        end
      end
      if primary.nil?
        spec = variants.first.clone
        spec[:source] = nil
        primary = spec
      end
      [name, primary.merge(targets: targets)]
    end.to_h
  end

  def build_gemspec(spec, deps)
    [platforms(spec, deps),
     groups(spec, deps),
     Source.new(spec, fetcher).convert].inject(&:merge)
  rescue => ex
    warn "Skipping #{spec.name}: #{ex}"
    puts ex.backtrace
    {}
  end

  def groups(spec, deps)
    { groups: deps.fetch(spec.name).groups }
  end

  def platforms(spec, deps)
    # c.f. Bundler::CurrentRuby
    platforms = deps.fetch(spec.name).platforms.map do |platform_name|
      PLATFORM_MAPPING[platform_name.to_s]
    end.flatten

    { platforms: platforms }
  end

  def parse_gemset
    path = File.expand_path(options[:gemset])
    return {} unless File.file?(path)
    json = Bundix.sh(NIX_INSTANTIATE, "--eval", "-E", %(
      builtins.toJSON (import #{Nixer.serialize(path)})))
    JSON.parse(json.strip.gsub(/\\"/, '"')[1..-2])
  end

  def self.sh(*args, &block)
    out, status = Open3.capture2(*args)
    unless block_given? ? block.call(status, out) : status.success?
      puts "$ #{args.join(" ")}" if $VERBOSE
      puts out if $VERBOSE
      fail "command execution failed: #{status}"
    end
    out
  end
end
