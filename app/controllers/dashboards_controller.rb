class DashboardsController < ApplicationController
  def index
    # 今日以降の試合を日付の近い順に5件だけ表示
    @events = Event.upcoming.limit(5)

    # 今月のお知らせのみを取得
    start_of_month = Date.current.beginning_of_month
    end_of_month = Date.current.end_of_month

    # 重要なお知らせ（ピン留め）は今月のものだけ
    @pinned_notices = Notice.where(pinned: true)
                           .where(created_at: start_of_month..end_of_month)
                           .order(created_at: :desc)
    
    # 通常のお知らせも今月のものだけ（ピン留め以外）
    @notices = Notice.where(pinned: false)
                   .where(created_at: start_of_month..end_of_month)
                   .order(created_at: :desc)
  end
end
