# frozen_string_literal: true

class AttendeesController < ApplicationController
  before_action :set_attendee

  def destroy
    @attendee.destroy
    redirect_to event_url(@attendee.event, 'Participance cancelled')
  end

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end
end
