   class Material < ApplicationRecord
     validates :name, presence: true,
               length: { maximum: 255 }
     #validates :price, numericality: { only_integer: true }
     validates :quantity, numericality: { only_integer: true }
     belongs_to :user
     validates :user_id, presence: true

   end