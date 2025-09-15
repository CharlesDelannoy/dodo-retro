class Team < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
end
