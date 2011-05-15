class TripsController < ApplicationController
  
  before_filter :find_trip, :except => [:index, :new, :create]
  # GET /trips
  # GET /trips.xml
  # GET /trips.json
  def index
    @trips = Trip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])

    # @trip.steps.each do |step|
    #   marker = Cartographer::Gmarker.new(
    #     :name => "marker",
    #     :marker_type => "Building",
    #     :position => [step.start_point.latitude, step.start_point.longitude],
    #     :info_window_url => "/",
    #     :icon => @icon)
    #   @map.markers << marker
    # end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @trip }
    end

  end
  
  def mapview
    respond_to do |format|
      format.html  { render :layout => 'map_page'}
    end
  end
  
  def steps
    respond_to do |format|
    format.json  { render :json => @trip.steps }
    end
  end
  
  def directions
    respond_to do |format|
      format.html
      format.json {render :json => @trip.steps.map {|s| s.instructions}} 
    end
  end

  def points
    respond_to do |format|
      format.json { render :json => @trip.points }
    end
  end

  # GET /trips/new
  # GET /trips/new.xml
  def new
    @trip = Trip.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new(params[:trip])

    respond_to do |format|
      if @trip.save
        format.html { redirect_to(@trip, :notice => 'Trip was successfully created.') }
        format.xml  { render :xml => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to(@trip, :notice => 'Trip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to(trips_url) }
      format.xml  { head :ok }
    end
  end
  
  def map
    @trip = Trip.find(params[:id])
    @map = Cartographer::Gmap.new( 'map' )
    @map.zoom = :bound
    @icon = Cartographer::Gicon.new()
    @map.icons <<  @icon
    @trip.steps.each do |step|
      marker = Cartographer::Gmarker.new(
        :name => "marker",
        :marker_type => "Building",
        :position => [step.start_point.latitude.to_f, step.start_point.longitude.to_f],
        :icon => @icon)
      @map.markers << marker
    end
  end

private
 
  def find_trip
    @trip = Trip.find(params[:id])
  end

end
