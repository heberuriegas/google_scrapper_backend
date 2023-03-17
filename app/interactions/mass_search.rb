# frozen_string_literal: true

require 'fileutils'

# Extract info from the first page
class MassSearch < ActiveInteraction::Base
  include Keywords

  attr_reader :temp_dir

  array :keywords

  # Create a temp
  def execute
    @temp_dir = mass_search

    return unless temp_dir.present?

    create_keyword_searches
    clear_temp_dir
  rescue StandardError => e
    errors.add(:keywords, e.message)
  end

  private

  # Create a keyword search database record for each keyword
  def create_keyword_searches
    keywords.each do |keyword|
      keyword = escape_keyword(keyword)
      CreateKeywordSearch.run(keyword:, path: "file://#{temp_dir}/#{keyword}.html")
    end
  end

  # Avoid unintentional bash argument
  def escaped_words
    keywords.map { |keyword| escape_keyword(keyword) }
  end

  # Create a string with a breakline for each keyword
  def mass_search_input
    escaped_words.join("\n")
  end

  # :reek:UtilityFunction
  def mass_search_path
    # Rails.root.join('scripts', 'random_mass_search')
    Rails.root.join('scripts', 'concurrent_mass_search')
  end

  # Search keywords in the first page of google
  # and create a tempdir with the html results in it
  def mass_search
    `echo "#{mass_search_input}" | xargs #{mass_search_path}`.gsub("\n", '')
  end

  # Clear the tempdir created with the mass_search binary
  def clear_temp_dir
    FileUtils.rm_rf(temp_dir)
  end
end
