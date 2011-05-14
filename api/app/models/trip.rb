class Trip < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  
  validates_presence_of :origin, :destination, :name

  after_create :route
  
  def first_step
    steps.find_by_previous_step_id(nil)
  end
  
  def points
    legs.collect{|l| l.points}.flatten
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
    puts route.class
    puts route
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
        :distance => step['distance']['text']
      )
      new_step.previous_step = prev_step if prev_step
      prev_step.next_step = new_step if prev_step 
      self.steps << new_step
    end
  end
end
