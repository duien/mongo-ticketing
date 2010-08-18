require 'spec_helper'

describe TicketsController do
  
  before do
    ticket = mock_model(Ticket)
    Ticket.stub(:all).and_return([ticket])
  end
  
  describe 'index' do
    it "should set the tickets variable" do
      get 'index'
      assigns[:tickets]
    end
    
    it "should list new and open tickets by default" do
      # pending "figure out these expectation matchers"
      Ticket.should_receive(:all) do |options|
        operator, value = options.detect do |key, value| 
          key.instance_of? SymbolOperator
        end
        operator.instance_variable_get(:@operator).should eql('in')
        operator.instance_variable_get(:@field).should eql(:status)
        value.should == [:new, :open]
      end  
      #.with(hash_including(an_instance_of(SymbolOperator) => [ :new, :open ]))
      get 'index'
    end
    
    it "should order by created date" do
      Ticket.should_receive(:all).with(hash_including(:order => 'created_at desc'))
      get 'index'
    end
  end

end
