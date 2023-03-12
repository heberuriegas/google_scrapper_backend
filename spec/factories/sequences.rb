# frozen_string_literal: true

FactoryBot.define do
  sequence :random_email do
    FFaker::Internet.email
  end

  sequence :random_password do
    FFaker::Internet.password
  end

  sequence :random_word do
    FFaker::Lorem.word
  end

  sequence :random_url do
    FFaker::Internet.http_url.gsub('http', 'https')
  end

  sequence :random_uid do
    FFaker::Guid.guid
  end
end
