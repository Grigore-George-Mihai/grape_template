# frozen_string_literal: true

class ApiRoot < Grape::API
  # Mount the different versions
  mount V1::Api
  mount V2::Api

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    error!({ errors: { status: I18n.t("errors.not_found") } }, 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |_exception|
    error!({ errors: { status: I18n.t("errors.unprocessable_entity"), code: 422 } }, 422)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |exception|
    error!({ errors: { status: I18n.t("errors.bad_request"), code: 400, message: exception.message } }, 400)
  end

  add_swagger_documentation(
    api_version: "v1",
    base_path: "/",
    hide_documentation_path: true,
    mount_path: "/swagger_doc",
    hide_format: true,
    models: []
  )
end
