class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :created_teams, class_name: 'Team', foreign_key: 'creator_id', dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :teams, through: :participants

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(u) { u.strip }
end
