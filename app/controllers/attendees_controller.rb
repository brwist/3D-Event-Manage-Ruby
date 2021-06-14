# frozen_string_literal: true

class AttendeesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :authenticate_model!, only: [:show]
  before_action :set_event, only: [:create]
  before_action :set_attendee, only: %i[show destroy]

  def show
    not_authorized! unless AttendeePolicy.new(current_user, @attendee, current_attendee).show?
    render :show, layout: nil
  end

  def create
    @attendee = @event.attendees.build(attendee_params)
    authorize @attendee

    if @attendee.save
      flash[:notice] = 'Attendee created'
    else
      flash[:error] = @attendee.errors.full_messages.join('. ')
    end

    redirect_to edit_event_url(@event, tab: 'attendees')
  end

  def destroy
    authorize @attendee
    @attendee.destroy
    redirect_to edit_event_url(@attendee.event, tab: 'attendees'), notice: 'Participance cancelled'
  end

  private

  def attendee_params
    params.require(:attendee).permit(:name, :email, :password)
  end

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_event
    @event = Event.friendly.find(params[:event_id])
  end

  def authenticate_model!
    if current_attendee
      authenticate_attendee!
    else
      authenticate_user!
    end
  end

  def not_authorized!
    raise Pundit::NotAuthorizedError, "Not allowed to view the resource #{@attendee.inspect}"
  end
end
