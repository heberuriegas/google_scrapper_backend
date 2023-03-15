# frozen_string_literal: true

# Represent a keyword search in google
class KeywordSearch < ApplicationRecord
  validates :keyword, presence: true
end
