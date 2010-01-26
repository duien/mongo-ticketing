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
end
