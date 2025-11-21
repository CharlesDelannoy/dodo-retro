# frozen_string_literal: true

module TicketsHelper
  USER_COLORS = [
    { bg: '#FEE2E2', border: '#FCA5A5', text: '#991B1B' },   # Red
    { bg: '#DBEAFE', border: '#93C5FD', text: '#1E3A8A' },   # Blue
    { bg: '#D1FAE5', border: '#6EE7B7', text: '#065F46' },   # Green
    { bg: '#FEF3C7', border: '#FCD34D', text: '#78350F' },   # Yellow
    { bg: '#E9D5FF', border: '#C084FC', text: '#581C87' },   # Purple
    { bg: '#FFEDD5', border: '#FDBA74', text: '#7C2D12' },   # Orange
    { bg: '#FCE7F3', border: '#F9A8D4', text: '#831843' },   # Pink
    { bg: '#D1FAE5', border: '#6EE7B7', text: '#064E3B' },   # Teal
    { bg: '#E0E7FF', border: '#A5B4FC', text: '#3730A3' },   # Indigo
    { bg: '#FED7AA', border: '#FDBA74', text: '#92400E' }    # Amber
  ].freeze

  def user_color(user)
    USER_COLORS[user.id % USER_COLORS.length]
  end
end
