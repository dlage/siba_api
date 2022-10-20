# SIBA API Wrapper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library
into a gem. Put your Ruby code in the file `lib/siba_api`. To experiment with that code, run `bin/console` for an
interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'siba_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install siba_api

## Usage

TODO: Write usage instructions here

## Examples

```ruby
siba = SIBAApi.new(wsdl: 'https://siba.sef.pt/bawsdev/boletinsalojamento.asmx?wsdl', hotel_unit: '121212121', establishment: '00', access_key: '999999999')
r = siba.deliver_bulletins(123, [{ surname: 'Surname', name: 'Name', nationality: 'VEN', birthdate: '199
9-01-01T00:00:00', place_of_birth: 'Place of Birth', id_document: '123456789', document_country: 'YEM', document_type: 'P
', origin_country: 'USA', start_date: '2022-08-01T00:00:00', end_date: '2022-08-31T00:00:00', origin_place: 'Place of Res
idence', }])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dlage/siba_api. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/dlage/siba_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SEF_API project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/dlage/siba_api/blob/master/CODE_OF_CONDUCT.md).
