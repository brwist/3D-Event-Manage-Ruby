# frozen_string_literal: true

json.array! @contents, partial: 'contents/content', as: :content
