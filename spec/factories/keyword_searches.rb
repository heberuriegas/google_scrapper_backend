FactoryBot.define do
  factory :keyword_search do
    keyword { generate(:random_word) }
    total_results { generate(:random_words) }
    total_links { generate(:random_number) }
    total_adwords { generate(:random_number) }
    source_code { generate(:random_paragraphs) }
  end
end
