class Event < ApplicationRecord
  belongs_to :user
  has_many_attached :images 
  validates :title, :date, :location, :description, presence: true
end
