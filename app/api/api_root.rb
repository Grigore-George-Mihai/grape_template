# frozen_string_literal: true

class ApiRoot < Grape::API
  include ErrorHandler

  mount V1::Api

  add_swagger_documentation(
    api_version: "v1",
    base_path: "/",
    hide_documentation_path: true,
    mount_path: "/swagger_doc",
    hide_format: true,
    security_definitions: {
      bearerAuth: {
        type: "apiKey",
        name: "Authorization",
        in: "header",
        description: "Enter JWT with Bearer prefix"
      }
    },
    security: [
      { bearerAuth: [] }
    ],
    models: [
      V1::Entities::AuthEntity
    ]
  )
end
