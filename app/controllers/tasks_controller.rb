class TasksController < ApplicationController
  before_action :signed_in_user, except: [:new]
  before_action ->(id= params[:user_id]) {correct_user(id)}, only: [:edit, :show, :update, :destroy, :handle_task]

  def new
  end

  def index
    if params[:manager]
      if params[:with_archived] == 'true'
        @manager = @current_user.tasks_from_me.order(date_exec: :desc).page(params[:page]).per(6)
      else
        @manager = @current_user.tasks_from_me.order(date_exec: :desc).where("status IS NOT 'archived'").page(params[:page]).per(6)
      end
    elsif params[:executor]
      if params[:with_archived] == 'true'
        @executor = @current_user.tasks_to_me.order(date_exec: :desc).page(params[:page]).per(6)
      else
        @executor = @current_user.tasks_to_me.order(date_exec: :desc).where("status IS NOT 'archived'").page(params[:page]).per(6)
      end
    elsif params[:filter_tasks]
      @render_filter = true
    elsif params[:tasks]
      @filter_tasks = Task.filter_tasks(@current_user, params[:tasks]).order(date_exec: :desc).page(params[:page]).per(6)
    end
    respond_to do |format|
      format.js {}
      format.html {
        @render_all_tasks = true
        render "main_pages/start"
      }
    end
  end

  def edit
    @task = Task.find_by_id(params[:id])
  end

  def show
    # @comment = Comment.new
    # @task = Task.find_by_id(params[:id])
    @task = Task.includes(:comments).where(tasks: {id: params[:id]}).first
    @new_comment = true if params[:new_comment].present?
    if params[:edit_comment].present?
      @edit_comment = true
      @comment = Comment.find_by_id(params[:edit_comment])
    end
    @comments = @task.comments
    respond_to do |format|
      format.js
    end
  end

  def create
    task = @current_user.tasks_from_me.build(task_params)
    if task.save
      @tasks = Task.collect_tasks(session[:saved_day], @current_user, only_day: true)
      News.create_news(task, :new_task)
      flash.now[:success] = "Задача создана"
      @render_tasks_of_day = true
      @build_calendar = true
    else
      @render_task_form = true
      @date = params[:task][:date_exec]
      @object_with_errors = task
    end
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    task = Task.find_by_id(params[:id]).destroy
    @tasks = Task.collect_tasks(session[:saved_day], @current_user, only_day: true)
    @build_calendar = true
    if params[:all_tasks]
      @render_all_tasks = true
      if params[:with_archived] == 'true'
        @manager = @current_user.tasks_from_me.page(params[:page]).per(6)
      else
        @manager = @current_user.tasks_from_me.order(date_exec: :desc).where("status IS NOT 'archived'").page(params[:page]).per(6)
      end
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
      @build_calendar = true
    else
      @render_edit_task = true
      @object_with_errors = @task
    end
    respond_to do |format|
      format.js {}
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
      session[:saved_day] ||= Date.today.strftime("%FT%R")
      @date = session[:saved_day].to_date.strftime("%FT%R")
    else
      @date = params[:date].to_date.strftime("%FT%R")
      session[:saved_day] = @date
    end
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
    elsif params[:commit] == "Выполнена"
      @task.update_attributes(status: "completed")
      News.create_news(@task, :task_complete)
    elsif params[:commit] == "Принять работу"
      @task.update_attributes(status: "finished")
    elsif params[:commit] == "Доделать"
      @task.update_attributes(status: "execution")
      News.create_news(@task, :new_task)
    elsif params[:commit] == "Закрыть"
      @task.update_attributes(status: "archived")
      respond_to do |format|
        format.js { redirect_to user_tasks_path(@current_user, manager:true), status: 303 and return}
      end
    end
    @comments = @task.comments
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
