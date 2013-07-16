class UnitsController < ApplicationController
  def show
    unit = AvailableUnit.where(name: params[:id]).first

    if unit.present?
      render json: unit.as_json
    else
      render json: { error: "Not found: #{params[:id]}" }, status: :not_found
    end
  end
end
