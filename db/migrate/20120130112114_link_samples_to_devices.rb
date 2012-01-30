class LinkSamplesToDevices < ActiveRecord::Migration
  def change
    add_column :samples, :device_id, :integer
  end
end
