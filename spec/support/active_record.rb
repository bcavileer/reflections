require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Migration.create_table :users do |t|
  t.timestamps
end

ActiveRecord::Migration.create_table :widgets do |t|
  t.string :name
  t.references :user
  t.references :creator
  t.timestamps
end

ActiveRecord::Migration.create_table :other_classes do |t|
  t.timestamps
end
