class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create,:attend, :cancel]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :attend, :cancel]
  def index
    @events = Event.where("date >= ?", Date.today)
                 .order(date: :asc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to root_path, notice: 'イベントを作成しました'
    else
      puts @event.errors.full_messages 
      flash.now[:alert] = '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.includes(:user).order(created_at: :desc)
  end

  def attend
  @event = Event.find(params[:id])
  @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
  @attendance.status = :attending
  @attendance.notice = params[:notice]
  
  respond_to do |format|
    if @attendance.save
      format.html { redirect_to @event, notice: "参加登録しました！" }
      format.js   # attend.js.erb が呼ばれる
    else
      format.html { redirect_to @event, alert: "参加登録に失敗しました。" }
      format.js   { render js: "alert('参加登録に失敗しました。');" }
    end
  end
end

def cancel
  @event = Event.find(params[:id])
  @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
  @attendance.status = :absent
  @attendance.notice = params[:notice]
  
  respond_to do |format|
    if @attendance.save
      format.html { redirect_to @event, notice: "不参加として登録しました。" }
      format.js   # cancel.js.erb が呼ばれる
    else
      format.html { redirect_to @event, alert: "更新に失敗しました。" }
      format.js   { render js: "alert('更新に失敗しました。');" }
    end
  end
end

def pending
  @event = Event.find(params[:id])
  @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
  @attendance.status = :pending
  @attendance.notice = params[:notice]
  
  respond_to do |format|
    if @attendance.save
      format.html { redirect_to @event, notice: "保留にしました。" }
      format.js   # pending.js.erb が呼ばれる
    else
      format.html { redirect_to @event, alert: "更新に失敗しました。" }
      format.js   { render js: "alert('更新に失敗しました。');" }
    end
  end
end



  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if params[:event][:images]
    @event.images.attach(params[:event][:images])
    end

  if @event.update(event_params.except(:images))
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

  def archive
  @events_by_month = Event.where("date < ?", Date.today)
                          .order(date: :desc)
                          .group_by { |e| e.date.strftime("%Y年%m月") }
  end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :date, :time, :location, :fee, :description, images: [])
  end
end