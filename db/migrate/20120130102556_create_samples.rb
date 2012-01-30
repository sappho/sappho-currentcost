class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.datetime :sample_time
      t.datetime :device_time
      t.integer :power
      t.decimal :temperature

      t.timestamps
    end
  end
end
