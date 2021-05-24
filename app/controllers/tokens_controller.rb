# frozen_string_literal: true

class TokensController < ApplicationController
  # POST /tokens/attach_content
  def attach_content
    text    = content_hotspot_params[:text]
    token   = Token.find(content_hotspot_params[:token_id])
    event   = Event.find(content_hotspot_params[:event_id])
    content = Content.find(content_hotspot_params[:content_id])

    token.create_content_hotspot(event: event, content: content, text: text)

    redirect_to edit_event_url(event)
  end

  private

  def content_hotspot_params
    params.require(:content_hotspot)
  end
end
