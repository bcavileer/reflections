require 'support/spec_helper'

describe Reflections::Remapper do

  let(:user1) { User.create }
  let(:user2) { User.create }

  before(:each) { DatabaseCleaner.clean }

  describe 'Remapping to a different class' do
    it 'raises an error' do
      class OtherClass < ActiveRecord::Base; end

      expect { user1.map_belongs_to_associations_to OtherClass.new }.
          to raise_error(Reflections::Remapper::NotSameClass)
    end
  end

  describe 'default belongs_to' do
    it 're-maps default belongs_to associations' do
      class Widget < ActiveRecord::Base
        belongs_to :user
      end

      Widget.create :user => user1

      user1.map_belongs_to_associations_to user2

      Widget.first.user.should eq(user2)
    end
  end

  describe 'Remapping custom named belongs_to' do
    it 're-maps custom named belongs_to associations' do
      class Widget < ActiveRecord::Base
        belongs_to :creator, :class_name => 'User'
      end

      Widget.create :creator => user1

      user1.map_belongs_to_associations_to user2

      Widget.first.creator.should eq(user2)
    end
  end
end
