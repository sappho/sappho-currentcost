class Device < ActiveRecord::Base
  has_many :samples, :dependent => :destroy
  validates :description, :upload_code, :presence => true, :uniqueness => true
end
