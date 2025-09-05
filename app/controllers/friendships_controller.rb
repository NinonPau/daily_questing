class FriendshipsController < ApplicationController
before_action :authenticate_user!

  def index
    @friends = current_user.friends + current_user.inverse_friends
    # return all user you added as friend and have been accepted + return all  users who added you and you accepted
    @pending_requests_received = current_user.inverse_friendships.where(status: "pending")
    # bring all the frendships in db and filtered if pending or not
    @pending_requests_sent = current_user.friendships.where(status: "pending")
  end

  def create
    friend = User.find_by(username: params[:friend_username])
    if friend.nil?
      redirect_to friendships_path, alert: "User not found."
    return
    end

    if friend == current_user
      redirect_to friendships_path, alert: "You cannot friend yourself."
    return
    end
    @friendship = current_user.friendships.new(friend: friend, status: "pending")
    # all friendship initiated are build(not save) set the user that will receive the request
    # and put the staus as pending

    if @friendship.save
      redirect_to friendships_path, notice: "Invitation sent to #{friend.username}!"
    else
      redirect_to friendships_path, alert: "Could not send invitation."
    end
  end

  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.update(status: params[:status])
      redirect_to friendships_path, notice: "Friend request updated."
    else
      redirect_to friendships_path, alert: "Something went wrong."
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    redirect_to friendships_path
  end

end
