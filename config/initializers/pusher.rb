require 'pusher'

PUSHER_CLIENT = Pusher::Client.new(
  app_id: Rails.application.credentials.pusher[:app_id],
  key: Rails.application.credentials.pusher[:key],
  secret: Rails.application.credentials.pusher[:secret],
  cluster: Rails.application.credentials.pusher[:cluster],
  encrypted: true
)