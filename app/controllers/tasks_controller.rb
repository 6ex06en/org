class TasksController < ApplicationController
  before_action :signed_in_user, except: [:new]
  before_action ->(id= params[:user_id]) {correct_user(id)}, only: [:edit, :show, :update, :destroy, :handle_task]

  def new
  end
  def index
    if params[:manager]
      @manager = @current_user.tasks_from_me.order(date_exec: :desc).page(params[:page]).per(6)
      @request = "manager"
    elsif params[:executor]
      @executor = @current_user.tasks_to_me.order(date_exec: :desc).page(params[:page]).per(6)
      @request = "executor"
    elsif params[:filter_tasks]
      @render_filter = true
    elsif params[:tasks]
      # @filter = Task.filter_tasks(params[:tasks])
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
    if task.save
      flash.now[:success] = "Задача создана"
      @tasks = Task.collect_tasks(session[:saved_day], @current_user, only_day: true)
      @render_tasks_of_day = true
      @build_calendar = true 
      respond_to do |format|
        format.js {}
      end
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
    @build_calendar = true 
    if params[:all_tasks]
      @render_all_tasks = true
      @manager = @current_user.tasks_from_me.page(params[:page]).per(6)
    else
      @render_tasks_of_day = true
    end
    flash.now[:success] = "Задача удалена"
    respond_to do |format|
      format.js {}
    end
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
    if params[:date] == "saved"
      @date = session[:saved_day].to_date.strftime("%FT%R")
    else
      @date = params[:date].to_date.strftime("%FT%R")
      session[:saved_day] = @date
    end
    # render text: @date + "session" + session[:saved_day].to_date.strftime("%FT%R")    
    @build_calendar = true
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
    if params[:commit] == "Начать"
      @task.update_attributes(status: "execution")
    elsif params[:commit] == "Приостановить"
      @task.update_attributes(status: "pause")
    elsif params[:commit] == "Возобновить"
      @task.update_attributes(status: "execution")
    elsif params[:commit] == "Завершить"
      @task.update_attributes(status: "completed")
    elsif params[:commit] == "Принять работу"
      @task.update_attributes(status: "finished")
    elsif params[:commit] == "В архив"
      @task.update_attributes(status: "archived")
    end
    @render_task = true
    respond_to do |format|
      format.js {}
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :executor_id, :date_exec, :commit)
  end
end
