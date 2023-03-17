# frozen_string_literal: true

Doorkeeper::Application.find_or_create_by(
  name: 'Web client',
  uid: Rails.application.credentials.doorkeeper[:client_id],
  redirect_uri: nil,
  scopes: '',
  confidential: false
)
