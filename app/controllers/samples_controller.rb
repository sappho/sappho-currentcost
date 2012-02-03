class SamplesController < ApplicationController
  # POST /samples
  # POST /samples.json
  def create
    respond_to do |format|
      sample = params[:sample]
      uploadCode = sample[:upload_code]
      devices = Device.where :upload_code => uploadCode
      if devices.size == 1
        sample[:device_id] = devices[0].id
        sample.delete :upload_code
        @sample = Sample.new(sample)
        if @sample.save
          format.json { render :json => @sample, :status => :created, :location => @sample }
        else
          format.json { render :json => @sample.errors, :status => :unprocessable_entity }
        end
      else
        format.json { render :json => { :upload_code => uploadCode }, :status => :unauthorized }
      end
      format.html { redirect_to root_path }
    end
  end
end
