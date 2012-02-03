class DevicesController < ApplicationController
  # GET /devices
  # GET /devices.json
  def index
    if logged_in
      @devices = Device.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @devices }
      end
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    if logged_in
      @device = Device.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @device }
      end
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    if logged_in
      @device = Device.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @device }
      end
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id]) if logged_in
  end

  # POST /devices
  # POST /devices.json
  def create
    if logged_in
      @device = Device.new(params[:device])
      respond_to do |format|
        if @device.save
          format.html { redirect_to @device, :notice => 'Device was successfully created.' }
          format.json { render :json => @device, :status => :created, :location => @device }
        else
          format.html { render :action => "new" }
          format.json { render :json => @device.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    if logged_in
      @device = Device.find(params[:id])
      respond_to do |format|
        if @device.update_attributes(params[:device])
          format.html { redirect_to @device, :notice => 'Device was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @device.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    if logged_in
      @device = Device.find(params[:id])
      @device.destroy
      respond_to do |format|
        format.html { redirect_to devices_url }
        format.json { head :no_content }
      end
    end
  end

  private

  def logged_in
    respond_to do |format|
      format.html { redirect_to root_path, :notice => 'Access denied.' }
      format.json { render :json => {}, :status => :unauthorized }
    end unless session[:loggedIn]
    session[:loggedIn]
  end
end
