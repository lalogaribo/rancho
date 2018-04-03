class Predio < ApplicationRecord
  validates :name, presence: true
  validates :no_hectareas, presence: true
  belongs_to :user
  validates :user_id, presence: true
  validates :no_hectareas, numericality: { only_integer: true }
  default_scope -> { order(updated_at: :DESC) }
end