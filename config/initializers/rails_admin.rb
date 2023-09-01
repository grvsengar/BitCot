RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
    unless current_user&.has_role?(:super_admin)
      flash[:alert] = 'You do not have permission to access this page.'
      redirect_to main_app.root_path
    end
  end
  config.current_user_method(&:current_user)



  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show

    ## Custom Actions
    collection :posts_created_chart do
      only [Post]
      controller 'admin/analytics'
    end

    collection :users_created_chart do
      only [User]
      controller 'admin/analytics'
    end

    collection :most_active_user_chart do
      only [User]
      controller 'admin/analytics'
    end
  end
end
