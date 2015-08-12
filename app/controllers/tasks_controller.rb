class TasksController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :edit, :get_tasks, :create_task]

  def new
  end

  def edit
  end

  def create
    task = @current_user.tasks_from_me.build(task_params)
    if task.save
      flash[:success] = "Задача создана"
      redirect_to root_path
    else
      @object_with_errors = task 
      render "main_pages/start"
    end
  end

  def destroy
  end

  def update
  end

  def tasks_of_day
  end

  def create_task
    respond_to do |format|
      format.js
    end
  end

  def get_tasks
    respond_to do |format|
      format.json { render json: JSON.parse(Task.collect_tasks_year(params[:date], @current_user).to_json).merge(id: current_user.id), status: 200}
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :executor_id, :date_exec)
  end
end
