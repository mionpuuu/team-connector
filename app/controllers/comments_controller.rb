class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @event, notice: "コメントを投稿しました"
    else
      redirect_to @event, alert: "コメントの投稿に失敗しました"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
