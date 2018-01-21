# FileWriter

The simplistic way to overwrite a file with new content is to
simply open and truncate the file and write to it, but that risks
data-loss in the case of a power loss or write error.

The goal of FileWriter is to package up the best practice in the
one specific use-case of replacing a file entirely with new
content.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'file_writer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install file_writer

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake spec` to run the tests. You
can also run `bin/console` for an interactive prompt that
will allow you to experiment.

To install this gem onto your local machine, run
`bundle exec rake install`. To release a new version,
update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag
for the version, push git commits and tags, and push the
`.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/vhokstad/file_writer.


## License

The gem is available as open source under the terms of
the [MIT License](http://opensource.org/licenses/MIT).
