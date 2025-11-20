# frozen_string_literal: true

class RetrospectiveChannel < ApplicationCable::Channel
  def subscribed
    retrospective = Retrospective.find(params[:id])
    stream_for retrospective
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
