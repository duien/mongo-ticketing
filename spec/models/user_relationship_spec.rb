require 'spec_helper'

describe UserRelationship do
  before(:each) do
    @valid_attributes = {
      
    }
  end
  
  it "should typecast type before validation" do
    u = UserRelationship.new(:type => 'watcher')
    u.valid?
    u.type.should == :watcher
  end

end
