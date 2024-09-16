# frozen_string_literal: true

class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV.fetch("SECRET_KEY_BASE", nil)

  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key, "HS256")
    end

    def decode(token)
      body = JWT.decode(token, secret_key, true, algorithm: "HS256")[0]
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
      Rails.logger.warn("JWT token has expired")
      nil
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")
      nil
    end

    private

    def secret_key
      SECRET_KEY || raise("Secret key base not configured")
    end
  end
end
