class Nutriente < ApplicationRecord
  validates :nombre, presence: {message: 'Es un campo requerido'}
  validates :precio, presence: {message: 'Es un campo requerido'},
            format: {with: /\A\d+(?:\.\d{0,2})?\z/},
            numericality: {greater_than: 0, less_than: 1000000}
end
