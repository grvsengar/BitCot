class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_super_admin_role

  def posts_created_chart
    @posts_data = Post.group_by_day(:created_at).count
  end

  def users_created_chart
    @users_data = User.group_by_day(:created_at).count
  end

  private

  def require_super_admin_role
    unless current_user.has_role?(:super_admin)
      redirect_to root_path, alert: "You do not have permission to access this page."
    end
  end
end
