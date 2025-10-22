class EventsController < ApplicationController
  def index
    @events = Event.order(date: :asc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to root_path, notice: 'イベントを作成しました'
    else
      flash.now[:alert] = '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:title, :date, :time, :location, :fee, :description, :image)
  end
end