class PublicController < ApplicationController
  
  layout :index_or_public # a conditional layout (see below)


  before_action :setup_navigation 
  #see bottom, setup for all actions on this page
  before_action :find_state
  # make sure all each pages have access to their state and below city, loc, user
  before_action :find_city
  before_action :find_loc
  before_action :find_user


  def index
    # display index page
  end

  def city
  	@city = City.where(:permalink => params[:permalink], :visible => true).first
  	if @city.nil?
  		redirect_to(:action => 'index')
  	else
  		#display the city content using city.html.erb
  	end
  end

  def state
    # public page showing state with all its cities
    @state = State.where(:name => params[:name], :visible => true).first
    if @state.nil?
      redirect_to(:action => 'index')
    else
      #display the state content using state.html.erb
    end
  end

  def new
   # @loc = Loc.new({:city_id => @city.id, :name => "New Remote Location..."})
   # @cities = @city.state.cities.sorted
   # @loc_count = Loc.count + 1
  end

  def create
    @locs = Loc.new(loc_params)
    if @locs.save
      flash[:notice] = "Location has been submitted successfully."
      redirect_to(:action => 'index')
    else
      render(:controller => 'access', :action =>'addLoc')
    end
  end

  def each
    @loc = Loc.find(params[:id])
  end

  private

  # Conditions for layout choice
  def index_or_public
    if action_name == "index"
      "index_main"
    else
      "public"
    end
  end

  def setup_navigation
     @states = State.visible.sorted
  end

  def find_state 
     if params[:state_id]
      @state = State.find(params[:state_id])
     end
  end

  def find_city
     if params[:city_id]
      @city = City.find(params[:city_id])
     end
  end

  def find_loc
     if params[:loc_id]
      @loc = Loc.find(params[:loc_id])
     end
  end

  def find_user
     if params[:user_id]
      @user = User.find(params[:user_id])
     end
  end

  def loc_params
      params.require(:loc).permit(:city_id, :name, :phone, :address, :website, :position, :visible, :content, :created_at, :user_city)
  end
end