# frozen_string_literal: true

module V1
  module Resources
    class Auth < Grape::API
      resource :auth do
        desc "User login and returns JWT token along with user information"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post "/login" do
          user = User.find_by(email: params[:email])
          if user&.authenticate(params[:password])
            token = JwtService.encode(user_id: user.id, jti: user.jti)
            status 200
            present({ token:, user: }, with: V1::Entities::AuthEntity)
          else
            error!("Invalid email or password", 401)
          end
        end

        desc "User signup"
        params do
          requires :first_name, type: String, desc: "User first name"
          requires :last_name, type: String, desc: "User last name"
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
          requires :password_confirmation, type: String, desc: "User password confirmation"
        end
        post "/signup" do
          user = User.new(
            first_name: params[:first_name],
            last_name: params[:last_name],
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
          )

          if user.save
            present user, with: V1::Entities::UserEntity
          else
            error!(user.errors.full_messages, 422)
          end
        end

        desc "User logout and invalidates the current JWT token"
        delete "/logout" do
          authenticate_request!
          current_user.regenerate_jti!
          status 200
          { message: "Logged out successfully" }
        end
      end
    end
  end
end
