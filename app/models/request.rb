class Request < ApplicationRecord
  belongs_to :user
  validates_presence_of :predio, :user_id
end
