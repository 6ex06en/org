class TasksController < ApplicationController
  # require 'kaminari'
  before_action :signed_in_user, except: [:new]
  before_action ->(id= params[:user_id]) {correct_user(id)}, only: [:edit, :show, :update, :destroy, :handle_task]

  def new
  end
  def index
    if params[:manager]
      @manager = @current_user.tasks_from_me.order(date_exec: :desc).page(params[:page]).per(6)
      @request = "manager"
    else
      @executor = @current_user.tasks_to_me.order(date_exec: :desc).page(params[:page]).per(6)
      @request = "executor"
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @task = Task.find_by_id(params[:id])
  end

  def show
    @task = Task.find_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    task = @current_user.tasks_from_me.build(task_params)
    @refresh_page_or_repeat = true
    if task.save
      flash.now[:success] = "Задача создана"
      @tasks = Task.collect_tasks(session[:saved_day], @current_user, only_day: true)
      @render_tasks_of_day = true
      render "main_pages/start", locals: {render: @render_tasks_of_day, task: @tasks}
      # respond_to do |format|
      #   format.js {render layout: false}
      # end
    else
      @render_task_form = true
      @date = params[:task][:date_exec]
      @object_with_errors = task 
      render "main_pages/start"
    end
  end

  def destroy
    task = Task.find_by_id(params[:id]).destroy
    @tasks = Task.collect_tasks(session[:saved_day], @current_user, only_day: true)
    if params[:all_tasks]
      @render_all_tasks = true
      @manager = @current_user.tasks_from_me.page(params[:page]).per(6)
    else
      @render_tasks_of_day = true
    end
    flash.now[:success] = "Задача удалена"
    render "main_pages/start"
  end

  def update
    @task = Task.find_by_id(params[:id])
    if @task.update_attributes(task_params)
      flash.now[:success] = "Задача обновлена"
      @tasks = Task.collect_tasks(@task.date_exec, @current_user, only_day: true)
      @render_tasks_of_day = true
      render "main_pages/start", locals: {render: @render_tasks_of_day, task: @tasks}
    else
      @render_edit_task = true
      @object_with_errors = @task 
      render "main_pages/start", locals: {render: @render_edit_task, task: @task}
    end
  end

  def tasks_of_day    
      date = params[:date]
      date = session[:saved_day] if params[:back]
      session[:saved_day] = date
      @tasks = Task.collect_tasks(date, @current_user, only_day: true)
      respond_to do |format|
        format.js
      end
  end

  def create_task
    @date = params[:date].to_date.strftime("%FT%R")
    session[:saved_day] = @date
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

  def handle_task
    @task = Task.find_by_id(params[:id])
    if params[:commit] == "Принять"
      @task.update_attributes(status: "execution")
    elsif params[:commit] == "Приостановить"
      @task.update_attributes(status: "pause")
    elsif params[:commit] == "Возобновить"
      @task.update_attributes(status: "execution")
    elsif params[:commit] == "Завершить"
      @task.update_attributes(status: "complete")
    elsif params[:commit] == "Закрыть"
      @task.update_attributes(status: "archived")
    end
    @render_task = true
    render "main_pages/start"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :executor_id, :date_exec, :commit)
  end
end
