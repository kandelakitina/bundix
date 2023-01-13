require 'minitest/autorun'
require 'bundix'
require 'digest'
require 'json'

class TestConvert < Minitest::Test
  class PrefetchStub < Bundix::Fetcher
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
      assert_equal(gemset.dig("phony_gem", :version), "0.1.0")
      assert_equal(gemset.dig("phony_gem", :source, :type), "path")
      assert_equal(gemset.dig("phony_gem", :source, :path), "lib/phony_gem")
      assert_includes(gemset.dig("rails", :dependencies), "railties")
      assert_includes(gemset.dig("nokogiri", :dependencies), "racc")
      assert_equal(gemset.dig("sqlite3", :source), nil)
      assert_equal(gemset.dig("sqlite3", :targets).first[:type], "gem")
      assert_equal(gemset.dig("sqlite3", :targets).first[:target], "x86_64-linux")
      assert_equal(gemset.dig("sqlite3", :targets).first[:targetCPU], "x86_64")
      assert_equal(gemset.dig("sqlite3", :targets).first[:targetOS], "linux")
    end
  end
end
