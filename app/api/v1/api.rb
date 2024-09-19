# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      def authenticate_request!
        token = extract_bearer_token
        decoded_token = JwtService.decode(token)
        error!("Unauthorized", 401) unless decoded_token
      end

      def current_user
        token = extract_bearer_token
        decoded_token = JwtService.decode(token)
        @current_user ||= User.find(decoded_token[:user_id]) if decoded_token
      rescue ActiveRecord::RecordNotFound
        error!("Unauthorized", 401)
      end

      def extract_bearer_token
        auth_header = request.headers["Authorization"]
        error!("Invalid token format", 401) unless auth_header&.start_with?("Bearer ")
        auth_header.split.last
      end
    end

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
