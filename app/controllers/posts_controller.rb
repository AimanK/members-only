class PostsController < ApplicationController
    def index
        @posts = Post.all
    end

    def show
        @post = Post.find(params[:id])
    end

    def new
        @user = User.find(params[:user_id])
        @post = @user.posts.build
    end

    def create
        @user = User.find(params[:user_id])
        @post = @user.posts.build(post_params)
        if @post.save
          flash[:success] = "Post was successfully created."
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash') }
            format.html { redirect_to user_posts_path(@user) }
          end
        else
          flash.now[:error] = "Please ensure every field is filled out and valid."
          render :new, status: :unprocessable_entity
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        @post = Post.find(params[:id])
        if @post.update(post_params)
          flash[:success] = "Successfully updated post."
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash') }
            format.html { redirect_to @post }
          end
        else
          flash.now[:error] = "Error updating post, please ensure all fields are filled out."
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        flash[:success] = "Post was successfully deleted."
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash') }
          format.html { redirect_to posts_url }
        end
    end

    private 

    def post_params
        params.require(:post).permit(:title, :body, :username)
    end
end
