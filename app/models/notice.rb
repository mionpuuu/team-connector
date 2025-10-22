class Notice < ApplicationRecord
  belongs_to :user
  has_many_attached :image # 画像添付（ActiveStorage用）
end
