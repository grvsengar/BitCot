class User < ApplicationRecord
  rolify
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friend_sent, class_name: 'Friendship', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :friend_request, class_name: 'Friendship', foreign_key: 'sent_to_id',
                            inverse_of: 'sent_to', dependent: :destroy
  has_many :friends, -> { merge(Friendship.friends) }, through: :friend_sent, source: :sent_to
  has_many :pending_requests, -> { merge(Friendship.not_friends) }, through: :friend_sent, source: :sent_to
  has_many :recieved_requests, -> { merge(Friendship.not_friends) }, through: :friend_request, source: :sent_by
  has_many :notifications, dependent: :destroy
  mount_uploader :image, PictureUploader
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :lockable,
  :omniauthable, omniauth_providers: [:google_oauth2]
  validates :fname, length: { in: 3..15 }, presence: true
  validates :lname, length: { in: 3..15 }, presence: true
  validate :picture_size

  def activities
    (posts + comments + likes + notifications).sort_by(&:created_at).reverse
  end

  def full_name
    "#{fname} #{lname}"
  end

  def friends_and_own_posts
    our_posts = []

    myfriends = friends
    myfriends.each do |f|
      our_posts.concat(f.posts.where(archived: [false, nil]))
    end

    our_posts.concat(posts.where(user: self, archived: [false, nil]))

    our_posts
  end



  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    if user.persisted?
      user
    else
      existing_user = find_by(email: auth.info.email)

      if existing_user
        existing_user.update(provider: auth.provider, uid: auth.uid)
        existing_user
      else
        new_user = new(
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          full_name: auth.info.name,
          avatar_url: auth.info.image,
          provider: auth.provider,
          uid: auth.uid
        )
        new_user.save(validate: false)
      end
    end
  end








  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.google_oauth2_data'] && session['devise.google_oauth2_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
      end
    end
  end


  def super_admin?
    has_role?(:super_admin)
  end

  private

  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
