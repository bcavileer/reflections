require 'support/spec_helper'

describe 'Reporting' do
  before(:each) { DatabaseCleaner.clean }
  let(:user1) { User.create }
  let(:user2) { User.create }
  before(:each) { Widget.create user: user1 }

  describe 'when optional block returns true' do
    it 're-maps default belongs_to associations' do
      user1.map_associations_to(user2) { true }
      Widget.first.user.should eq(user2)
    end
  end

  describe 'when optional block returns false' do
    it 'does not re-map default belongs_to associations' do
      user1.map_associations_to(user2) { false }
      Widget.first.user.should eq(user1)
    end
  end

  describe 'using it for a report' do
    it 'works?' do
      user1.map_associations_to(user2) do |record, from_object, to_object|
        record.should == Widget.first
        from_object.should == user1
        to_object.should == user2
      end
    end
  end
end
