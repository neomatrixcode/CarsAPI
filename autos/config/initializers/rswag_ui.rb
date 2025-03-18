Rswag::Ui.configure do |c|

  # List the Swagger endpoints that you want to be documented through the
  # swagger-ui. The first parameter is the path (absolute or relative to the UI
  # host) to the corresponding endpoint and the second is a title that will be
  # displayed in the document selector.
  # NOTE: If you're using rspec-api to expose Swagger files
  # (under openapi_root) as JSON or YAML endpoints, then the list below should
  # correspond to the relative paths for those endpoints.

  c.swagger_endpoint '/swagger/v1/swagger.yaml', 'Nexu Backend API'
  
  # Configurar opciones adicionales de SwaggerUI para resolver problemas de CORS
  c.config_object = {
    url: '/swagger/v1/swagger.yaml',
    displayRequestDuration: true,
    defaultModelsExpandDepth: -1,
    docExpansion: 'list',
    requestSnippetsEnabled: true,
    tryItOutEnabled: true
  }

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'
end
