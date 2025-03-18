require 'json'

json_data = JSON.parse(File.read(Rails.root.join('db/models.json')))

# Group models by brand name
models_by_brand = json_data.group_by { |model| model['brand_name'] }

Brand.transaction do
  Model.transaction do
    models_by_brand.each do |brand_name, models|
      # Create the brand
      brand = Brand.find_or_create_by!(name: brand_name)
      
      # Create the models for this brand
      models.each do |model_data|
        next if model_data['average_price'] < 100_000 && !model_data['average_price'].zero?
        
        # Use create_or_find_by to avoid duplicates, and update the price if needed
        model = brand.models.create_or_find_by(name: model_data['name']) do |m|
          m.average_price = model_data['average_price'] > 0 ? model_data['average_price'] : 100_001
        end
        
        # Update the price if it's changed and not zero
        if model_data['average_price'] > 0 && model.average_price != model_data['average_price']
          model.update(average_price: model_data['average_price'])
        end
      end
    end
  end
end

puts "Database seeded successfully with #{Brand.count} brands and #{Model.count} models!"