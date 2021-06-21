class Api::V1::ItemsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:open_newers_registration]
  
  def open_newers_registration
    respond_with open_newers_registration: GeneralSetup.permitir_registros_nuevos, open_leveling_newers_registration: GeneralSetup.enable_leveling
  end

  def index
    respond_with Item.all
  end

  def create
    respond_with :api, :v1, Item.create(item_params)
  end

  def destroy
    respond_with Item.destroy(params[:id])
  end

  def update
    item = Item.find(params["id"])
    item.update_attributes(item_params)
    respond_with item, json: item
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :description)
  end
end