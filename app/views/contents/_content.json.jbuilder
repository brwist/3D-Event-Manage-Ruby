# frozen_string_literal: true

json.extract! content, :id, :created_at, :updated_at
json.url content_url(content, format: :json)
