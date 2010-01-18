require 'spec_helper'

describe ChangeDetection do
  after :each do
    Object.send :remove_const, 'Foo' if defined?(Foo)
    Object.send :remove_const, 'Bar' if defined?(Bar)
  end

  context "when setting up change detection" do

    it "should define class method detect_changes_for" do
      lambda{
        class Foo
          include MongoMapper::Document
          include ChangeDetection

          key :foo
          detect_changes_for :foo
        end
      }.should_not raise_error
    end

    it "should add a key to change detection set" do
      class Foo
        include MongoMapper::Document
        include ChangeDetection

        key :foo
        detect_changes_for :foo
      end

      Foo.changes_detected_for.should == [:foo]
    end

    it "should only add key to its own change detection set" do
      class Foo
        include MongoMapper::Document
        include ChangeDetection

        key :foo
        detect_changes_for :foo
      end

      class Bar
        include MongoMapper::Document
        include ChangeDetection

        key :bar
      end

      Bar.changes_detected_for.should be_empty
    end

  end # when setting up change detection

  context "#detect_changes" do
    context "when used with a key" do
      before :each do
        class Foo
          include MongoMapper::Document
          include ChangeDetection

          key :foo, Array
          detect_changes_for :foo
        end
      end

      it "should mark dirty if changed" do
        f = Foo.create!
        f.foo << "something"
        f.detect_changes
        f.should be_changed
        f.changes.should == { 'foo' => [ [], ['something'] ] }
      end

      it "should not mark dirty if not changed" do
        f = Foo.create!
        f.detect_changes
        f.should_not be_changed
      end
    end # when used with a key

    context "when used with an association" do
      before :each do
        class Foo
          include MongoMapper::Document
          include ChangeDetection

          many :bars
          detect_changes_for :bars
        end

        class Bar
          include MongoMapper::EmbeddedDocument
        end
      end

      it "should mark dirty if changed" do
        f = Foo.create!
        b = Bar.new
        f.bars << b
        f.detect_changes
        f.should be_changed
        f.changes.should == { 'bars' => [ [], [b] ] }
      end

      it "should not mark dirty if not changed" do
        f = Foo.create!
        f.detect_changes
        f.should_not be_changed
      end

    end # when used with an association

  end # in use
end # describe ChangeDetection
