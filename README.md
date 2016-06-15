# Rack::Rejector

This gem is a Rack Middleware to reject requests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-rejector'
```

And then execute:

```Shell
    $ bundle
```

Or install it yourself as:

```Shell
    $ gem install rack-rejector
```
## Usage

You still have to write the conditions for rejection on your own.
The rest is handled by this gem. It will reject the request if the
given block evaluates to true. This example would grant access only to
GET requests:

```ruby
  use Rack::Rejector(body: 'No Teapot') do |request, options|
    !request.get?
  end
```

Available options are:
```ruby
  options.body = "I'm a teapot"
  options.code = 418
  options.headers = { 'x-teapot' => 'teapot' }
```

you can set them either at initialization or override them in the block


## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ivx/rack-rejector.
