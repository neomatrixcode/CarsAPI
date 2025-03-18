class Model < ApplicationRecord
  belongs_to :brand

  validates :name, presence: true
  validates :average_price,
    numericality: {
      greater_than: 100_000,
      message: "must be greater than 100,000"
    }

  validates_uniqueness_of :name, scope: :brand_id
end