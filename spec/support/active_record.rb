require 'active_record'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Migration.verbose = false

ActiveRecord::Migration.create_table :users do |t|
  t.timestamps
end

ActiveRecord::Migration.create_table :widgets do |t|
  t.references :user
  t.references :creator
  t.timestamps
end

ActiveRecord::Migration.create_table :other_classes do |t|
  t.references :user
  t.timestamps
end

ActiveRecord::Migration.create_table :users_widgets do |t|
  t.references :user
  t.references :widget
end

class User < ActiveRecord::Base; end

class Widget < ActiveRecord::Base
  belongs_to :user
end

class OtherClass < ActiveRecord::Base
  belongs_to :user
end
