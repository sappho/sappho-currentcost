class SamplesController < ApplicationController
  # POST /samples
  # POST /samples.json
  def create
    sample = params[:sample]
    devices = Device.where :upload_code => sample[:upload_code]
    if devices.size == 1
      sample[:device_id] = devices[0].id
      @sample = Sample.new(sample)
      if @sample.save
        format.json { render :json => @sample, :status => :created, :location => @sample }
      else
        format.json { render :json => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end
end
