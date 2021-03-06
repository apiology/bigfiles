# BigFiles

[![Build Status](https://travis-ci.org/apiology/bigfiles.svg?branch=main)](https://travis-ci.org/apiology/bigfiles)

Simple tool to find the largest source files in your project - maybe
to target for refactoring!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bigfiles'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install bigfiles
```

## Usage

This is typically used as part of general use of the
[quality](https://github.com/apiology/quality) gem.  You can also run
it on the command line directly:

```sh
$ bigfiles
165: spec/big_files/big_files_spec.rb
76: .rubocop.yml
59: spec/big_files/file_with_lines_spec.rb
$
```

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/apiology/bigfiles). This project
is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pronto::Punchlist project’s codebases,
issue trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/apiology/bigfiles/blob/main/CODE_OF_CONDUCT.md).
