# frozen_string_literal: true

# Users devise module
module Users
  # Allow users to sign up and update
  class RegistrationsController < Devise::RegistrationsController
    include Tokenable

    respond_to :json

    # POST /users
    def create
      create_resource_with_email(sign_up_params)

      yield resource if block_given?
      if resource.persisted? && resource.active_for_authentication?
        respond_with_created_resource
      else
        respond_with_error
      end
    end

    protected

    def create_resource_with_email(sign_up_params)
      build_resource(sign_up_params)
      resource.save
    end

    def respond_with_created_resource
      sign_up(resource_name, resource)
      # Generate access token for json request
      add_credentials_headers if credentials.present?
      respond_with(resource, location: after_sign_up_path_for(resource))
    end

    def respond_with_error
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end

    # Will add credentials (token type, access control, etc) to headers. It also includes Access-Control-Expose-Headers to
    # allow automatic sign in after sign up
    def add_credentials_headers
      access_control_headers = []
      credentials.each do |header, value|
        key = header.to_s.titleize.gsub(' ', '-')
        response.set_header(key, value)
        access_control_headers << key
      end
      response.set_header('Access-Control-Expose-Headers', access_control_headers.join(', '))
    end

    # Authenticates the current scope and gets the current resource from the session or token.
    def authenticate_scope!
      self.resource = if doorkeeper_token && valid_doorkeeper_token?
                        User.find(doorkeeper_token.resource_owner_id)
                      else
                        send(:"authenticate_#{resource_name}!", force: true)
                        send(:"current_#{resource_name}")
                      end
    end
  end
end
