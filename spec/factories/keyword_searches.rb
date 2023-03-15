FactoryBot.define do
  factory :keyword_search do
    keyword { "MyString" }
    total_results { "MyString" }
    total_links { 1 }
    total_adwords { 1 }
    source_code { "MyText" }
  end
end
