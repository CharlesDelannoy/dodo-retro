class AddCurrentIceBreakerQuestionIdToRetrospectives < ActiveRecord::Migration[8.0]
  def change
    add_column :retrospectives, :current_ice_breaker_question_id, :bigint
    add_foreign_key :retrospectives, :ice_breaker_questions, column: :current_ice_breaker_question_id
    add_index :retrospectives, :current_ice_breaker_question_id
  end
end
