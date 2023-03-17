# frozen_string_literal: true

# Manage the api versioning according to accept header
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.v#{@version}")
  end
end
