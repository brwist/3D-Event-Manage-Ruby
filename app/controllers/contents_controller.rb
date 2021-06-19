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

    if @content.save
      flash[:notice] = 'Content was successfully created.'
    else
      flash[:alert] = @content.errors.full_messages.join('. ')
    end

    respond_to do |format|
      format.html do
        redirect_to contents_url
      end
    end
  end

  # PATCH/PUT /contents/1 or /contents/1.json
  def update
    authorize @content

    if @content.update(content_params)
      flash[:notice] = 'Content was successfully updated.'
    else
      flash[:alert] = @content.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.html { redirect_to edit_content_url(@content) }
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
