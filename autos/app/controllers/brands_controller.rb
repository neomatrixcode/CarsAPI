class BrandsController < ApplicationController
  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    
    @brands = Brand.all
    total_count = @brands.count
    
    # Apply pagination
    @brands = @brands.offset((page - 1) * per_page).limit(per_page)
    
    render json: {
      brands: @brands.map { |brand| brand_json(brand) },
      meta: {
        current_page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: (total_count.to_f / per_page).ceil
      }
    }
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      render json: brand_json(@brand), status: :created
    else
      render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def brand_params
    params.permit(:name)
  end
  
  def brand_json(brand)
    {
      id: brand.id,
      nombre: brand.name,
      average_price: brand.average_price
    }
  end
end