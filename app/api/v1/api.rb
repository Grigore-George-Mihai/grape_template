# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    # Mount other endpoints - Used by generator do not delete
  end
end
