class DashboardsController < ApplicationController
  def index
    # 今日以降の試合を日付の近い順に5件だけ表示
    @events = Event.where("date >= ?", Date.today)
                   .order(date: :asc)
                   .limit(5)

    # お知らせは最新順で5件
    @notices = Notice.order(created_at: :desc).limit(5)
  end
end
