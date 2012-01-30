class Device < ActiveRecord::Base
  has_many :samples, :dependent => :destroy
  validates :description, :presence => true, :uniqueness => true
end
