class Trip < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  
  validates_presence_of :origin, :destination, :name

  after_create :route
  
  def first_step
    steps.find_by_previous_step_id(nil)
  end
  
  def points
    steps.collect{|l| l.points}.flatten
  end
  
  attr_accessor :center_point
  def center
    return @center_point if @center_point
    start = self.steps.find_by_previous_step_id(nil).start_point
    puts "Start: #{start.inspect}"
    finish = self.steps.find_by_next_step_id(nil).end_point
    puts "Finish: #{finish.inspect}"
    
    avg_lat = (start.latitude.to_f + finish.latitude.to_f) / 2.0
    avg_long = (start.longitude.to_f + finish.longitude.to_f) / 2.0
    
    @center_point = {:latitude => avg_lat, :longitude => avg_long}
  end
  
  def route #(origin,destination,name)
    
    # get json from google maps api
    response = JSON.parse(
      RestClient.get "http://maps.googleapis.com/maps/api/directions/json", 
        {:accept => :json, 
         :params => {
           :origin => self.origin, 
           :destination => self.destination, 
           :sensor => false }
        }
      )
      
    route = response['routes'].first
    leg = route['legs'].first
    steps = leg['steps']
    prev_step = nil
    steps.each do |step|
      new_step = Step.create(
        :trip_id => self.id,
        :start_point_id => Point.create(
          :latitude => step['start_location']['lat'],
          :longitude => step['start_location']['lng']
        ).id,
        :end_point_id => Point.create(
          :latitude => step['end_location']['lat'],
          :longitude => step['end_location']['lng']
        ).id,
        :instructions => step['html_instructions'],
        :distance => step['distance']['text'],
        :path => step['polyline']['points']
      )
      new_step.update_attribute(:previous_step_id,prev_step.id) if prev_step
      prev_step.update_attribute(:next_step_id,new_step.id) if prev_step 
      self.steps << new_step
      prev_step = new_step
    end
  end
end
