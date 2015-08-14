class TasksController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :edit, :get_tasks, :create_task, :tasks_of_day, :show]
  before_action ->(id= params[:user_id]) {correct_user(id)}, only: [:edit, :show]

  def new
  end

  def edit
  end

  def show
    @task = Task.find_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    task = @current_user.tasks_from_me.build(task_params)
    if task.save
      flash[:success] = "Задача создана"
      redirect_to root_path
    else
      @render = true
      @date = params[:task][:date_exec]
      @object_with_errors = task 
      render "main_pages/start", locals: {render: @render, date: @date}
    end
  end

  def destroy
  end

  def update
  end

  def tasks_of_day
    date = params[:date]
    @tasks = Task.collect_tasks(date, @current_user, only_day: true)
    respond_to do |format|
      format.js
    end
  end

  def create_task
    @date = params[:date].to_date.strftime("%FT%R")
    respond_to do |format|
      format.js
    end
  end

  def get_tasks
    date = params[:date]
    respond_to do |format|
      format.json { render json: JSON.parse(Task.collect_tasks(date, @current_user).to_json).merge(id: current_user.id), status: 200}
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :executor_id, :date_exec)
  end
end
