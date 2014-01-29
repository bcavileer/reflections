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

## Usage

    user1 = User.create

    user2 = User.create

    Widget.create user: user1

    OtherClass.create user: user1

    user1.map_associations_to user2

    you can optionally control the associations

    user1.map_associations_to(user2, types: %w(belongs_to has_and_belongs_to_many))

    you can optionally control the updating of the associations
    or create reports by passing a block

    user1.map_associations_to(user2) do |record, association|
      puts "Remapping #{association.macro} for #{record} from #{user1} to #{user2}"
      false # don't actually do update
    end

    you can also control the classes remapped with :only and :exclude

    user1.map_associations_to(user2, only: [Widget])

    user1.map_associations_to(user2, except: [OtherClass])

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
