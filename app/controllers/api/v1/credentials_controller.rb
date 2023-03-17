# frozen_string_literal: true

module Api
  module V1
    # Current user endpoint
    class CredentialsController < BaseController
      before_action :doorkeeper_authorize!
      respond_to :json

      # GET /api/v1/credentials/me
      def me
        respond_with current_user
      end
    end
  end
end
