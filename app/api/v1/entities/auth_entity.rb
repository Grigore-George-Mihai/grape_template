# frozen_string_literal: true

module V1
  module Entities
    class AuthEntity < BaseEntity
      expose :token, documentation: { type: "String", desc: "JWT Token" }
      expose :user, using: V1::Entities::UserEntity, documentation: { type: "UserEntity", desc: "User details" }
    end
  end
end
