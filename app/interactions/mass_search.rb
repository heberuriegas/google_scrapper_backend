# frozen_string_literal: true

require 'fileutils'

# Will extract info from the first page
class MassSearch < ActiveInteraction::Base
  attr_reader :temp_dir

  array :keywords

  def execute
    @temp_dir = mass_search

    return unless temp_dir.present?

    create_keyword_searches
    clear_temp_dir
  end

  private

  def create_keyword_searches
    keywords.each do |keyword|
      # TODO: Improve this
      keyword = keyword.gsub(/[^0-9A-Za-z]/, '')
      CreateKeywordSearch.run(path: "file://#{temp_dir}/#{keyword}.html")
    end
  end

  def escaped_words
    keywords.map { |keyword| keyword.gsub(/[^0-9A-Za-z]/, '') }
  end

  def mass_search_input
    escaped_words.join("\n")
  end

  # :reek:UtilityFunction
  def mass_search_path
    Rails.root.join('scripts', 'mass_search')
  end

  # Will search keywords in google
  # @return [String] A temp dir with google search html files downloaded
  def mass_search
    `echo "#{mass_search_input}" | xargs #{mass_search_path}`.gsub("\n", '')
  end

  def clear_temp_dir
    FileUtils.rm_rf(temp_dir)
  end
end
