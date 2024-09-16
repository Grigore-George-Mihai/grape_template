# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t("errors.messages.invalid_email") }
  validates :password, presence: true, length: { minimum: 6 },
                       format: { with: /\A(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+\z/, message: I18n.t("errors.messages.password_complexity") }

  private

  def downcase_email
    self.email = email.downcase
  end
end
