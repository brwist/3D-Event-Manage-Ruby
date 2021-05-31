# frozen_string_literal: true

class ContentsController < ApplicationController
  before_action :set_content, only: %i[show edit update destroy]

  # GET /contents or /contents.json
  def index
    @search = Content.includes(:tags).reverse_chronologically.ransack(params[:q])
    authorize @search.result

    respond_to do |format|
      format.any(:html, :json) { @contents = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  # GET /contents/1 or /contents/1.json
  def show; end

  # GET /contents/new
  def new
    @content = Content.new
    authorize @content
  end

  # GET /contents/1/edit
  def edit
    authorize @content
  end

  # POST /contents or /contents.json
  def create
    authorize(@content = Content.new(content_params))

    respond_to do |format|
      if @content.save
        format.html do
          redirect_to contents_url, notice: 'Content was successfully created.'
        end
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1 or /contents/1.json
  def update
    authorize @content

    respond_to do |format|
      if @content.update(content_params)
        format.html do
          redirect_to contents_url, notice: 'Content was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1 or /contents/1.json
  def destroy
    authorize @content

    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: 'Content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_content
    @content = Content.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def content_params
    params.require(:content).permit(:name, :file, :tag_list)
  end
end
