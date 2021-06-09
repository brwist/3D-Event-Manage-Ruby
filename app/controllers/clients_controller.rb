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

    respond_to do |format|
      if @client.save
        format.html { redirect_to clients_url, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(compact_parameters)
        format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
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
