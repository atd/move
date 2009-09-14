class TurnsController < ApplicationController
  # Include CRUD methods.
  #
  # You can overwritte them if you need it, but consider adding 
  # the functionality in the Model
  # include ActionController::StationResources

  before_filter :current_container!

  def create
    @turn = current_task.turns.new params[:turn]

    if @turn.save
      flash[:success] = t('turn.created')
    else
      flash[:error] = @turn.errors.to_xml
    end

    redirect_to polymorphic_path([ current_task.container, current_container ], :action => :edit)
  end

  def sort
    params[:turns].each_with_index do |id, index|
      current_task.turns.update_all(['position=?', index+1], ['id=?', id])
    end

    render :nothing => true
  end

  def destroy
    @turn = current_task.turns.find params[:id]

    @turn.destroy

    redirect_to polymorphic_path([ current_task.container, current_task ], :action => :edit, :anchor => 'turns')
  end

  private

  def current_task
    current_container
  end

end
