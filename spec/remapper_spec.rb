require 'support/spec_helper'

describe 'Remapping' do
  before(:each) { DatabaseCleaner.clean }
  let(:user1) { User.create }
  let(:user2) { User.create }

  describe 'Remapping to a different class' do
    it 'raises an error' do
      expect { user1.map_associations_to OtherClass.new }.
          to raise_error(Reflections::Remapper::NotSameClass)
    end
  end

  describe 'default belongs_to' do
    it 're-maps default belongs_to associations' do
      Widget.belongs_to :user
      Widget.create user: user1
      user1.map_associations_to user2
      Widget.first.user.should eq(user2)
    end

    it "doesn't affect other records" do
      Widget.belongs_to :user
      widget1 = Widget.create user: user1
      widget2 = Widget.create
      user1.map_associations_to user2
      widget1.reload.user.should eq(user2)
      widget2.reload.should_not eq(user2)
    end
  end

  describe 'Remapping custom named belongs_to' do
    it 're-maps custom named belongs_to associations' do
      Widget.belongs_to :creator, class_name: 'User'
      Widget.create creator: user1
      user1.map_associations_to user2
      Widget.first.creator.should eq(user2)
    end
  end

  describe 'Remapping has_and_belongs_to_many' do
    it 're-maps has_and_belongs_to_many associations' do
      Widget.has_and_belongs_to_many :users
      Widget.create users: [user1]
      user1.map_associations_to user2
      users = Widget.first.users
      users.should include(user2)
      users.should_not include(user1)
    end

    it "doesn't affect other records" do
      Widget.has_and_belongs_to_many :users
      widget1 = Widget.create users: [user1]
      widget2 = Widget.create
      user1.map_associations_to user2
      users = widget1.reload.users
      users.should include(user2)
      users.should_not include(user1)
      widget2.reload.users.should_not include(user2)
    end
  end

  describe 'Remapping specific association type' do
    it 'given symbol; re-maps has_and_belongs_to_many associations but not the belongs_to' do
      Widget.belongs_to :user
      Widget.has_and_belongs_to_many :users
      Widget.create user: user1, users: [user1]
      user1.map_associations_to user2, types: [:has_and_belongs_to_many]
      Widget.first.users include(user2)
      Widget.first.user.should eq(user1)
    end

    it 'given string; re-maps has_and_belongs_to_many associations but not the belongs_to' do
      Widget.belongs_to :user
      Widget.has_and_belongs_to_many :users
      Widget.create user: user1, users: [user1]
      user1.map_associations_to user2, types: ['has_and_belongs_to_many']
      Widget.first.users include(user2)
      Widget.first.user.should eq(user1)
    end
  end
end
