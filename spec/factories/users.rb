# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:random_email) }
    password { generate(:random_password) }
  end
end
