class TasksController < ApplicationController
  # require 'kaminari'
  before_action :signed_in_user, except: [:new]
  before_action ->(id= params[:user_id]) {correct_user(id)}, only: [:edit, :show]

  def new
  end
  def index
    @alltasks = Task.collect_tasks(nil, @current_user, all:true)
    @manager = Kaminari.paginate_array(@alltasks[:manager]).page(params[:page]).per(6) if params[:manager]
    @executor = Kaminari.paginate_array(@alltasks[:executor]).page(params[:page]).per(6) if params[:executor]
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
      render "main_pages/start", locals: {render: @render_tasks_of_day, task: @tasks}
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
      @manager = Kaminari.paginate_array(Task.collect_tasks(nil, @current_user, all:true)[:manager])
                                                              .page(params[:page]).per(6)
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
    # render text: params
    @task = Task.find_by_id(params[:id])
    if @task.update_attributes(task_params)
      @render_task = true
      # redirect_to root_path
      # render text: @task.name
      render "main_pages/start"
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :executor_id, :date_exec, :status)
  end
end
