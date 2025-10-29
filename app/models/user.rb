# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :role, %i[user admin], validate: true

  before_create -> { self.jti ||= SecureRandom.uuid }

  normalizes :email, with: ->(email) { email.downcase.strip }

  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, format: { with: /\A(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+\z/, message: I18n.t("errors.messages.password_complexity") }

  def regenerate_jti!
    update_column(:jti, SecureRandom.uuid)
  end
end
