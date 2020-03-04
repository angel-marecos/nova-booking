class EstatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_estate, only: %i[show edit update destroy]

  # GET /estates
  # GET /estates.json
  def index
    @estates = Estate.where(owner_id: current_user.id)
  end

  # GET /estates/1
  # GET /estates/1.json
  def show
  end

  # GET /estates/new
  def new
    @estate = Estate.new
    if Owner.find_by(user_id: current_user.id)
      @estate.owner_id = Owner.find_by(user_id: current_user.id).id
      @rooms = @estate.rooms.build
    else
      redirect_to new_owner_path
    end
  end
  
  # GET /estates/new_room
  def new_room
    @room = Room.new
  end

  # GET /estates/1/edit
  def edit
  end

  # POST /estates
  # POST /estates.json
  def create
    @estate = Estate.new(estate_params)

    respond_to do |format|
      if @estate.save
        format.html { redirect_to @estate, notice: 'Estate was successfully created.' }
        format.json { render :show, status: :created, location: @estate }
      else
        format.html { render :new }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estates/1
  # PATCH/PUT /estates/1.json
  def update
    respond_to do |format|
      if @estate.update(estate_params)
        format.html { redirect_to @estate, notice: 'Estate was successfully updated.' }
        format.json { render :show, status: :ok, location: @estate }
      else
        format.html { render :edit }
        format.json { render json: @estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estates/1
  # DELETE /estates/1.json
  def destroy
    @estate.destroy
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Estate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # dar de alta una propiedad
  def suscribe
    @estate = Estate.find(params[:id])
    @estate.update_attribute(:status, true)
    respond_to do |format|
      format.html { redirect_to estates_url, notice: 'Estate was successfully suscribed.' }
      format.json { head :no_content }
    end
  end

  # dar de baja una propiedad
  def unsuscribe
    @estate = Estate.find(params[:id])
    @estate.update_attribute(:status, false)
    respond_to do |format|  
      format.html { redirect_to estates_url, notice: 'Estate was successfully unsuscribed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_estate
    @estate = Estate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def estate_params
    params.require(:estate).permit(:name, :address, :city_id, :owner_id, :estate_type, images: [], rooms_attributes: %i[id estate_id description capacity price status room_type])
  end
end
