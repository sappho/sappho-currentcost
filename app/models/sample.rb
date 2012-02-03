class Sample < ActiveRecord::Base
  belongs_to :device
  validates_presence_of :device, :message => 'has not been defined'
  validates :sample_time, :power, :temperature, :presence => true
end
