class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :attend, :cancel, :pending]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :attend, :cancel, :pending]
  
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
    @comments = @event.comments.includes(:user).order(created_at: :desc)
    @attendance_counts = calculate_attendance_counts(@event)
  end

  def attend
    @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
    @attendance.status = :attending
    @attendance.notice = params[:notice]
    
    if @attendance.save
      @attendance_counts = calculate_attendance_counts(@event)
      
      render json: {
        html: render_to_string(partial: 'attendance_list', locals: { event: @event }, formats: [:html])
      }
    else
      render json: { message: '更新に失敗しました。' }, status: :unprocessable_entity
    end
  end

  def cancel
    @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
    @attendance.status = :absent
    @attendance.notice = params[:notice]
    
    if @attendance.save
      @attendance_counts = calculate_attendance_counts(@event)
      
      render json: {
        html: render_to_string(partial: 'attendance_list', locals: { event: @event }, formats: [:html])
      }
    else
      render json: { message: '更新に失敗しました。' }, status: :unprocessable_entity
    end
  end

  def pending
    @attendance = Attendance.find_or_initialize_by(user: current_user, event: @event)
    @attendance.status = :pending
    @attendance.notice = params[:notice]
    
    if @attendance.save
      @attendance_counts = calculate_attendance_counts(@event)
      
      render json: {
        html: render_to_string(partial: 'attendance_list', locals: { event: @event }, formats: [:html])
      }
    else
      render json: { message: '更新に失敗しました。' }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
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

  def calculate_attendance_counts(event)
    {
      attending: event.attendances.where(status: :attending).count,
      pending: event.attendances.where(status: :pending).count,
      absent: event.attendances.where(status: :absent).count,
      total_members: User.count,
      responded: event.attendances.count
    }
  end

  def event_params
    params.require(:event).permit(:title, :date, :time, :location, :fee, :description, images: [])
  end
end