# frozen_string_literal: true

class AddIceBreakerQuestionToRetrospectives < ActiveRecord::Migration[8.0]
  def change
    add_reference :retrospectives, :ice_breaker_question, foreign_key: true
  end
end
