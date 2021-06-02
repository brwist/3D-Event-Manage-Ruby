# frozen_string_literal: true

class TokensController < ApplicationController
  # POST /tokens/attach_content
  def attach_content_hotspot
    text    = content_hotspot_params[:text]
    token   = Token.find(content_hotspot_params[:token_id])
    event   = Event.find(content_hotspot_params[:event_id])
    content = Content.find(content_hotspot_params[:content_id])

    authorize event, :update?

    token.create_content_hotspot(event: event, content: content, text: text)
    redirect_to edit_event_url(event)
  end

  # rubocop:disable Metrics/AbcSize
  def attach_url_hotspot
    label = url_hotspot_params[:label]
    url   = url_hotspot_params[:url]
    type  = url_hotspot_params[:type].to_sym
    token = Token.find(url_hotspot_params[:token_id])
    event = Event.find(url_hotspot_params[:event_id])

    authorize event, :update?

    token.create_url_hotspot(event: event, url: url, text: label, type: type)
    redirect_to edit_event_url(event)
  end
  # rubocop:enable Metrics/AbcSize

  private

  def content_hotspot_params
    params.require(:content_hotspot)
  end

  def url_hotspot_params
    params.require(:url_hotspot)
  end
end
