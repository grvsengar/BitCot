class SuperAdminMailer < ApplicationMailer
  def new_post_notification(superadmin, post)
    @superadmin = superadmin
    @post = post
    mail(to: @superadmin.email, subject: 'New Post Notification')
  end
end
