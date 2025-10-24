class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :events, dependent: :destroy     
  has_many :attendances, dependent: :destroy
  has_many :joined_events, through: :attendances, source: :event
  has_many :notices
  has_many :comments, dependent: :destroy
end
