require 'spec_helper'

describe User do
  before(:all) do
    User.collection.drop
  end
  
  before(:each) do
    @valid_attributes = {
      :name => 'Emily Price',
      :email => 'price.emily@gmail.com',
      :username => 'eprice',
      :nickname => 'Emily'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
