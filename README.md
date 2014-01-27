# Reflections

Given an ActiveRecord object, it re-maps any belongs_to relationships to another object
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

    old_account.map_belongs_to_associations_to new_account

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
