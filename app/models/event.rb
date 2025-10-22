class Event < ApplicationRecord
  belongs_to :user
  has_many_attached :image # 画像添付（ActiveStorage用）

  validates :title, :date, :location, :description, presence: true
end
