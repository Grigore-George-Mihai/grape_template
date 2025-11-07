# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      include Pagy::Method

      def authenticate_request!
        @authenticate_request ||= JwtService.authenticate(request.headers)
      end

      def current_user
        authenticate_request!
      end

      def paginated_response(collection, entity)
        pagy_opts = { page: params[:page], limit: params[:per_page] }.compact
        pagy, records = pagy(collection, **pagy_opts)

        {
          collection.model_name.plural => entity.represent(records, root: false),
          pagy: {
            count: pagy.count,
            page: pagy.page,
            limit: pagy.limit,
            pages: pagy.pages,
            prev_url: pagy.page_url(:previous),
            next_url: pagy.page_url(:next)
          }
        }
      end
    end

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
