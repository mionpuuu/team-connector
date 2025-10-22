class NoticesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @notices = Notice.all.order(created_at: :desc)
  end

  def new
    @notice = Notice.new
  end

  def create
     @notice = current_user.notices.build(notice_params)
    if @notice.save
      redirect_to root_path, notice: 'お知らせを作成しました！'
    else
      flash.now[:alert] = '作成に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:title, :content, :pinned)
  end
end
