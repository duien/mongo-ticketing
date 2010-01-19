require 'spec_helper'

describe Ticket do
  before(:each) do
    @valid_attributes = {
      :subject => 'This is a ticket',
      :description => 'More info about ticket'
    }
  end

  context "when first created" do
    it "should create a new instance given valid attributes" do
      Ticket.create!(@valid_attributes)
    end

    it "should not create a changeset for initial creation" do
      Ticket.create!(@valid_attributes).change_sets.should be_empty
    end

    it "should defalt to :new status" do
      Ticket.create!(@valid_attributes).status.should == :new
    end
  end # when first created

  context "when editing existing" do
    it "should create a changeset when ticket is modified" do
      t = Ticket.create!(@valid_attributes)
      t.subject = 'A ticket about a thing'
      t.save!
      t.should have(1).change_sets
    end

    it "should set change set properties" do
      t = Ticket.create!(@valid_attributes)
      t.subject = 'A ticket about a thing'
      t.save!
      t.change_sets.first.what_changed.should == { 'subject' => [@valid_attributes[:subject],'A ticket about a thing'] }
      # t.change_sets.first.changed_at.should be_close(t.updated_at, 1)
      t.change_sets.first.changed_at.should == t.updated_at
    end

    it "should detect changes to comments" do
      t = Ticket.create!(@valid_attributes)
      c = Comment.new( :body => 'This ticket is awesome' )
      t.comments << c
      t.save!
      t.change_sets.last.what_changed.should have_key('comments')
    end

    it "should only save comment ids in history" do
      t = Ticket.create!(@valid_attributes)
      c = Comment.new( :body => 'This comment is awesome' )
      t.comments << c
      t.save!
      t.change_sets.last.what_changed['comments'].should == [ [], [c.id] ]
    end

    it "should not create change set if no visible changes" do
      t = Ticket.create!(@valid_attributes)
      t.change_sets << ChangeSet.new
      t.save
      t.should have(1).change_sets
    end
  end # when editing existing

  it "can have comments added" do
    t = Ticket.create!(@valid_attributes)
    t.comments << Comment.new( :body => 'This ticket is awesome' )
    t.should have(1).comments
  end

end
