# frozen_string_literal: true

# Keyword utils mixin
module Keywords
  # Transform a keyword in a secure way removing all non alphanumeric characters
  def escape_keyword(keyword)
    keyword.gsub(/[^0-9A-Za-z]/, '')
  end
end
