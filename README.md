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

```sh
$ bundler --path=./somewhere42
[DEPRECATED] The `--path` flag is deprecated because it relies on being remembered across bundler invocations, which bundler will no longer do in future versions. Instead please use `bundle config set path './somewhere42'`, and stop using this flag
🕰️ Timing: 3 gems to install...
Fetching gem metadata from https://rubygems.org/....
Fetching https://github.com/Shopify/liquid
Fetching mini_portile2 2.8.7
Fetching bundler-timing 0.42.0
Installing bundler-timing 0.42.0
Installing mini_portile2 2.8.7
Fetching gpgme 2.0.24
Installing gpgme 2.0.24 with native extensions
🕰️ Timing: Timing report:
gem                   | ext?  | source                                                         | fetch (ms) | install (ms)
----------------------|-------|----------------------------------------------------------------|------------|--------------
liquid-b233b3d08106   | false | https://github.com/Shopify/liquid (at main@b233b3d)            |        915 |            0
bundler-2.6.0.dev     | false | installed ✔️                                                    |          0 |            0
liquid-5.6.0.alpha    | false | installed ✔️                                                    |          0 |           16
bundler-timing-0.42.0 | false | rubygems repository https://rubygems.org/ or installed locally |       1684 |         1723
mini_portile2-2.8.7   | false | rubygems repository https://rubygems.org/ or installed locally |       1657 |         1727
gpgme-2.0.24          | true  | rubygems repository https://rubygems.org/ or installed locally |        515 |        69019
----------------------|-------|----------------------------------------------------------------|------------|--------------
🕰️ Timing: Installed 3 gems in 72062 ms.
Bundle complete! 3 Gemfile dependencies, 5 gems now installed.
Bundled gems are installed into `./somewhere42`
```
