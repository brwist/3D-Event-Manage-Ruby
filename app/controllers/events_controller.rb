# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy upload_attendees]

  def index
    @search = Event.includes(:client).reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @events = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    @attendees = @event.attendees
    fresh_when etag: @event
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    @event.save!

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully created.' }
      format.json { render :show, status: :created }
    end
  end

  def update
    @event.update!(event_params)
    respond_to do |format|
      format.html { redirect_to @event, notice: 'Event was successfully updated.' }
      format.json { render :show }
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_attendees
    importer = AttendeesImporter.new(@event, params[:upload][:file])

    if importer.call
      flash[:notice] = 'Attendees added'
    else
      flash[:error] = importer.errors_report
    end

    redirect_to @event
  end

  private

  def set_event
    @event = Event.friendly.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :client_id)
  end
end
