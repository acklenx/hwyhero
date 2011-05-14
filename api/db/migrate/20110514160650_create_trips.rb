class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.string :name, :null => false
      t.string :origin, :null => false
      t.string :destination, :null => false

      t.timestamps
    end
    
    create_table :steps do |t|
      t.integer :trip_id, :null => false
      t.string :distance
      t.integer :start_point_id, :null => false
      t.integer :end_point_id, :null => false
      t.integer :next_step_id, :default => nil
      t.integer :previous_step_id, :default => nil
      t.timestamps
    end
    
    create_table :points do |t|
      t.string :latitude, :null => false
      t.string :longitude, :null => false
    end
    
    add_index :steps, :trip_id
    add_index :trips, :name
    
  end

  def self.down
    drop_table :trips
    drop_table :legs
    drop_table :point
  end
end
