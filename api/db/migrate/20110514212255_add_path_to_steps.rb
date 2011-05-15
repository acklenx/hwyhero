class AddPathToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :path, :string
  end

  def self.down
    remove_column :steps, :path
  end
end
