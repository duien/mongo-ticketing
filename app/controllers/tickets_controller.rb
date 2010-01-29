class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all( :order => 'updated_at desc')
  end

  def show
    @ticket = Ticket.find( params[:id] )
  end
  
  def new
    @ticket = Ticket.new(params[:ticket])
    if request.post?
      if @ticket.save
        flash[:notice] = "Ticket created"
        redirect_to tickets_path
      else
        flash[:notice] = "Unable to create ticket"
        redirect_to new_ticket_path
      end
    end
  end
  
end
