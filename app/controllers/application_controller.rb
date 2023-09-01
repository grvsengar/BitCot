class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Your permitted parameters configuration
  end

  def after_sign_in_path_for(resource)
    if resource.has_role?(:super_admin)
      # Debugging: Output a message to the console to confirm if the user is a super admin
      Rails.logger.debug "Super Admin Logged In"
      rails_admin_path
    else
      # Debugging: Output a message to the console to confirm if a regular user is logged in
      Rails.logger.debug "Regular User Logged In"
      root_path
    end
  end
end
