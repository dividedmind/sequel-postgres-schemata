# Sequel::Postgres::Schemata

Easily manipulate Postgres schemas in Sequel.

## Installation

Add this line to your application's Gemfile:

    gem 'sequel-postgres-schemata'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel-postgres-schemata

## Usage

```ruby
Sequel.extension :postgres_schemata

db = Sequel.connect adapter: 'postgres', search_path: %w(foo public)
db.create_schema :bar

db.search_path # => [:foo, :public]

db.search_path :baz do
  db.search_path # => [:baz]
end

db.search_path :baz, prepend: true do
  db.search_path # => [:baz, :foo, :public]
end

db.schemata # => [:pg_toast, :pg_temp_1, :pg_toast_temp_1, :pg_catalog, :public, :information_schema, :bar]
db.current_schemata # => [:public]
db.search_path = [:bar, :foo, :public]
db.current_schemata # => [:bar, :public]
db.rename_schema :bar, :foo
db.current_schemata # => [:foo, :public]
```

## Running the Tests

Install docker and docker-compose then run:

```
./run-tests.sh
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
