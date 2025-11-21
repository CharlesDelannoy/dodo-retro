# frozen_string_literal: true

class AddTicketGroupToTickets < ActiveRecord::Migration[8.0]
  def change
    add_reference :tickets, :ticket_group, foreign_key: true
  end
end
