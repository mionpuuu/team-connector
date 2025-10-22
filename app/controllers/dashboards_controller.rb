class DashboardsController < ApplicationController
  def index
    @events = Event.all
    @notices = Notice.order(created_at: :desc).limit(5)
  end
end
