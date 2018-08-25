class WorkerType < ApplicationRecord
  belongs_to :worker
  validates :name, presence: true
end