class PresenceChannel < ApplicationCable::Channel
  # Class-level hash to track presence: { retrospective_id => Set[user_ids] }
  @@presence = {}
  @@mutex = Mutex.new

  def subscribed
    @retrospective = Retrospective.find(params[:retrospective_id])
    stream_for @retrospective

    # Track this user's presence
    add_user_to_presence
    broadcast_presence_update
  end

  def unsubscribed
    remove_user_from_presence
    broadcast_presence_update if @retrospective
  end

  private

  def add_user_to_presence
    @@mutex.synchronize do
      @@presence[@retrospective.id] ||= Set.new
      @@presence[@retrospective.id].add(current_user.id)
    end
  end

  def remove_user_from_presence
    @@mutex.synchronize do
      @@presence[@retrospective.id]&.delete(current_user.id)
      @@presence.delete(@retrospective.id) if @@presence[@retrospective.id]&.empty?
    end
  end

  def broadcast_presence_update
    present_user_ids = @@mutex.synchronize do
      (@@presence[@retrospective.id] || Set.new).to_a
    end

    present_users = User.where(id: present_user_ids).order(:username)

    PresenceChannel.broadcast_to(
      @retrospective,
      {
        action: "update_presence",
        html: ApplicationController.render(
          partial: "retrospectives/presence_avatars",
          locals: { users: present_users }
        )
      }
    )
  end
end
