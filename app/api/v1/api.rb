# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      include Pagy::Backend

      def authenticate_request!
        return @current_user if @current_user

        token = extract_bearer_token
        decoded_token = JwtService.decode(token)
        @current_user = User.find(decoded_token[:user_id])
      rescue ActiveRecord::RecordNotFound
        error!("Unauthorized", 401)
      end

      def current_user
        authenticate_request!
      end

      def extract_bearer_token
        auth_header = request.headers["Authorization"]
        error!("Invalid token format", 401) unless auth_header&.start_with?("Bearer ")
        auth_header.split.last
      end

      def paginated_response(collection, entity)
        pagy, records = pagy(collection, page: params[:page], limit: params[:per_page])

        {
          collection.model_name.plural => entity.represent(records, root: false),
          pagy: pagy_metadata(pagy).slice(:count, :page, :limit, :pages, :prev_url, :next_url)
        }
      end
    end

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
