class NoticesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @notices = Notice.where("created_at < ?", Time.current.beginning_of_month)
                   .order(created_at: :desc)
  end

  def archive
      @notices_by_month = Notice
                        .where("created_at < ?", 3.months.ago.beginning_of_month)
                        .order(created_at: :desc)
                        .group_by { |n| n.created_at.strftime("%Y年%m月") }
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


  def edit
  @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update(notice_params)
      redirect_to notice_path(@notice), notice: 'お知らせを更新しました！'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy
    redirect_to root_path, notice: 'お知らせを削除しました。'
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :content, :pinned, images: [])
  end
end
