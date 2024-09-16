# frozen_string_literal: true

module V1
  module Entities
    class AuthEntity < BaseEntity
      root "users", "user"

      expose :id, documentation: { type: "Integer", desc: "User ID" }
      expose :email, documentation: { type: "String", desc: "User Email" }

      # Timestamps
      expose :created_at, documentation: { type: "String", desc: "Creation timestamp" }, format_with: :iso_timestamp
      expose :updated_at, documentation: { type: "String", desc: "Last update timestamp" }, format_with: :iso_timestamp
    end
  end
end
