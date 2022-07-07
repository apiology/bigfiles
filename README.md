# BigFiles

[![CircleCI](https://circleci.com/gh/apiology/bigfiles.svg?style=svg)](https://circleci.com/gh/apiology/bigfiles)


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

## Options

You can control what files are included and excluded, and how many files are reported:

```sh
$ bigfiles --help
Usage: bigfiles [options]
    -g, --glob glob here             Which files to parse - default is {Dockerfile,Rakefile,{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,java,js,json,py,rake,rb,scala,sh,swift,yml},{app,config,db,feature,lib,spec,src,test,tests,vars,www}/**/{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,java,js,json,py,rake,rb,scala,sh,swift,yml}}
    -e, --exclude-glob glob here     Files to exclude - default is none
    -h, --help                       This message
    -n, --num-files number-here      Top number of files to show--default 3
$
```

## Configuration

You can set different defaults for the above in a `.bigfiles.yml` in the current directory:

```yaml
---
bigfiles:
  num_files: 8
  include:
    glob: '**/*.my-favorite-extension'
  exclude:
    glob: fix.sh
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

## Contributions

This project, as with all others, rests on the shoulders of a broad
ecosystem supported by many volunteers doing thankless work, along
with specific contributors.

In particular I'd like to call out:

* [Audrey Roy Greenfeld](https://github.com/audreyfeldroy) for the
  cookiecutter tool and associated examples, which keep my many
  projects building with shared boilerplate with a minimum of fuss.
