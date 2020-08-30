class BillboardsController < ApplicationController
  before_action :set_billboard, only: [:show, :edit, :update, :destroy]

  # GET /billboards
  # GET /billboards.json
  def index
    @billboards = Billboard.all
  end

  # GET /billboards/1
  # GET /billboards/1.json
  def show
  end

  # GET /billboards/new
  def new
    @billboard = Billboard.new
  end

  # GET /billboards/1/edit
  def edit
  end

  # POST /billboards
  # POST /billboards.json
  def create
    @billboard = Billboard.new(billboard_params)

    respond_to do |format|
      if @billboard.save
        format.html { redirect_to @billboard, notice: 'Billboard was successfully created.' }
        format.json { render :show, status: :created, location: @billboard }
      else
        format.html { render :new }
        format.json { render json: @billboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billboards/1
  # PATCH/PUT /billboards/1.json
  def update
    respond_to do |format|
      if @billboard.update(billboard_params)
        format.html { redirect_to @billboard, notice: 'Billboard was successfully updated.' }
        format.json { render :show, status: :ok, location: @billboard }
      else
        format.html { render :edit }
        format.json { render json: @billboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billboards/1
  # DELETE /billboards/1.json
  def destroy
    @billboard.destroy
    respond_to do |format|
      format.html { redirect_to billboards_url, notice: 'Billboard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billboard
      @billboard = Billboard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billboard_params
      params.require(:billboard).permit(:name, :content)
    end
end
