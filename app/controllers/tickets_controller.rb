class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all( :order => 'updated_at desc')
  end

  def show
    @ticket = Ticket.find( params[:id] )
  end
end
