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

    old_account = User.find_by_email 'user@olddomain.com'

    new_account = User.find_by_email 'user@newdomain.com'

    old_account.map_associations_to new_account

    you can optionally control the associations

    old_account.map_associations_to(new_account, only: %w(belongs_to has_and_belongs_to_many))

    you can optionally control the updating of the associations
    or create reports by passing a block

    old_account.map_associations_to(new_account) do |record, from_object, to_object|
      puts "Remapping #{record} from #{from_object} to #{to_object}"
      false # don't actually do update
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
