class Material < ApplicationRecord
  before_save { self.name = name.downcase }
  validates :name, presence: {message: 'Nombre es requerido'},
            length: {maximum: 255}
  validates :quantity, numericality: {:greater_than_or_equal_to => 0, :less_than => 2147483647, :only_integer => true, :message => 'Ingresar un numero valido'},
            presence: {message: 'Cantidad es requerida'}
  validates :price, presence: {message: 'Precio es requerido'},
            numericality: {greater_than: 0, less_than: 2147483647, message: 'Ingresar un numero valido'}
  validates :user_id, presence: true
  belongs_to :user
  has_many :info_predio_detalle
  has_many :material, through: :info_predio_detalle

end

# 2,147,483,647