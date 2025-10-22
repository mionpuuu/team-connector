class DashboardsController < ApplicationController
  def index
    @events = Event.order(date: :asc)
    @notices = Notice.order(date: :desc)
  end
end
