# Chromium::Pdf

A gem wrapping the Chrome print-to-pdf functionality used for creating pdf files.

It includes generators for establishing a template framework for implementing the generation into GoodJobs.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'chromium-pdf', github: 'RoleModel/chromium-pdf'
```

And then execute:
```shell
bundle
```

## Usage

Run the installation generator to create dependency templates with:
```shell
bin/rails g chromium:pdf:install
```

This will create an example job file, GoodJobs initializer, and app.json.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RoleModel/chromium-pdf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
