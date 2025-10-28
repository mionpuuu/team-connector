class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { undecided: 0, attending: 1, absent: 2, pending: 3 }
end
