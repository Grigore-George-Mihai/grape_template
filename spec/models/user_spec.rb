# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    %i[first_name last_name email password].each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end

    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    it "validates email format" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    describe "email uniqueness" do
      subject { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    it "requires password to contain a special character" do
      user = build(:user, password: "Password123", password_confirmation: "Password123")
      expect(user).not_to be_valid

      user.password = "Pass123!"
      user.password_confirmation = "Pass123!"
      expect(user).to be_valid
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(user: 0, admin: 1) }
  end

  describe "email normalization" do
    it "downcases and strips email before saving" do
      unique_email = "  #{Faker::Internet.username.upcase}@EXAMPLE.COM  "
      user = build(:user, email: unique_email)
      user.save!
      expect(user.email).to eq(unique_email.strip.downcase)
    end
  end

  describe "jti generation" do
    it "generates jti on create when not set" do
      user = build(:user, jti: nil)
      user.save!
      expect(user.jti).to be_present
    end

    it "preserves existing jti if already set" do
      existing_jti = SecureRandom.uuid
      user = build(:user, jti: existing_jti)
      user.save!
      expect(user.jti).to eq(existing_jti)
    end
  end

  describe "#regenerate_jti!" do
    it "updates jti to a new UUID" do
      user = build(:user)
      user.save!
      original_jti = user.jti

      user.regenerate_jti!
      expect(user.reload.jti).not_to eq(original_jti)
    end
  end
end
