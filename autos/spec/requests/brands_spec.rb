require 'swagger_helper'

RSpec.describe 'Brands API', type: :request do
  path '/brands' do
    get 'Lists all brands with pagination' do
      tags 'Brands'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number (default: 1)'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page (default: 10)'
      
      response '200', 'brands found' do
        schema type: :object,
          properties: {
            brands: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  nombre: { type: :string },
                  average_price: { type: :integer }
                },
                required: ['id', 'nombre', 'average_price']
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
          required: ['brands', 'meta']
        
        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test!
      end
    end
    
    post 'Creates a brand' do
      tags 'Brands'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :brand, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }
      
      response '201', 'brand created' do
        let(:brand) { { name: "Test Brand #{Time.now.to_i}" } }
        run_test!
      end
      
      response '422', 'invalid request' do
        let(:brand) { { name: '' } }
        run_test!
      end
    end
  end
  
  path '/brands/{id}/models' do
    parameter name: :id, in: :path, type: :integer
    
    get 'Lists all models for a brand with pagination' do
      tags 'Brands', 'Models'
      produces 'application/json'
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
        
        let(:id) { Brand.create(name: 'Test Brand').id }
        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test!
      end
      
      response '404', 'brand not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
    
    post 'Creates a model for a brand' do
      tags 'Brands', 'Models'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :model, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          average_price: { type: :integer }
        },
        required: ['name']
      }
      
      response '201', 'model created' do
        let(:id) { Brand.create(name: 'Test Brand').id }
        let(:model) { { name: 'Model X', average_price: 150000 } }
        run_test!
      end
      
      response '422', 'invalid request' do
        let(:id) { Brand.create(name: 'Test Brand').id }
        let(:model) { { name: '', average_price: 50000 } }
        run_test!
      end
      
      response '404', 'brand not found' do
        let(:id) { 'invalid' }
        let(:model) { { name: 'Model X', average_price: 150000 } }
        run_test!
      end
    end
  end
end