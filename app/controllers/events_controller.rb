# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy upload_attendees publish unpublish]
  before_action :set_dropdown_values, only: %i[new edit]
  after_action :clear_session, only: :edit

  def index
    @search = Event.includes(:client).reverse_chronologically.ransack(params[:q])
    authorize @search.result

    respond_to do |format|
      format.any(:html, :json) { @events = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show; end

  def new
    @event = Event.new
    authorize @event
  end

  def edit
    authorize @event

    setup_tab
    @attendees = set_page_and_extract_portion_from @event.attendees, ordered_by: { created_at: :desc }
    @navigation_tokens = Token.navigation
  end

  def create
    @event = Event.new(event_params)
    authorize @event

    if @event.save
      flash[:notice] = 'Event was successfully created.'
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.html { redirect_to events_url }
    end
  end

  def update
    authorize @event

    if @event.update(event_params)
      flash[:notice] = 'Event was successfully updated.'
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.html { redirect_to edit_event_url(@event) }
    end
  end

  def destroy
    authorize @event
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_attendees
    authorize @event
    importer = AttendeesImporter.new(@event, params[:upload][:file])

    if importer.call
      flash[:notice] = 'Attendees added'
    else
      flash[:error] = importer.errors_report
    end

    session[:attendees_report] = importer.logs_html_report
    redirect_to edit_event_url(@event, tab: 'attendees')
  end

  def publish
    @event.publish
    respond_to do |format|
      format.js { flash.now[:notice] = 'Event published' }
    end
  end

  def unpublish
    @event.unpublish
    respond_to do |format|
      format.js { flash.now[:notice] = 'Event unpublished' }
    end
  end

  private

  def set_event
    @event = Event.friendly.find(params[:id])
  end

  def set_dropdown_values
    @rooms = Room.all
    @clients = Client.order(:name)
    @content_images = Content.images.limit(5).order(:name)
  end

  def event_params
    params.require(:event).permit(
      :name, :start_time, :end_time, :client_id, :main_entrance_id, :tag_list,
      :landing_prompt, :landing_logo, :landing_background_color, :landing_foreground_color,
      :invitation_scheduled, :send_invitation_at, :timezone
    )
  end

  def setup_tab
    tab = params[:tab].to_s.downcase
    @tab = %w[attendees permissions rooms].include?(tab) ? tab : 'details'
  end

  def clear_session
    session[:attendees_report] = nil if session[:attendees_report].present?
  end
end
