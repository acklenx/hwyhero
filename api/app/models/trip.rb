class Trip < ActiveRecord::Base
  has_many :steps
  
  def first_step
    steps.find_by_previous_step_id(nil)
  end
  
  def points
    legs.collect{|l| l.points}.flatten
  end
  
  def self.route(origin,destination,name)
    # get json from google maps api
    response = JSON.parse(
      RestClient.get "http://maps.googleapis.com/maps/api/directions/json", 
        {:accept => :json, 
         :params => {
           :origin => origin, 
           :destination => destination, 
           :sensor => false }
        }
      )
      
    trip = Trip.create(:name => name, :origin => origin, :destination => destination)  
    route = response['routes'].first
    puts route.class
    puts route
    leg = route['legs'].first
    steps = leg['steps']
    prev_step = nil
    steps.each do |step|
      new_step = Step.create(
        :trip_id => trip.id,
        :start_point_id => Point.create(
          :latitude => step['start_location']['lat'],
          :longitude => step['start_location']['lng']
        ).id,
        :end_point_id => Point.create(
          :latitude => step['end_location']['lat'],
          :longitude => step['end_location']['lng']
        ).id
      )
      new_step.previous_step = prev_step if prev_step
      prev_step.next_step = new_step if prev_step 
      trip.steps << new_step
    end
  end
end
