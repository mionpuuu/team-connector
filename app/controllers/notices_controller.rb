class NoticesController < ApplicationController
  def new
    @notice = Notice.new
  end

  def create
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
