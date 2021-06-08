# frozen_string_literal: true

class LabelsController < ApplicationController
  # Intentionally abandoned the RESTful update method in favor of this
  def update_text
    label = Label.find(params[:label][:id])
    event = label.event

    if label.update(label_params)
      flash[:notice] = 'Label successfully updated'
    else
      flash[:alert] = "Label wasn't updated: #{label.errors.full_messages.join(', ')}"
    end

    redirect_to edit_event_url(event, tab: 'rooms')
  end

  private

  def label_params
    params.require(:label).permit(:text)
  end
end
