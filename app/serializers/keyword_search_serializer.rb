# frozen_string_literal: true

# Serialize a keyword search
class KeywordSearchSerializer < ActiveModel::Serializer
  attributes :id, :keyword, :total_results, :total_adwords, :total_links, :created_at
end
