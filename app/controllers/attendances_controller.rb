class AttendancesController < ApplicationController
  before_action :set_attendance

  def destroy
    @attendance.destroy
    redirect_to event_url(@attendance.event), notice: 'Participation canceled'
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end
end
