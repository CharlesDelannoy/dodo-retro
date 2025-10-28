class Team < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :pending_invitations, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
end
