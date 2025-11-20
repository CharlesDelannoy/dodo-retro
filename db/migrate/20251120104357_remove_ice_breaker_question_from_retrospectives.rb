# frozen_string_literal: true

class RemoveIceBreakerQuestionFromRetrospectives < ActiveRecord::Migration[8.0]
  def change
    remove_reference :retrospectives, :ice_breaker_question, foreign_key: true
  end
end
