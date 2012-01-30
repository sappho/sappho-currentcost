class AddSampleUploadCode < ActiveRecord::Migration
  def change
    add_column :devices, :upload_code, :string
  end
end
