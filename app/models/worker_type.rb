class WorkerType < ApplicationRecord
  has_many :worker
  validates :name, presence: true
end