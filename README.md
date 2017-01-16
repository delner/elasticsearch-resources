Elasticsearch::Resources
========================

[![Build Status](https://travis-ci.org/delner/elasticsearch-resources.svg?branch=master)](https://travis-ci.org/delner/elasticsearch-resources) ![Gem Version](https://img.shields.io/gem/v/elasticsearch-resources.svg?maxAge=2592000)
###### *For Ruby 2.3+*

`Elasticsearch::Resources` is a wrapper for the [Elasticsearch gem](https://github.com/elastic/elasticsearch-ruby) that provides a strongly typed interface for accessing your indexes, types, and documents.

```ruby
# Search an index: e.g. search { index: 'film', body: { query: { ... } } }
documents = film.search({ query: { match: { title: 'Tron' } } })
documents # [#<Movie @title='Tron'>, #<Documentary @title='Making Tron'>]

# Get a specific document: e.g. get { index: 'film', type: 'movie', id: 'tron' }
document = movies.get(id: 'tron') # #<Movie @title='Tron'>
document.id # => 'tron'
document.attributes # => { 'title' => 'Tron' }
document.title # => 'Tron'
```

### Installation

##### If you're not using Bundler...

Install the gem via:

```
gem install elasticsearch-resources
```

Then require it into your application with:

```
require 'elasticsearch/resources'
```

##### If you're using Bundler...

Add the gem to your Gemfile:

```
gem 'elasticsearch/resources'
```

And then `bundle install` to install the gem and its dependencies.

### Usage

###### TODO: Add explanation of basic usage

## Development

Install dependencies using `bundle install`. Run tests using `bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/delner/elasticsearch-resources.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://raw.githubusercontent.com/delner/elasticsearch-resources/master/LICENSE).
