# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe MassSearch, type: :service do
  include Keywords

  subject { MassSearch }

  let(:keywords) do
    50.times.map { FFaker::Lorem.words.join(' ') }
  end

  context 'successfully' do
    context 'mass search' do
      let(:temp_dir) { '/tmp/abc' }

      before(:each) do
        allow_any_instance_of(MassSearch).to receive(:mass_search).and_return(temp_dir)
        allow(CreateKeywordSearch).to receive(:run)
        allow(FileUtils).to receive(:rm_rf).with(temp_dir)
        subject.run(keywords:)
      end

      it 'create a temp dir with keywords web source codes' do
        expect(CreateKeywordSearch).to have_received(:run).at_least(1)
      end

      it 'create a keyword search for each keyword' do
        keywords.each do |keyword|
          keyword = escape_keyword(keyword)
          expect(CreateKeywordSearch).to have_received(:run).with(path: "file://#{temp_dir}/#{keyword}.html")
        end
      end

      it 'clear temp directory' do
        expect(FileUtils).to have_received(:rm_rf).with(temp_dir).exactly(1)
      end
    end

    context 'unsuccessfully' do
      before(:each) do
        allow_any_instance_of(MassSearch).to receive(:mass_search).and_return(nil)
        allow(CreateKeywordSearch).to receive(:run)
        subject.run(keywords:)
      end

      it 'don\'t create a temp dir with keywords web source codes' do
        expect(CreateKeywordSearch).to have_received(:run).exactly(0)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
