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
use Rack::Rejector, body: 'No Teapot' do |request, options|
  !request.get?
end
```

Available options are:
```ruby
options.body = "I'm a teapot" # Default: '503 SERVICE UNAVAILABLE'
options.code = 418 # Default: 503
options.headers = { 'x-teapot' => 'teapot' } # Default: {}
```

You can set them either at initialization or override them in the block.


## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rake` to run the tests.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ivx/rack-rejector.
