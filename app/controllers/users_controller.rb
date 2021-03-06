class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @users = User.paginate(page: params[:page], per_page: 12)
  end

  def show
    @user = User.find(params[:id])
  end

  def my_friends
    @friendships = current_user.friends.paginate(page: params[:page], per_page: 12)
  end

  def search
    @users = User.search(params[:search_param])

    if @users
      @users = current_user.except_current_user(@users)
      render partial: "friends/lookup"
    else
      render status: :not_found, nothing: true
    end
  end

  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)

    if current_user.save
      redirect_to :back
    else
      redirect_to :back, flash[:error] = "There was an error with adding user as friend"
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
       redirect_to users_path, notice: "User deleted."
    end
  end
end
