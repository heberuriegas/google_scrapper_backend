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

  sequence :random_words do
    FFaker::Lorem.words.join(' ')
  end

  sequence :random_paragraphs do
    FFaker::Lorem.paragraphs.join(' ')
  end

  sequence :random_url do
    FFaker::Internet.http_url.gsub('http', 'https')
  end

  sequence :random_uid do
    FFaker::Guid.guid
  end

  sequence :random_number do
    (rand * 100).to_i
  end
end
