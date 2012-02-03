class RemoveDeviceTime < ActiveRecord::Migration
  def change
    remove_column :samples, :device_time
  end
end
