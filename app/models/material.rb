   class Material < ApplicationRecord
     before_save { self.name = name.downcase }
     validates :name, presence: { message: "Nombre es requerido" },
               length: { maximum: 255 }
     validates :quantity, numericality: { only_integer: true },
               presence: { message: 'Cantidad es requerida'}
     validates :price, presence: { message: 'Precio es requerido'}
     belongs_to :user
     validates :user_id, presence: true
     has_many :info_predio_detalle
     has_many :material, through: :info_predio_detalle

   end