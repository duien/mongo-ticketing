class TicketsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    finder_options = { :order => 'updated_at desc' }
    if params[:status].nil?
      finder_options[:status.in] = [ :new, :open ]
    else
      finder_options[:status.in] = params[:status].map(&:to_sym)
    end
    @tickets = Ticket.all( finder_options )
    respond_to do |format|
      format.html
      format.json  { render :json => @tickets.to_json(:only => [ :subject, :description, :status, :_id ]) }
      # format.xml  { render :xml => @tickets.to_xml(:only => [ :subject, :description, :status, :_id ]) }
    end
  end

  def show
    @ticket = Ticket.find_by_short_id( params[:id] )
    respond_to do |format|
      format.html
      format.json  { render :json => @ticket.to_json }
    end
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
    @ticket = Ticket.find_by_short_id( params[:id] )
  end
  
  def update
    @ticket = Ticket.find_by_short_id( params[:id] )
    if @ticket.update_attributes!( params[:ticket] )
      flash[:notice] = "Ticket updated"
      redirect_to @ticket
    else
      flash[:error] = "Unable to update ticket"
      render :action => 'edit'
    end
  end
  
end
