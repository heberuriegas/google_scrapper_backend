# frozen_string_literal: true

module Api
  # Api parent controller
  class BaseController < ActionController::Base
    def current_user
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token && valid_doorkeeper_token?
    end

    rescue_from StandardError do |e|
      Rails.log.error e.message
      Rails.log.error e.backtrace.join("\n")
      render json: { error: e }, status: 500
    end
  end
end
