class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :events, through: :attendances
  has_many :notices
  has_many :attendances, dependent: :destroy
  has_many :comments, dependent: :destroy
end
