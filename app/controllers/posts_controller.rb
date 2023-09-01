class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy, :archive]

  def index
    @our_posts = current_user.friends_and_own_posts
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(posts_params)
    if @post.save
      create_notification_for_superadmin
      send_email_notification_to_superadmin(@post)
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render 'new'
    end
  end

  def destroy
    return unless current_user.id == @post.user_id

    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_back(fallback_location: root_path)
  end

  def archive
    @post = Post.find(params[:id])

    if current_user.super_admin? || current_user == @post.user
      @post.update(archived: true)
      flash[:notice] = 'Post archived successfully.'
    else
      flash[:alert] = 'You do not have permission to archive this post.'
    end

    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def posts_params
    params.require(:post).permit(:content, :imageURL)
  end

  def create_notification_for_superadmin
    superadmin = User.with_role(:super_admin).first
    Notification.create(user: superadmin, content: "A new post was created.")
  end

  def send_email_notification_to_superadmin(post)
    superadmin = User.with_role(:super_admin).first
    SuperAdminMailer.new_post_notification(superadmin, post).deliver_now
  end
end
