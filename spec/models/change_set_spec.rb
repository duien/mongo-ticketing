require 'spec_helper'

describe ChangeSet do
  before(:each) do
    @valid_attributes = {
      :what_changed => {
        'subject' => [ "original subject", "updated subject" ],
        'description' => [ nil, "added description" ],
        'comments' => [ [], [1] ]
      },
      :timestamp => Time.now
    }
  end

  it "should list changed keys" do
    c = ChangeSet.new(@valid_attributes)
    c.should have(3).changed_keys
    c.changed_keys.should include( 'subject', 'description', 'comments' )
  end
end
