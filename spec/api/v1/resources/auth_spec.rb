# frozen_string_literal: true

require "rails_helper"

RSpec.describe V1::Resources::Auth, type: :request do
  describe "POST /api/v1/auth/signup" do
    let(:valid_params) do
      {
        email: "user@example.com",
        password: "Passw@rd1",
        password_confirmation: "Passw@rd1"
      }
    end

    let(:invalid_params) do
      {
        email: "user@example.com",
        password: "Passw@rd1",
        password_confirmation: "WrongPass"
      }
    end

    context "when the request is valid" do
      it "creates a new user and returns the user data" do
        post "/api/v1/auth/signup", params: valid_params
        expect(response).to have_http_status(:created)
        expect(response_body[:user][:email]).to eq(valid_params[:email])
      end
    end

    context "when the request is invalid" do
      it "returns a validation error" do
        post "/api/v1/auth/signup", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:error]).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "user@example.com", password: "Passw@rd1", password_confirmation: "Passw@rd1") }

    let(:valid_login_params) do
      {
        email: "user@example.com",
        password: "Passw@rd1"
      }
    end

    let(:invalid_login_params) do
      {
        email: "user@example.com",
        password: "WrongPass"
      }
    end

    context "when the login credentials are valid" do
      it "returns a JWT token" do
        post "/api/v1/auth/login", params: valid_login_params
        expect(response).to have_http_status(:ok) # Ensure this returns 200 OK
        expect(response_body[:token]).not_to be_nil
      end
    end

    context "when the login credentials are invalid" do
      it "returns an unauthorized error" do
        post "/api/v1/auth/login", params: invalid_login_params
        expect(response).to have_http_status(:unauthorized)
        expect(response_body[:error]).to eq("Invalid email or password")
      end
    end
  end
end
