# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    # Validate presence and format of email
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value("user@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalid_email").for(:email).with_message(I18n.t("errors.messages.invalid_email")) }

    # Validate case-insensitive uniqueness of email
    context "when validating uniqueness of email" do
      subject { create(:user, email: "test@example.com", password: "Passw@rd1", password_confirmation: "Passw@rd1") }

      it "validates uniqueness of email case-insensitively" do
        expect(subject).to validate_uniqueness_of(:email).case_insensitive
      end
    end

    # Validate presence and complexity of password
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    context "when the password lacks a special character" do
      it "is invalid" do
        user = build(:user, password: "Password1", password_confirmation: "Password1")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include(I18n.t("errors.messages.password_complexity"))
      end
    end

    context "when the password meets all requirements" do
      it "is valid" do
        user = build(:user, password: "Passw@rd1", password_confirmation: "Passw@rd1")
        expect(user).to be_valid
      end
    end
  end
end
