require 'minitest/autorun'
require 'bundix'
require 'digest'
require 'json'

class TestConvert < Minitest::Test
  class PrefetchStub < Bundix::Fetcher
    SPECS = {
      "sorbet-static" => {
        platform: 'arm64-darwin-21',
      },
      "sqlite3" => {
        platform: 'universal-darwin-22',
      },
    }

    def nix_prefetch_url(*args)
      format_hash(Digest::SHA256.hexdigest(args.to_s))
    end

    def nix_prefetch_git(*args)
      JSON.generate("sha256" => format_hash(Digest::SHA256.hexdigest(args.to_s)))
    end

    def fetch_local_hash(spec)
      # Force to use fetch_remote_hash
      return nil
    end

    # speed tests up and override platform from SPECS
    def spec_for_dependency(remote, dependency)
      name = dependency.name
      opts = SPECS[name]
      raise "Unexpected spec query: #{name}" unless opts

      Gem::Specification.new do |s|
        s.name = name
        s.version = dependency.version
        s.platform = Gem::Platform.new(opts[:platform]) if opts[:platform]
      end
    end
  end

  def with_gemset(options)
    Bundler.instance_variable_set(:@root, Pathname.new(File.expand_path("data", __dir__)))
    bundle_gemfile = ENV["BUNDLE_GEMFILE"]
    ENV["BUNDLE_GEMFILE"] = options[:gemfile]
    options = {:deps => false, :lockfile => "", :gemset => ""}.merge(options)
    converter = Bundix.new(options)
    converter.fetcher = PrefetchStub.new
    yield(converter.convert)
  ensure
    ENV["BUNDLE_GEMFILE"] = bundle_gemfile
    Bundler.reset!
  end

  def test_bundler_dep
    with_gemset(
      :gemfile => File.expand_path("data/bundler-audit/Gemfile", __dir__),
      :lockfile => File.expand_path("data/bundler-audit/Gemfile.lock", __dir__)
    ) do |gemset|
      assert_equal(gemset.dig("sorbet-static", :version), "0.5.10624")
      assert_equal(gemset.dig("sorbet-static", :targets).first[:target], "arm64-darwin-21")
      assert_equal(gemset.dig("sorbet-static", :targets).first[:targetCPU], "arm64")
      assert_equal(gemset.dig("sorbet-static", :targets).first[:targetOS], "darwin")
      assert_equal(gemset.dig("sqlite3", :source), nil)
    end
  end
end
