class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @events = Event.all.order(date: :asc)
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

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to root_path, notice: 'イベントを更新しました'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to root_path, notice: 'イベントを削除しました'
  end

  private

  def event_params
    params.require(:event).permit(:title, :date, :time, :location, :fee, :description, images: [])
  end
end