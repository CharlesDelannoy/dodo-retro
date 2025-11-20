# frozen_string_literal: true

class IceBreakerQuestion < ApplicationRecord
  QUESTION_TYPES = %w[question action].freeze

  has_many :retrospectives, dependent: :restrict_with_error

  validates :content, presence: true
  validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES }
end
