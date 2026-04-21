# frozen_string_literal: true

require "rails_helper"

RSpec.describe V1::Resources::Users, type: :request do
  describe "PATCH /api/v1/users/me" do
    let!(:user) { create(:user, password: "Passw@rd1", password_confirmation: "Passw@rd1") }
    let(:headers) { authenticate_request(user) }

    context "when unauthenticated" do
      it "rejects the request" do
        patch "/api/v1/users/me", params: { first_name: "Nope" }
        expect(response).to have_http_status :unprocessable_content
      end
    end

    context "when no updatable attribute is provided" do
      it "returns 400" do
        patch "/api/v1/users/me", params: {}, headers: headers
        expect(response).to have_http_status :bad_request
      end
    end

    context "with valid profile attributes" do
      it "updates the user and returns the new representation" do
        patch "/api/v1/users/me",
              params: { first_name: "Updated", last_name: "Name" },
              headers: headers

        expect(response).to have_http_status :ok
        expect(response_body[:user][:first_name]).to eq("Updated")
        expect(response_body[:user][:last_name]).to eq("Name")
        expect(user.reload.first_name).to eq("Updated")
      end

      it "normalizes the email" do
        patch "/api/v1/users/me",
              params: { email: "  NEW@Example.COM  " },
              headers: headers

        expect(response).to have_http_status :ok
        expect(user.reload.email).to eq("new@example.com")
      end
    end

    context "when changing the password" do
      it "lets the user log in with the new password" do
        patch "/api/v1/users/me",
              params: { password: "NewPass1!", password_confirmation: "NewPass1!" },
              headers: headers
        expect(response).to have_http_status :ok

        post "/api/v1/auth/login", params: { email: user.email, password: "NewPass1!" }
        expect(response).to have_http_status :ok
        expect(response_body[:token]).to be_present
      end

      it "rejects a mismatched confirmation" do
        patch "/api/v1/users/me",
              params: { password: "NewPass1!", password_confirmation: "Different1!" },
              headers: headers

        expect(response).to have_http_status :unprocessable_content
        expect(response_body[:error]).to include(
          a_string_matching(/password confirmation/i)
        )
      end
    end

    context "with an invalid email" do
      it "returns a validation error" do
        patch "/api/v1/users/me",
              params: { email: "not-an-email" },
              headers: headers

        expect(response).to have_http_status :unprocessable_content
      end
    end

    context "with a duplicate email" do
      it "returns a validation error" do
        create(:user, email: "taken@example.com")

        patch "/api/v1/users/me",
              params: { email: "taken@example.com" },
              headers: headers

        expect(response).to have_http_status :unprocessable_content
      end
    end
  end
end
