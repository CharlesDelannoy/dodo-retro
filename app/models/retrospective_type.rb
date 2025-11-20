# frozen_string_literal: true

class RetrospectiveType < ApplicationRecord
  has_many :retrospective_columns, dependent: :destroy
  has_many :retrospectives, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
