# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_application, class: Doorkeeper::Application do
    name { generate(:random_word) }
    redirect_uri { generate(:random_url) }
    uid { generate(:random_uid) }
    confidential { false }
    scopes { '' }
  end
end
