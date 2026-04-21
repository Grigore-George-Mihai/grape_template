# frozen_string_literal: true

module V1
  module Resources
    class Users < Grape::API
      resource :users do
        desc "Update the current user's profile"
        params do
          optional :first_name, type: String, desc: "User first name"
          optional :last_name, type: String, desc: "User last name"
          optional :email, type: String, desc: "User email"
          optional :password, type: String, desc: "User password"
          optional :password_confirmation, type: String, desc: "User password confirmation"
          at_least_one_of :first_name, :last_name, :email, :password
        end
        patch "/me" do
          authenticate_request!
          attrs = declared(params, include_missing: false)

          if current_user.update(attrs)
            present current_user, with: V1::Entities::UserEntity
          else
            error!(current_user.errors.full_messages, 422)
          end
        end
      end
    end
  end
end
