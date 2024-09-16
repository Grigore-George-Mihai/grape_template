# frozen_string_literal: true

module HelpersConfig
  def sign_in(user)
    post "/api/v1/auth/login", params: { email: user.email, password: "password123!" }
    response_body["token"]
  end

  def authenticate_request(user)
    token = sign_in(user)
    { "Authorization" => "Bearer #{token}" }
  end

  def response_body
    JSON.parse(response.body).with_indifferent_access
  end
end
