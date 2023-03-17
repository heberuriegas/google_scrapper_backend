# frozen_string_literal: true

# Serialize a user
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
end
