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
      Widget.create :user => user1
      user1.map_associations_to user2
      Widget.first.user.should eq(user2)
    end
  end

  describe 'Remapping custom named belongs_to' do
    it 're-maps custom named belongs_to associations' do
      Widget.belongs_to :creator, :class_name => 'User'
      Widget.create :creator => user1
      user1.map_associations_to user2
      Widget.first.creator.should eq(user2)
    end
  end

  describe 'Remapping has_and_belongs_to_many' do
    it 're-maps has_and_belongs_to_many associations' do
      Widget.has_and_belongs_to_many :users
      Widget.create :users => [user1]
      user1.map_associations_to user2
      users = Widget.first.users
      users.should include(user2)
      users.should_not include(user1)
    end
  end

  describe 'Remapping specific association type' do
    it 're-maps has_and_belongs_to_many associations but not the belongs_to' do
      Widget.belongs_to :user
      Widget.has_and_belongs_to_many :users
      Widget.create :user => user1, :users => [user1]
      user1.map_associations_to user2, only: ['has_and_belongs_to_many']
      Widget.first.users include(user2)
      Widget.first.user.should eq(user1)
    end
  end
end
