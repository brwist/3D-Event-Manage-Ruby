# frozen_string_literal: true

class HotspotsController < ApplicationController
  before_action :set_hotspot, only: [:destroy]

  # rubocop:disable Metrics/AbcSize
  def create
    token = Token.find(hotspot_params[:token_id])
    event = Event.find(hotspot_params[:event_id])
    room  = Room.find(hotspot_params[:room_id])

    authorize event, :update?

    case hotspot_params[:type]
    when 'navigation'
      token.detach_hotspot!(event_id: event.id)
      token.create_navigation_hotspot(event: event, room: room) if room.present?
      flash.now[:notice] = 'Navigation updated'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    authorize @hotspot
    event = @hotspot.event
    @hotspot.destroy!

    respond_to do |format|
      format.html { redirect_to edit_event_url(event), notice: 'Hotspot was successfully detached.' }
      format.json { head :no_content }
    end
  end

  private

  def set_hotspot
    @hotspot = Hotspot.find(params[:id])
  end

  def hotspot_params
    params.require(:hotspot)
  end
end
