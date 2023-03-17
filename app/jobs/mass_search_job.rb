# frozen_string_literal: true

# Perform an async mass search
class MassSearchJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default'

  def perform(keywords)
    PUSHER_CLIENT.trigger('google-scrapper', 'start-keyword-search', {})
    mass_search = MassSearch.run(keywords:)

    message = if mass_search.valid?
                {}
              else
                mass_search.errors.messages
              end

    PUSHER_CLIENT.trigger('google-scrapper', 'reload-keyword-table', message)
  ensure
    PUSHER_CLIENT.trigger('google-scrapper', 'stop-keyword-search', {})
  end
end
