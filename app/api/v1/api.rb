# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      include Pagy::Backend

      def authenticate_request!
        @authenticate_request ||= JwtService.authenticate(request.headers)
      end

      def current_user
        authenticate_request!
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
