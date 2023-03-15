# frozen_string_literal: true

require 'mechanize'

# Will create a Keyword model
class CreateKeywordSearch < ActiveInteraction::Base
  string :keyword
  string :path

  def execute
    KeywordSearch.create(keyword_search_params)
  end

  private

  def agent
    @agent ||= Mechanize.new
  end

  def page
    @page ||= agent.get(path)
  end

  # The source page fetched
  def source_code
    page.body
  end

  # The total results presented in the page
  def total_results
    page.search('div#result-stats').text
  end

  # The total number of links presented in the page
  def total_links
    page.links.size
  end

  # Total adwords showed in the page
  def total_adwords
    page.search('div[data-text-ad=1]').size
  end

  def keyword_search_params
    {
      keyword:,
      total_results:,
      total_links:,
      total_adwords:,
      source_code:
    }
  end
end
