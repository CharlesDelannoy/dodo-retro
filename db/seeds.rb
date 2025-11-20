# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Retrospective Types
plus_minus_interesting = RetrospectiveType.find_or_create_by!(name: 'Plus/Minus/Interesting') do |type|
  type.description = 'Classic retrospective format with three categories: Plus (what went well), Minus (what could be improved), and Interesting (observations and insights)'
end

# Retrospective Columns for Plus/Minus/Interesting
RetrospectiveColumn.find_or_create_by!(retrospective_type: plus_minus_interesting, name: 'Plus') do |column|
  column.color = '#22c55e' # green
  column.position = 0
end

RetrospectiveColumn.find_or_create_by!(retrospective_type: plus_minus_interesting, name: 'Minus') do |column|
  column.color = '#ef4444' # red
  column.position = 1
end

RetrospectiveColumn.find_or_create_by!(retrospective_type: plus_minus_interesting, name: 'Interesting') do |column|
  column.color = '#3b82f6' # blue
  column.position = 2
end

puts "✅ Seeded retrospective types and columns"

# Ice Breaker Questions
ice_breaker_questions = [
  { content: "If you could have dinner with any historical figure, who would it be and why?", question_type: "question" },
  { content: "What's the most interesting thing you've learned this week?", question_type: "question" },
  { content: "If you could master any skill instantly, what would it be?", question_type: "question" },
  { content: "What's your favorite way to spend a weekend?", question_type: "question" },
  { content: "If you could live in any fictional universe, which one would you choose?", question_type: "question" },
  { content: "What's the best advice you've ever received?", question_type: "question" },
  { content: "If you could teleport anywhere right now, where would you go?", question_type: "question" },
  { content: "What's your go-to karaoke song?", question_type: "question" },
  { content: "If you could have any superpower for a day, what would it be?", question_type: "question" },
  { content: "What's the most unusual food you've ever tried?", question_type: "question" },
  { content: "Show us your workspace or office setup!", question_type: "action" },
  { content: "Show us your favorite mug or drink!", question_type: "action" },
  { content: "Share a photo of your pet (or your dream pet)!", question_type: "action" },
  { content: "Show us something on your desk that has a story!", question_type: "action" },
  { content: "Strike your best superhero pose!", question_type: "action" },
  { content: "Show us your most prized possession!", question_type: "action" },
  { content: "Do your best impression of a famous person!", question_type: "action" },
  { content: "Show us your favorite book or movie!", question_type: "action" }
]

ice_breaker_questions.each do |question_data|
  IceBreakerQuestion.find_or_create_by!(content: question_data[:content]) do |question|
    question.question_type = question_data[:question_type]
  end
end

puts "✅ Seeded #{IceBreakerQuestion.count} ice breaker questions"
