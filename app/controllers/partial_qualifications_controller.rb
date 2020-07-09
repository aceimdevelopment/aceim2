class PartialQualificationsController < ApplicationController
  before_action :set_partial_qualification, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /partial_qualifications
  # GET /partial_qualifications.json
  def index
    @partial_qualifications = PartialQualification.all
  end

  # GET /partial_qualifications/1
  # GET /partial_qualifications/1.json
  def show
  end

  # GET /partial_qualifications/new
  def new
    @partial_qualification = PartialQualification.new
  end

  # GET /partial_qualifications/1/edit
  def edit
  end

  # POST /partial_qualifications
  # POST /partial_qualifications.json
  def create
    @partial_qualification = PartialQualification.new(partial_qualification_params)
    @partial_qualification.save
    # respond_with @partial_qualification, json: @partial_qualification
    render json: {data: @partial_qualification.academic_record.final_desc, status: :success}
  end

  # PATCH/PUT /partial_qualifications/1
  # PATCH/PUT /partial_qualifications/1.json
  def update
    @partial_qualification.update(partial_qualification_params)
    # respond_with @partial_qualification, json: @partial_qualification
    render json: {data: @partial_qualification.academic_record.final_desc, status: :success}
  end

  # DELETE /partial_qualifications/1
  # DELETE /partial_qualifications/1.json
  def destroy
    @partial_qualification.destroy
    respond_to do |format|
      format.html { redirect_to partial_qualifications_url, notice: 'Partial qualification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partial_qualification
      @partial_qualification = PartialQualification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def partial_qualification_params
      params.require(:partial_qualification).permit(:value, :qualification_schema_id, :academic_record_id)
    end
end
