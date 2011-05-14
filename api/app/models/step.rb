class Step < ActiveRecord::Base
  belongs_to :trip
  has_one :next_step, :class_name => 'Step', :foreign_key => :next_step_id
  has_one :previous_step, :class_name => 'Step', :foreign_key => :previous_step_id
  has_one :start_point, :class_name => 'Point', :foreign_key => :start_point_id
  has_one :end_point, :class_name => 'Point', :foreign_key => :end_point_id
  
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
