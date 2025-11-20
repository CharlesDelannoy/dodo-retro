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
