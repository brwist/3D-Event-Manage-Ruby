# frozen_string_literal: true

class AttendeesController < ApplicationController
  before_action :set_event, only: [:create]
  before_action :set_attendee, only: [:destroy]

  def create
    @attendee = @event.attendees.build(attendee_params)
    authorize @attendee

    if @attendee.save
      flash[:notice] = 'Attendee created'
    else
      flash[:error] = @attendee.errors.full_messages.join('. ')
    end

    redirect_to @event
  end

  def destroy
    authorize @attendee

    @attendee.destroy
    redirect_to edit_event_url(@attendee.event), notice: 'Participance cancelled'
  end

  private

  def attendee_params
    params.require(:attendee).permit(:name, :email)
  end

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_event
    @event = Event.friendly.find(params[:event_id])
  end
end
