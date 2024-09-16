# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      def authenticate_request!
        token = request.headers["Authorization"]&.split&.last
        decoded_token = JwtService.decode(token)
        error!("Unauthorized", 401) unless decoded_token
      end

      def current_user
        token = request.headers["Authorization"]&.split&.last
        decoded_token = JwtService.decode(token)
        @current_user ||= User.find(decoded_token[:user_id]) if decoded_token
      rescue ActiveRecord::RecordNotFound
        error!("Unauthorized", 401)
      end
    end

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
