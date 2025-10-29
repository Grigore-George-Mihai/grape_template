# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.email }
    password   { "Password123!" }
    password_confirmation { "Password123!" }
    role { :user }

    trait :admin do
      role { :admin }
    end

    trait :with_custom_jti do
      jti { SecureRandom.uuid }
    end
  end
end
