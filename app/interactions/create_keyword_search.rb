# frozen_string_literal: true

require 'mechanize'

# Will create a Keyword model
class CreateKeywordSearch < ActiveInteraction::Base
  string :path

  def execute
    keyword_search_params
  end

  private

  def keyword_search_params
    {
      total_results:,
      total_links:,
      total_adwords:
    }
  end

  def agent
    @agent ||= Mechanize.new
  end

  def page
    @page ||= agent.get(path)
  end

  def source_code
    page.body
  end

  def total_results
    page.search('div#result-stats').text
  end

  def total_links
    page.links.size
  end

  def total_adwords
    page.search('div[data-text-ad=1]').size
  end
end
