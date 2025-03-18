class ModelsController < ApplicationController
  before_action :set_model, only: [:update]
  before_action :set_brand, only: [:index, :create]

  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    
    if params[:brand_id]
      # GET /brands/:id/models
      @models = @brand.models
      total_count = @models.count
      
      # Apply pagination
      @models = @models.offset((page - 1) * per_page).limit(per_page)
      
      render json: {
        models: @models.map { |model| model_json(model) },
        meta: {
          current_page: page,
          per_page: per_page,
          total_count: total_count,
          total_pages: (total_count.to_f / per_page).ceil
        }
      }
    else
      # GET /models
      @models = Model.all
      @models = @models.where('average_price > ?', params[:greater]) if params[:greater].present?
      @models = @models.where('average_price < ?', params[:lower]) if params[:lower].present?
      
      total_count = @models.count
      
      # Apply pagination
      @models = @models.offset((page - 1) * per_page).limit(per_page)
      
      render json: {
        models: @models.map { |model| model_json(model) },
        meta: {
          current_page: page,
          per_page: per_page,
          total_count: total_count,
          total_pages: (total_count.to_f / per_page).ceil
        }
      }
    end
  end

  def create
    @model = @brand.models.new(model_params)
    
    if @model.save
      render json: model_json(@model), status: :created
    else
      render json: { errors: @model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @model.update(model_update_params)
      render json: model_json(@model)
    else
      render json: { errors: @model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_model
    @model = Model.find_by(id: params[:id])
    unless @model
      render json: { error: "Model not found" }, status: :not_found
      return
    end
  end
  
  def set_brand
    if params[:brand_id]
      @brand = Brand.find_by(id: params[:brand_id])
      unless @brand
        render json: { error: "Brand not found" }, status: :not_found
        return
      end
    end
  end

  def model_params
    params.permit(:name, :average_price)
  end
  
  def model_update_params
    params.permit(:average_price)
  end
  
  def model_json(model)
    {
      id: model.id,
      name: model.name,
      average_price: model.average_price
    }
  end
end