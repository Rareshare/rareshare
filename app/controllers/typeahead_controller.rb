class TypeaheadController < ApplicationController

  def show
    model_class = params[:id].classify.constantize
    names = model_class.select("name").search(name: "#{params[:q]}:*").limit(self.limit).map(&:name)
    render json: names
  rescue => e
    Rails.logger.error e
    render json: []
  end

  def limit
    params[:items].try(:to_i) || 8
  end

end