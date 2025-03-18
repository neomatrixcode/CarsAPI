class Brand < ApplicationRecord
  has_many :models, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def average_price
    models.average(:average_price).to_i
  end
end

