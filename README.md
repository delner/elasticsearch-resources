Elasticsearch::Resources
========================

[![Build Status](https://travis-ci.org/delner/elasticsearch-resources.svg?branch=master)](https://travis-ci.org/delner/elasticsearch-resources) [![Gem Version](https://badge.fury.io/rb/elasticsearch-resources.svg)](https://badge.fury.io/rb/elasticsearch-resources)
###### *For Ruby 2.3+*

`Elasticsearch::Resources` is a wrapper for the [Elasticsearch gem](https://github.com/elastic/elasticsearch-ruby) that provides a strongly typed interface for accessing your indexes, types, and documents.

```ruby
# Search an index: e.g. search { index: 'film', body: { query: { ... } } }
documents = film.search({ query: { match: { title: 'Tron' } } })
documents # [#<Movie @title='Tron'>, #<Documentary @title='Making Tron'>]

# Get a specific document: e.g. get { index: 'film', type: 'movies', id: 'tron' }
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

### Common use cases

##### Search all indexes in a cluster

```ruby
# Connects to default of '127.0.0.1:9200'
cluster = Elasticsearch::Resources::Cluster.new

# Hash can be any valid Elasticsearch query
documents = cluster.search({ query: { match: { title: 'Tron' } } })
```

##### Search all types in an index

```ruby
# Connects to default of '127.0.0.1:9200'
cluster = Elasticsearch::Resources::Cluster.new
documents = cluster.search({ index: 'film', query: { match: { title: 'Tron' } } })

# OR using a defined index
index = Elasticsearch::Resources::Index.new(cluster: cluster) do |index|
  index.name = 'film'
end

documents = index.search({ query: { match: { title: 'Tron' } } })
```

##### Search specific type in an index

```ruby
# Connects to default of '127.0.0.1:9200'
cluster = Elasticsearch::Resources::Cluster.new
documents = cluster.search({ index: 'film', type: 'movies', query: { match: { title: 'Tron' } } })

# OR using a defined index & type
index = Elasticsearch::Resources::Index.new(cluster: cluster) do |index|
  index.name = 'film'
end

type = Elasticsearch::Resources::Type.new(index: index) do |type|
  type.name = 'movies'
end

documents = type.search({ query: { match: { title: 'Tron' } } })
```

##### Creating a document

```ruby
# type: Elasticsearch::Resources::Type object
document = Elasticsearch::Resources::Document.new(type: type, id: 'tron', attributes: { title: 'Tron' })
document.create
```

##### Fetch a document

```ruby
document = type.get(id: 'tron')
```

### Resources

There are four (4) basic resources which you can query with: `Cluster`, `Index`, `Type`, and `Document`.

#### Cluster

An `Elasticsearch::Resources::Cluster` represents an ElasticSearch cluster that hosts multiple indexes. You will always needs to create one to run queries.

```ruby
# Create a cluster with default settings (connects to '127.0.0.1:9200')
cluster = Elasticsearch::Resources::Cluster.new

# Create a cluster with custom host
cluster = Elasticsearch::Resources::Cluster.new do |cluster|
  cluster.host = 'davesawesomemovies.com:9200'
end
```

##### indexes

Returns a `Hash` of well known indexes. Empty if no well-known indexes are defined (regardless of whether they actually exist in Elasticsearch.) See "Defining well known resources" and `define_indexes`.

```ruby
cluster.indexes
# => { film: #<Elasticsearch::Resources::Index> }
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

An `Elasticsearch::Resources::Index` represents an ElasticSearch index that contains multiple types. Requires a `Cluster` (see "Cluster" above.)

```ruby
# Create an index. You must set `name`.
index = Elasticsearch::Resources::Index.new(cluster: cluster) do |index|
  index.name = 'film'
end
```

##### name

Returns the name of the index, as it exists in Elasticsearch.

```ruby
index.name
# => 'film'
```

##### types

Returns a `Hash` of well known types. Empty if no well-known types are defined (regardless of whether they actually exist in Elasticsearch.) See "Defining well known resources" and `define_types`.

```ruby
index.types
# => { movies: #<Elasticsearch::Resources::Type> }
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

Throws error if index doesn't exist.

```ruby
index.delete
```

#### Type

An `Elasticsearch::Resources::Type` represents an ElasticSearch type within an index. Requires a `Index` (see "Index" above.)

```ruby
# Create a type. You must set `name`.
type = Elasticsearch::Resources::Type.new(index: index) do |type|
  type.name = 'movie'
end
```

##### name

Returns the name of the type, as it exists in Elasticsearch.

```ruby
type.name
# => 'movie'
```

##### client

Returns the underlying `Elasticsearch::Transport::Client`.

```ruby
type.client
```

##### search

Accepts `(body, options = {})` and calls [`search`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Returns `Array[Elasticsearch::Resources::Document]` objects.

```ruby
type.search({ query: { match: { title: 'Tron' } } })
# => [#<Elasticsearch::Resources::Document>]
```

##### count

Accepts `(body, options = {})` and calls [`count`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#count-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Returns `Hash` response from `Elasticsearch::Transport::Client`.

```ruby
type.count({ query: { match: { title: 'Tron' } } })
# => {"count"=>1, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
```

##### exists?

Accepts `(options = {})` and calls [`exists?`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#exists-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Returns `true` or `false`.

```ruby
type.exists?(id: 'tron')
# => true
```

##### create

Accepts `(options = {})` and calls [`create`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#create-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Throws error if document already exists.

```ruby
type.create(id: 'tron', body: { })
```

##### update

Accepts `(options = {})` and calls [`update`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#update-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

```ruby
type.update(id: 'tron', body: { })
```

##### delete

Accepts `(options = {})` and calls [`delete`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#delete-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Throws error if document doesn't exist.

```ruby
type.delete(id: 'tron')
```

##### get

Accepts `(options = {})` and calls [`get`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#get-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index` and `type` option to your queries.

Returns `Elasticsearch::Resources::Document`.

```ruby
type.get(id: 'tron')
# => #<Elasticsearch::Resources::Document>
```

#### Document

An `Elasticsearch::Resources::Document` represents an ElasticSearch document within an index. Requires an `id` and `Type` (see "Type" above.)

```ruby
# Create a document
document = Elasticsearch::Resources::Document.new(
  type: type, # (Required)
  id: 'tron', # (Required)
  attributes: { title: 'Tron' } # (Optional)
)
```

##### id

Returns a `String` of the Document ID.

```ruby
document.id
# => 'tron'
```

##### attributes

Returns a `Hash` of the Document body.

```ruby
document.attributes
# => { 'title' => 'Tron' }
```

##### client

Returns the underlying `Elasticsearch::Transport::Client`.

```ruby
document.client
```

##### exists?

Accepts `(options = {})` and calls [`exists?`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#exists-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index`, `type` and `id` option to your queries.

Returns `true` or `false`.

```ruby
document.exists?
# => true
```

##### create

Accepts `(options = {})` and calls [`create`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#create-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index`, `type`, `id`, and `body` option to your queries.

Throws error if document already exists.

```ruby
document.create
```

##### update

Accepts `(options = {})` and calls [`update`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#update-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index`, `type`, `id`, and `body` option to your queries.

```ruby
document.update
```

##### delete

Accepts `(options = {})` and calls [`delete`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#delete-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index`, `type` and `id` option to your queries.

Throws error if document doesn't exist.

```ruby
document.delete
```

##### get

Accepts `(options = {})` and calls [`get`](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#get-instance_method) on the `Elasticsearch::Transport::Client`. Automatically adds the `index`, `type` and `id` option to your queries.

Returns `Elasticsearch::Resources::Document`.

```ruby
document.get
# => #<Elasticsearch::Resources::Document>
```

### Defining well known resources

#### Cluster

```ruby
class DavesAwesomeMovies < Elasticsearch::Resources::Cluster
  # Set any default configuration settings here.
  define_configuration defaults: -> { |cluster|
    cluster.host = 'davesawesomemovies.com:9200'
  }

  # Provide a hash of keys to Index class names (either constants or strings)
  define_indexes film: 'Film'
end

cluster = DavesAwesomeMovies.new
cluster.indexes[:film] # => #<Film>
```

#### Index

```ruby
class Film < Elasticsearch::Resources::Index
  # Set any default configuration settings here.
  # Probably should set a name.
  define_configuration defaults: -> { |index|
    index.name = 'film'
  }

  # Provide a hash of keys to Type class names (either constants or strings)
  define_type movie: 'Movie'
end

film = Film.new
film.types[:movies] # => #<Movies>
```

#### Type

```ruby
class Movies < Elasticsearch::Resources::Type
  # Set any default configuration settings here.
  # Probably should set a name.
  define_configuration defaults: -> { |type|
    type.name = 'movie'
  }

  # Provide a Document class name (either constants or strings)
  # If not called, type will return Elasticsearch::Resources::Document objects instead.
  define_document 'Movie'
end

movies = Movies.new
movies.get(id: 'tron') # => #<Movie>
```

#### Document

```ruby
class Movie < Elasticsearch::Resources::Document
  # Provide a list of well known attributes
  define_attributes :title, :year
end

movie = Movie.new(id: 'tron', type: movies, attributes: { title: 'Tron', year: 1982 })
movie.title # => 'Tron'
movie.year # => 1982
```

## Development

Install dependencies using `bundle install`. Run tests using `bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/delner/elasticsearch-resources.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://raw.githubusercontent.com/delner/elasticsearch-resources/master/LICENSE).
