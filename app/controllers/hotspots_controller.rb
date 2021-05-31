# frozen_string_literal: true

class HotspotsController < ApplicationController
  before_action :set_hotspot

  def destroy
    authorize @hotspot
    token = @hotspot.token
    event = @hotspot.event
    token.detach_hotspot!(event_id: event.id)

    respond_to do |format|
      format.html { redirect_to edit_event_url(event), notice: 'Hotspot was successfully detached.' }
      format.json { head :no_content }
    end
  end

  private

  def set_hotspot
    @hotspot = Hotspot.find(params[:id])
  end
end
