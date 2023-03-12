# frozen_string_literal: true

# Enable a resource to generate access token
module Tokenable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    attr_reader :application, :access_token

    private

    # Build a response headers with access token details
    def credentials
      create_application_access_token
      if access_token.present?
        credential_headers
      else
        {}
      end
    end

    def create_application_access_token
      @application = Doorkeeper::Application.find_by(uid: request.headers[:'Client-Id'] || params[:client_id])
      return unless application.present?

      @access_token = create_doorkeeper_token
    end

    def create_doorkeeper_token
      Doorkeeper::AccessToken.create(
        application_id: application.id,
        resource_owner_id: resource.id,
        refresh_token: Doorkeeper::AccessToken.generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: 'read'
      )
    end

    def credential_headers
      {
        token_type: 'Bearer',
        access_token: access_token.token,
        expires_in: access_token.expires_in,
        refresh_token: access_token.refresh_token,
        created_at: access_token.created_at.to_time.to_i
      }
    end
  end
  # rubocop:enable Metrics/BlockLength
end
