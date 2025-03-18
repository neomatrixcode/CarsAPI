require 'swagger_helper'

RSpec.describe 'Models API', type: :request do
  path '/models' do
    get 'Lista modelos con paginación' do
      tags 'Modelos'
      parameter name: :greater, in: :query, type: :integer, required: false
      parameter name: :lower, in: :query, type: :integer, required: false
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response '200', 'modelos encontrados' do
        let(:greater) { nil }
        let(:lower) { nil }
        let(:page) { 1 }
        let(:per_page) { 10 }
        
        run_test! do |response|
          expect(JSON.parse(response.body)).to have_key('models')
          expect(JSON.parse(response.body)).to have_key('meta')
        end
      end
    end
  end
end