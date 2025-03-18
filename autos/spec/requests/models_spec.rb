require 'swagger_helper'

RSpec.describe 'Models API', type: :request do
  path '/models' do
    get 'Lists all models with optional filtering and pagination' do
      tags 'Models'
      produces 'application/json'
      parameter name: :greater, in: :query, type: :integer, required: false, description: 'Filter models with average_price greater than this value'
      parameter name: :lower, in: :query, type: :integer, required: false, description: 'Filter models with average_price lower than this value'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number (default: 1)'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page (default: 10)'
      
      response '200', 'models found' do
        schema type: :object,
          properties: {
            models: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  average_price: { type: :integer }
                },
                required: ['id', 'name', 'average_price']
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                per_page: { type: :integer },
                total_count: { type: :integer },
                total_pages: { type: :integer }
              },
              required: ['current_page', 'per_page', 'total_count', 'total_pages']
            }
          },
          required: ['models', 'meta']
        
        let(:greater) { nil }
        let(:lower) { nil }
        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test! do |response|
          # Adicional: podríamos verificar la estructura de la respuesta aquí si fuera necesario
          expect(JSON.parse(response.body)).to have_key('models')
          expect(JSON.parse(response.body)).to have_key('meta')
        end
      end
    end
  end
  
  path '/models/{id}' do
    parameter name: :id, in: :path, type: :integer
    
    put 'Updates a model' do
      tags 'Models'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :model, in: :body, schema: {
        type: :object,
        properties: {
          average_price: { type: :integer }
        },
        required: ['average_price']
      }
      
      response '200', 'model updated' do
        let(:brand) { Brand.create(name: 'Test Brand') }
        let(:id) { brand.models.create(name: 'Test Model', average_price: 150000).id }
        let(:model) { { average_price: 200000 } }
        run_test!
      end
      
      response '422', 'invalid request' do
        let(:brand) { Brand.create(name: 'Test Brand') }
        let(:id) { brand.models.create(name: 'Test Model', average_price: 150000).id }
        let(:model) { { average_price: 50000 } }
        run_test!
      end
      
      response '404', 'model not found' do
        let(:id) { 'invalid' }
        let(:model) { { average_price: 200000 } }
        run_test!
      end
    end
  end
end