# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CreateKeywordSearch, type: :service do
  subject { CreateKeywordSearch }

  let(:keyword) { 'hola' }
  let(:path) { "file://#{Rails.root.join('spec', 'helpers', 'hola.html')}" }

  context 'successfully' do
    before(:each) do
      @keyword_search = subject.run(keyword:, path:).result
    end

    it 'create a keyword search' do
      expect(@keyword_search).to be_persisted
    end

    it 'fetch the total results' do
      expect(@keyword_search.total_results).to eq('Cerca de 1,420,000,000 resultados (0.52 segundos) ')
    end

    it 'fetch the total links' do
      expect(@keyword_search.total_links).to eq(103)
    end

    it 'fetch the total adwords' do
      expect(@keyword_search.total_adwords).to eq(0)
    end

    it 'fetch source code' do
      expect(@keyword_search.source_code.size).to eq(757_361)
    end

    context 'validate inputs' do
      it 'without keyword' do
        interaction = subject.run(keyword: nil, path: '')
        expect(interaction.errors.messages[:keyword]).to eq(['is required'])
      end

      it 'without path' do
        interaction = subject.run(keyword: '', path: nil)
        expect(interaction.errors.messages[:path]).to eq(['is required'])
      end
    end
  end

  context 'unsuccessfully' do
    describe 'raise an error' do
      it 'with wrong path' do
        expect { subject.run(keyword:, path: '/tmp') }.to raise_error(ArgumentError)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
