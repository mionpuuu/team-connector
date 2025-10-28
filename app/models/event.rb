class Event < ApplicationRecord
  belongs_to :user
  has_many_attached :images 
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user
  has_many :comments, dependent: :destroy

  validates :title, :date, :location, :description, presence: true

  scope :upcoming, -> { where("date >= ?", Date.today).order(date: :asc) }

  # スコープ: 過去の試合(日付降順)
  scope :past, -> { where("date < ?", Date.today).order(date: :desc) }

  # スコープ: 今月の試合
  scope :this_month, -> { 
    where(date: Date.today.beginning_of_month..Date.today.end_of_month)
      .order(date: :asc)
  }

  # 出欠状況の集計を返すメソッド
  def attendance_summary
    {
      attending: attendances.where(status: :attending).count,
      pending: attendances.where(status: :pending).count,
      absent: attendances.where(status: :absent).count,
      total_members: User.count,
      responded: attendances.count,
      not_responded: User.count - attendances.count
    }
  end

  # 特定のユーザーの出欠状況を返すメソッド
  def attendance_status_for(user)
    attendances.find_by(user: user)&.status || 'not_responded'
  end

  # 過去の試合かどうかを判定
  def past?
    date < Date.today
  end

  # 今月の試合かどうかを判定
  def this_month?
    date.year == Date.today.year && date.month == Date.today.month
  end
end
