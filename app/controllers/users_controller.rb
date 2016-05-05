class UsersController < ApplicationController
    
    before_action :authenticate_user!, :except => [:show_user_profile, :followers, :following]  
     
    # return the current_user so that it can be stored and accessed on the front end of the application.
    def my_current_user 
        render json: current_user  
    end  
  
    # return randomly all the users in database except the users followed and own user.
    def random_users  
        @users = User.where.not(id: current_user.id) - current_user.all_following  
        render json: @users.sample(5)  
    end  
  
    # return the current_user based on the parameter :id sent with the request. 
    def show_current_user_profile  
        @user = User.find(params[:id])  
        render json: @user  
    end  
  
    # return the user data according to the :username parameter passed on by the request.
    def show_user_profile  
        @user = User.find_by(username: params[:username])  
        render json: @user  
    end 
  
    # Following users method.
    def follow  
        user = User.find(params[:user_id])  
        @follow = current_user.follow(user)  
        render json: @follow  
    end
    
    # Unfollowing users method.
    def unfollow  
        user = User.find(params[:user_id])  
        @unfollow = current_user.stop_following(user)  
        render json: @unfollow  
    end 
  
    # Get the followers count method.
    def followers  
        @users = User.find(params[:id]).followers  
        render json: @users  
    end
  
    # Get the following count method.
    def following  
        @users = User.find(params[:id]).all_following  
        render json: @users  
    end
  
    # Check if a given user is followed by the current user.  
    def is_following  
        @user = User.find(params[:user_id]).followed_by?(current_user)  
        render json: @user  
    end
  
    # Update the user through the settings on fron end of application.
    def update_user  
        @user = User.find(params[:id])  
        if @user.update(user_params)  
            head :no_content  
        else  
            render json: @user.errors, status: :unprocessable_entity  
        end  
    end
    
    # Return all the posts from all users followed and own posts. 
    def followed_users_posts
	    users = self.all_following
		my_posts = Array.new
		users.each do |u|
		    u.posts.each do |p|
                my_posts.push(p)
            end
	    end
        self.posts.each do |p|
            my_posts.push(p)
        end
		return my_posts
    end


    private  
  
    def user_params  
        params.require(:user).permit(:username, :avatar, :password)  
    end  
    
end