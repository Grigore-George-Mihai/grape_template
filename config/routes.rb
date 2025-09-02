require "sidekiq/web"
require "sidekiq-scheduler/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
end

Rails.application.routes.draw do
  mount ApiRoot => "/"
  mount GrapeSwaggerRails::Engine => "/swagger" if Rails.env.development?

  if Rails.env.development? || Rails.env.production?
    Sidekiq::Web.use ActionDispatch::Cookies
    Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: ENV.fetch("SIDEKIQ_SESSION_KEY", nil)

    mount Sidekiq::Web => "/sidekiq"
  end
end
