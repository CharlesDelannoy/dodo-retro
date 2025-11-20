# frozen_string_literal: true

class CreateIceBreakerQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :ice_breaker_questions do |t|
      t.text :content, null: false
      t.string :question_type, null: false

      t.timestamps
    end
  end
end
