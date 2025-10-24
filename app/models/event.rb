class Event < ApplicationRecord
  belongs_to :user
  has_many_attached :images 
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user
  has_many :comments, dependent: :destroy

  validates :title, :date, :location, :description, presence: true
end
