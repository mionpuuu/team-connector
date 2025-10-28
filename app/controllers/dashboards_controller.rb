class DashboardsController < ApplicationController
  def index
    # 今日以降の試合を日付の近い順に5件だけ表示
    @events = Event.upcoming.limit(5)

    # お知らせは最新順で5件
    @pinned_notices = Notice.where(pinned: true).order(created_at: :desc)
    @notices = Notice.where.not(id: @pinned_notices.pluck(:id))
                   .order(created_at: :desc)

  end
end
