class Step < ActiveRecord::Base
  belongs_to :trip
  has_one :next_step, :class_name => 'Step', :foreign_key => :id
  has_one :previous_step, :class_name => 'Step', :foreign_key => :id
  has_one :start_point, :class_name => 'Point', :foreign_key => :id
  has_one :end_point, :class_name => 'Point', :foreign_key => :id
  
  before_destroy :cleanup
  
  def cleanup
    points.each :destroy
    # end_point.destroy
    # start_point.destroy
    previous_step.next_step = next_step if previous_step
    next_step.previous_step = previous_step if next_step
  end
  
  def points
    [start_point, end_point]
  end
end
