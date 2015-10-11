class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :task_member?

  # def new
  # end

  def create
    comment = @task.comments.build(comment_params)
    @object_with_errors = comment unless comment.save
    respond_to do |format|
      format.js { redirect_to user_task_path(@current_user, @task, new_comment: true)}
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
