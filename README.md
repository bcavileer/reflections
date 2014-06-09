# Reflections

Given an ActiveRecord object, it re-maps relationships to another object
of the same class.  Useful for reconciling database with accounts for same user, etc.

## Installation

Add this line to your application's Gemfile:

gem 'reflections'

And then execute:

$ bundle

Or install it yourself as:

$ gem install reflections

## Basic Usage
###Given
```ruby
user1 = User.create 
=> #<User:1>
user2 = User.create
=> #<User:2>
foo = Foo.create user: user1
=> #<Foo:1>
bar = Bar.create user: user1
=> #<Bar:1>
```
###When
```ruby
user1.map_associations_to user2
```
### Then
```ruby
foo.user
=> #<User:2>
bar.user == user2
=> true
  
```
  
##Optionally control the associations
```
user1.map_associations_to(user2, types: %w(belongs_to has_and_belongs_to_many))
```
##Optionally control updating of associations

```
user1.map_associations_to(user2) do |record, association|
  false # don't actually do update
end
```

##Create reports

```
user1.map_associations_to(user2) do |record, association|
  puts "Remapping #{association.macro} for #{record} from #{user1} to #{user2}"
  false # don't actually do update
end
```

##Control the classes remapped with :only and :exclude
```
user1.map_associations_to(user2, only: [Foo])
user1.map_associations_to(user2, except: [Bar])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
