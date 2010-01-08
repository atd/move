class AttendancesController < ActionController::Base
  authentication_filter

  def index
    redirect_to polymorphic_path(current_event!, :anchor => 'attendance')
  end

  def create
    unless current_event!.attendees.include?(current_agent)
      current_event!.attendees << current_agent
      flash[:success] = t('attendance.created')
    end

    redirect_to polymorphic_path(current_event!, :anchor => 'attendees')
  end
  
  def destroy
    if current_event!.attendees.include?(current_agent)
      current_event!.attendances.find_by_user_id(current_user.id).destroy
      flash[:success]  = t('attendance.deleted')
    end

    redirect_to polymorphic_path(current_event!, :anchor => 'attendees')
  end

  private

  def current_event!
    @event ||= Event.find_with_param(params[:event_id]) || raise(ActiveRecord::RecordNotFound)
  end
end
