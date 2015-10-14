class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :task_member?

  # def new
  # end

  def create
    comment = @task.comments.build(comment_params)
    @object_with_errors = comment unless comment.save
    respond_to do |format|
      unless @object_with_errors
        format.js { redirect_to user_task_path(@current_user, @task, new_comment: true)}
      else
        @comment = Comment.new
        format.js
      end 
    end
  end

  def edit
    @comment = Comment.find_by_id(params[:id])
    @edit_comment = true
    respond_to do |format|
      format.js { redirect_to user_task_path(@current_user.id, params[:task_id], edit_comment: params[:id])}
    end
  end

  def destroy
    Comment.find_by_id(params[:id]).destroy
    respond_to do |format|
      format.js { redirect_to user_task_path(@current_user, @task, new_comment: true), status: 303 }
    end
  end

  def update
    comment = Comment.find_by_id(params[:id])
    respond_to do |format|
      if comment.update_attributes(comment_params)
        format.js { redirect_to user_task_path(@current_user, @task, new_comment: true)}
      else
        @object_with_errors = comment
        @comments = Task.find_by_id(params[:task_id]).comments
        format.js {}
      end
    end
  end

  private

  def task_member?
    @task = Task.find(params[:task_id])
    @task.manager_id == @current_user.id || @task.executor_id == @current_user.id
  end

  def comment_params
    params.require(:comment).permit(:comment, :commenter)
  end
end
