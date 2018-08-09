class Request < ApplicationRecord
  enum status: {pendiente: 0, aceptado: 1}
  belongs_to :user
  validates_presence_of :predio, :user_id
end
