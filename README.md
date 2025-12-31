# ArgsMatcher

`ArgsMatcher` is a Ruby gem that enables pattern matching on method arguments, making it easier to write expressive and readable code.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add args_matcher
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install args_matcher
```

## Usage

To use `ArgsMatcher`, include the `ArgsMatcher::Matcher` module in your class. This will give you access to the `args` method, which you can use in a `case` statement to pattern match against the arguments passed to a method.

Here's an example of how to use it:

```ruby
class Greeter
  include ArgsMatcher::Matcher

  def greet(...) = case args
  in {name:}
    "Hi, #{name}!"
  in name, other, {with:}
    "#{with}, #{name} and #{other}!"
  in name, greeting
    "#{greeting}, #{name}!"
  in name
    "Hello, #{name}!"
  end
end

greeter = Greeter.new
puts greeter.greet("Alice") #=> "Hello, Alice!"
puts greeter.greet("Bob", "Good morning") #=> "Good morning, Bob!"
puts greeter.greet("Alice", "Bob", with: "Good afternoon") #=> "Good afternoon, Alice and Bob!"
puts greeter.greet(name: "Clara") #=> "Hi, Clara!"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pabloh/args_matcher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

