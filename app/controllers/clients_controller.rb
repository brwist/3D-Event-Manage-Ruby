# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients or /clients.json
  def index
    @search = Client.reverse_chronologically.ransack(params[:q])
    @clients = set_page_and_extract_portion_from @search.result

    authorize @clients

    respond_to do |format|
      format.any(:html, :json) {}
      format.csv { render csv: @search.result }
    end
  end

  # GET /clients/1 or /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
    authorize @client
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients or /clients.json
  def create
    @client = Client.new(compact_parameters)
    authorize @client

    if @client.save
      flash[:notice] = 'Client was successfully created.'
    else
      flash[:alert] = @client.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.html { redirect_to clients_url }
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    if @client.update(compact_parameters)
      flash[:notice] = 'Client was successfully updated.'
    else
      flash[:alert] = @client.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.html { redirect_to edit_client_url(@client) }
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.friendly.find(params[:id])
    authorize @client
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:name, :slug)
  end

  def compact_parameters
    client_params[:slug].present? ? client_params : { name: client_params[:name] }
  end
end
