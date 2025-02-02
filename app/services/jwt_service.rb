# frozen_string_literal: true

class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV.fetch("SECRET_KEY_BASE") do
    raise "Secret key base not configured"
  end

  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY, "HS256")
    end

    def authenticate(headers)
      token = extract_bearer_token(headers)
      payload = decode(token)

      # Retrieve user and validate JTI
      user = User.find_by(id: payload[:user_id])
      raise ErrorHandler::JwtVerificationError unless user&.jti == payload[:jti]

      user
    end

    private

    def extract_bearer_token(headers)
      auth_header = headers["Authorization"]
      raise ErrorHandler::JwtDecodeError unless auth_header&.start_with?("Bearer ")

      auth_header.split.last
    end

    def decode(token)
      body = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
      raise ErrorHandler::JwtExpiredError
    rescue JWT::DecodeError
      raise ErrorHandler::JwtDecodeError
    end
  end
end
