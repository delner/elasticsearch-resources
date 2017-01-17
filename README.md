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

There are four (4) basic resources which you can query with: `Cluster`, `Index`, `Type`, and `Document`.

#### Cluster

A `Elasticsearch::Resources::Cluster` represents an ElasticSearch cluster that hosts multiple indexes. You will always needs to create one to run queries.

```ruby
# Create a cluster with default settings (connects to '127.0.0.1:9200')
cluster = Elasticsearch::Resources::Cluster.new

# Create a cluster with custom host
cluster = Elasticsearch::Resources::Cluster.new do |cluster|
  cluster.host = 'davesawesomemovies.com:9200'
end
```

##### client

Returns the underlying `Elasticsearch::Transport::Client`.

```ruby
cluster.client
```

##### search

Accepts `(body, options = {})` and calls [`search`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method) on the `Elasticsearch::Transport::Client`.

Returns `Array[Elasticsearch::Resources::Document]` objects.

```ruby
cluster.search({ query: { match: { title: 'Tron' } } })
# => [#<Elasticsearch::Resources::Document>]
```

##### count

Accepts `(body, options = {})` and calls [`count`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#count-instance_method) on the `Elasticsearch::Transport::Client`.

Returns `Hash` response from `Elasticsearch::Transport::Client`.

```ruby
cluster.count({ query: { match: { title: 'Tron' } } })
# => {"count"=>1, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
```

#### Index

A `Elasticsearch::Resources::Index` represents an ElasticSearch index that contains multiple types. Requires a `Cluster` (see "Cluster" above.)

```ruby
# Create an index
index = Elasticsearch::Resources::Index.new(cluster: cluster) do |index|
  index.name = 'film'
end
```

##### client

Returns the underlying `Elasticsearch::Transport::Client`.

```ruby
index.client
```

##### search

Accepts `(body, options = {})` and calls [`search`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` option to your queries.

Returns `Array[Elasticsearch::Resources::Document]` objects.

```ruby
index.search({ query: { match: { title: 'Tron' } } })
# => [#<Elasticsearch::Resources::Document>]
```

##### count

Accepts `(body, options = {})` and calls [`count`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#count-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` option to your queries.

Returns `Hash` response from `Elasticsearch::Transport::Client`.

```ruby
index.count({ query: { match: { title: 'Tron' } } })
# => {"count"=>1, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
```

##### exists?

Calls [`exists?`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Indices/Actions#exists-instance_method) on the `Elasticsearch::API::Indices::IndicesClient`.

Returns `true` or `false`.

```ruby
index.exists?
# => true
```

##### create

Calls [`create`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Indices/Actions#create-instance_method) on the `Elasticsearch::API::Indices::IndicesClient`.

Throws error if index already exists.

```ruby
index.create
```

##### put_mapping

Accepts `(options = {})` and calls [`put_mapping`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Indices/Actions#put_mapping-instance_method) on the `Elasticsearch::API::Indices::IndicesClient`.

```ruby
index.put_mapping(type: 'movies', body: { })
```

##### delete

Calls [`delete`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Indices/Actions#delete-instance_method) on the `Elasticsearch::API::Indices::IndicesClient`.

Throws error if index doesn't exists.

```ruby
index.delete
```

## Development

Install dependencies using `bundle install`. Run tests using `bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/delner/elasticsearch-resources.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://raw.githubusercontent.com/delner/elasticsearch-resources/master/LICENSE).
