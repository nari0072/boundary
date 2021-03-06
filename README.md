# Boundary

粒界のモデル構築，可視化ソフト．

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boundary'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install boundary
```

## Usage
command line interfaceを使っている．
```tcsh
Usage: boundary [options]
        --version                    show program Version.
    -d, --directory 'spec'           select the target directory.
    -m, --make '2 2 2 3'             make a boundary model.
    -v, --view '2 2 2 3'             view a boundary model.
```

- [maker](file.maker.html)
- viewはできたsvgファイルをopen -a safariで閲覧．

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec boundary` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daddygongon/boundary. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
