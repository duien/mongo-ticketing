class TicketsController < ApplicationController
  def index
    finder_options = { :order => 'updated_at desc' }
    if params[:status].nil?
      finder_options[:status.in] = [ :new, :open ]
    else
      finder_options[:status.in] = params[:status].collect{ |s| s.to_sym }
    end
    @tickets = Ticket.all( finder_options )
  end

  def show
    @ticket = Ticket.find( params[:id] )
  end
  
  def new
    @ticket = Ticket.new
  end
  
  def create
    @ticket = Ticket.new( params[:ticket] )
    if @ticket.save
      flash[:notice] = "Ticket created"
      redirect_to @ticket
    else
      flash[:error] = "Unable to create ticket"
      redirect_to new_ticket_path
    end
  end
  
  def edit
    @ticket = Ticket.find( params[:id] )
  end
  
  def update
    @ticket = Ticket.find( params[:id] )
    if @ticket.update_attributes( params[:ticket] )
      flash[:notice] = "Ticket updated"
      redirect_to @ticket
    else
      flash[:error] = "Unable to update ticket"
      render :action => 'edit'
    end
  end
  
end
