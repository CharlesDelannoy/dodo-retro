# frozen_string_literal: true

class RetrospectiveColumn < ApplicationRecord
  belongs_to :retrospective_type

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope { order(position: :asc) }
end
