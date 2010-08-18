require 'spec_helper'

describe Ticket do
  before(:each) do
    @valid_attributes = {
      :subject => 'This is a ticket',
      :description => 'More info about ticket'
    }
  end

  context "when first created" do
    subject{ Ticket.create!(@valid_attributes) }

    it{ should be_valid }
    it("should not create a changeset"){ should have(:no).change_sets }
    it("should defalt to :new status"){ subject.status.should == :new }
    it("should generate a short_id"){ subject.short_id.should match /[0-9a-f]{5,}/ }
  end
    
  context "with hash collision on short_id" do
    before do
      Digest::SHA1.stub(:hexdigest => Digest::SHA1.hexdigest(Time.now.to_s) )
    end

    let(:ticket_1){ Ticket.create!(@valid_attributes) }
    let(:ticket_2){ Ticket.create!(@valid_attributes) }

    it "should not create two identical short_ids" do
      ticket_1.short_id.should_not eql(ticket_2.short_id)
    end

    it "should make second short_id longer" do
      ticket_1.short_id # call this first since lets are lazy-loaded
      ticket_2.short_id.should match(%r/^#{ticket_1.short_id}/)
    end
  end

  context "when editing existing" do
    context "when setting an attribute" do
      let(:ticket) do 
        t = Ticket.create!(@valid_attributes)
        t.subject = 'A ticket about a thing'
        t.save!
        t
      end

      it "should create a changeset" do
        ticket.should have(1).change_sets
      end

      it "should set what_changed" do
        ticket.change_sets.first.what_changed.should == { 'subject' => [@valid_attributes[:subject],'A ticket about a thing'] }
      end

      it "should set updated_at" do
        ticket.change_sets.first.changed_at.should == ticket.updated_at
      end

    end

    context "when modifying an attribute" do
      let(:ticket) do 
        t = Ticket.create!(@valid_attributes)
        t.description.gsub!( /ticket/, 'this ticket')
        t.save!
        t
      end

      it "should create a change set" do
        ticket.should have(1).change_sets
      end

      it "should add changed attribute to what_changed" do
        ticket.change_sets.last.what_changed['description'].should == [ 'More info about ticket', 'More info about this ticket' ]
      end
    end

    it "should detect changes to comments" do
      t = Ticket.create!(@valid_attributes)
      t.comment = "This ticket is awesome"
      t.save!
      t.change_sets.last.what_changed.should be_empty
      t.change_sets.last.comment.should == "This ticket is awesome"
    end

    it "should not create change set if no visible changes" do
      t = Ticket.create!(@valid_attributes)
      t.change_sets << ChangeSet.new
      t.save!
      t.should have(1).change_sets
    end

   
    
    it "should only accept valid statuses" do
      t = Ticket.create!(@valid_attributes)
      t.status = :open
      t.save.should be_true
      t.status = :bogus
      t.save.should be_false
    end
  end # when editing existing
  
  it "should provide list of valid statuses" do
    Ticket.statuses.should == [ :new, :open, :resolved ]
  end
  
  it "should have some users" do
    pending
  end
  
  it "should use short_id for params" do
    t = Ticket.create!(@valid_attributes)
    t.to_param.should == t.short_id
  end

end
