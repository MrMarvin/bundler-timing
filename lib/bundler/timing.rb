#frozen_string_literal: true

module Bundler
  module Timing
    L =  "🕰️ Timing".freeze

    class << self
      attr_accessor :dependencies, :timings, :timer
      @timings = {}
      @dependencies = []
      @timer = nil

      def report
        longest_gem_name = @timings.keys.map(&:length).max
        longest_source = @timings.values.map(&:fetch_source).compact.map { |s| s.to_s.length }.max

        Bundler.ui.info "#{Bundler::Timing::L}: Timing report:"
        Bundler.ui.info "#{'gem'.ljust(longest_gem_name)} | ext?  | #{'source'.ljust(longest_source)} | fetch (ms) | install (ms)"
        Bundler.ui.info "#{'-'*longest_gem_name}-|-------|-#{'-' * longest_source}-|------------|--------------"
        Bundler::Timing.timings.to_a.sort_by { |name, gem| gem.installation_time }.each do |name, gem|

          puts "#{name.ljust(longest_gem_name)} | #{gem.with_native_extentions?.to_s.ljust(5)} | #{gem.fetch_source.ljust(longest_source)} | #{gem.fetch_time.to_s.rjust(10)} | #{gem.installation_time.to_s.rjust(12)}"
        end
        Bundler.ui.info "#{'-'*longest_gem_name}-|-------|-#{'-' * longest_source}-|------------|--------------"

        Bundler.ui.info "#{Bundler::Timing::L}: Installed #{Bundler::Timing::dependencies.count} gems in #{Bundler::Timing.timer.runtime} ms."
      end

      def [](gem_full_name)
        @timings ||= {}
        @timings[gem_full_name] ||= Bundler::Timing::GemTiming.new(nil)
      end
    end


    class Timer

      def initialize
        @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      def stop!
        @finish_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      def stopped?
        !!@finish_time
      end

      def runtime
        ((@finish_time - @start_time) * 1000).round(0)
      end
    end

    class GemTiming

      attr_accessor :spec, :install_timer, :fetch_timer, :fetch_source

      def initialize(spec)
        @spec = spec
        @install_timer = nil
        @fetch_timer = nil
        @fetch_source = nil
      end

      def start_install_timer!
        @install_timer = Timer.new
        self
      end

      def start_fetch_timer!
        @fetch_timer = Timer.new
        self
      end

      def installation_time
        return 0 unless @install_timer
        @install_timer.stop! unless @install_timer.stopped?
        @install_timer.runtime
      end

      def fetch_time
        return 0 unless @fetch_timer
        @fetch_timer.stop! unless @fetch_timer.stopped?
        @fetch_timer.runtime
      end

      def with_native_extentions?
        @spec&.extensions&.any? || false
      end

      def fetch_source
        @fetch_source&.to_s || "installed ✔️"
      end
    end
  end
end


# require "bundler"

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_BEFORE_INSTALL_ALL) do |dependencies|
  Bundler::Timing.dependencies = dependencies
  Bundler::Timing.timer = Bundler::Timing::Timer.new

  Bundler.ui.info "#{Bundler::Timing::L}: #{Bundler::Timing::dependencies.count} gems to install..."
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_BEFORE_INSTALL) do |dependency|
  Bundler::Timing[dependency.spec.full_name].spec = dependency.spec
  Bundler::Timing[dependency.spec.full_name].start_install_timer!
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_AFTER_INSTALL) do |dependency|
  Bundler::Timing[dependency.spec.full_name].install_timer.stop!
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_AFTER_INSTALL_ALL) do |dependencies|
  Bundler::Timing.timer.stop!

  Bundler::Timing.report
end


if defined?(Bundler::Plugin::Events::GEM_BEFORE_FETCH)
  Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_BEFORE_FETCH) do |maybe_spec, source|
    Bundler::Timing[maybe_spec.full_name].start_fetch_timer!
    Bundler::Timing[maybe_spec.full_name].fetch_source = source
  end

  Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_AFTER_FETCH) do |maybe_spec, source|
    Bundler::Timing[maybe_spec.full_name].fetch_timer.stop!
  end
end
