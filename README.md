[gem]: https://rubygems.org/gems/bundler-timing


# Bundler::Timing

Bundler plugin to display timing statistics when installing gems. If you ever wondered which of your 200 or so gems
is causing your CI setup step to be slow, this might be helpful.

## Installation

Add this line to your Gemfile:

```ruby
plugin 'bundler-timing'
```

And then execute:

    $ bundle

Or install it globally as a plugin:

    $ bundler plugin install bundler-timing


## Usage
Once installed, `bundler install` will display additional log lines. This is current tageted at human consumption.

### Example

```
➜  bundle install
🕰️ Timing: 58 gems to install...
Fetching gem metadata from https://rubygems.org/.........
[...]
🕰️ Timing: msgpack-1.7.2(NATIVE EXTENSIONS) took	2.49 seconds
🕰️ Timing: bigdecimal-3.1.8(NATIVE EXTENSIONS) took	4.33 seconds
🕰️ Timing: prism-1.2.0(NATIVE EXTENSIONS) took	5.9 seconds
🕰️ Timing: zstd-ruby-1.5.6.6(NATIVE EXTENSIONS) took	9.05 seconds
🕰️ Timing: digest-crc-0.6.5(NATIVE EXTENSIONS) took	11.49 seconds
🕰️ Timing: gpgme-2.0.24(NATIVE EXTENSIONS) took	66.23 seconds
Updating files in vendor/cache
Bundle complete! 58 Gemfile dependencies, 204 gems now installed.
```
