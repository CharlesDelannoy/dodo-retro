# frozen_string_literal: true

class TicketGroup < ApplicationRecord
  belongs_to :retrospective
  belongs_to :created_by, class_name: "User"
  has_many :tickets, dependent: :nullify

  broadcasts_to ->(group) { [group.retrospective.team, group.retrospective] }, inserts_by: :prepend
end
