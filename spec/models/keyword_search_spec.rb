# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordSearch, type: :model do
  subject { build(:keyword_search) }
  context 'successfully' do
    it 'create a keyword search' do
      keyword_search = create(:keyword_search)
      expect(keyword_search).to be_persisted
    end

    it 'validates keyword presence' do
      keyword_search = build(:keyword_search, keyword: nil)
      expect(keyword_search).to_not be_valid
      expect(keyword_search.errors.messages[:keyword]).to eq(['can\'t be blank'])
    end
  end
end
