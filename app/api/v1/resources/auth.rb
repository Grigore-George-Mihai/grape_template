# frozen_string_literal: true

module V1
  module Resources
    class Auth < Grape::API
      resource :auth do
        desc "User login and returns JWT token"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post "/login" do
          user = User.find_by(email: params[:email])
          if user&.authenticate(params[:password])
            token = JwtService.encode(user_id: user.id)
            status 200
            { token: }
          else
            error!("Invalid email or password", 401)
          end
        end

        desc "User signup"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
          requires :password_confirmation, type: String, desc: "User password confirmation"
        end
        post "/signup" do
          user = User.new(
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
          )

          if user.save
            present user, with: V1::Entities::AuthEntity
          else
            error!(user.errors.full_messages, 422)
          end
        end
      end
    end
  end
end
