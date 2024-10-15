#frozen_string_literal: true

module Bundler
  module Timing
    L =  "🕰️ Timing".freeze

    class << self
      attr_accessor :dependencies, :timings, :start_time, :finish_time
      @timings = {}
      @dependencies = []
      @start_time = nil
      @finish_time = nil
    end
  end
end


# require "bundler"

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_BEFORE_INSTALL_ALL) do |dependencies|
  Bundler::Timing.dependencies = dependencies
  Bundler::Timing.start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  Bundler.ui.info "#{Bundler::Timing::L}: #{Bundler::Timing::dependencies.count} gems to install..."
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_BEFORE_INSTALL) do |dependency|
  (Bundler::Timing.timings ||= {})[dependency.full_name] = {:start_time => Process.clock_gettime(Process::CLOCK_MONOTONIC)}
  Bundler::Timing.timings[dependency.full_name][:with_native_extentions] = dependency.spec.extensions.any?
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_AFTER_INSTALL) do |dependency|
  Bundler::Timing.timings[dependency.full_name][:finish_time] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
end

Bundler::Plugin.add_hook(Bundler::Plugin::Events::GEM_AFTER_INSTALL_ALL) do |dependencies|
  Bundler::Timing.finish_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)


  per_gem_timings = Bundler::Timing.timings.map do |name, gem|
    [name, gem[:with_native_extentions], (gem[:finish_time] - gem[:start_time]).round(2)]
  end.sort_by! { |_, _, time| time }

  per_gem_timings.each do |name, extensions, time|
    Bundler.ui.info "#{Bundler::Timing::L}: #{name}#{extensions ? "(NATIVE EXTENSIONS)" : ""} took\t#{time} seconds"
  end

  overall_elapsed_time = (Bundler::Timing.finish_time - Bundler::Timing.start_time).round(2)
  Bundler.ui.info "#{Bundler::Timing::L}: Installed #{Bundler::Timing::dependencies.count} gems in #{overall_elapsed_time} seconds."
end
