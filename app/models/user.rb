class User < ActiveRecord::Base
  has_many :oauths

  attr_accessor :require_password, :require_password_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, confirmation: { if: ->{ require_password_confirmation }}, if: ->{ require_password || require_password_confirmation }
  has_secure_password

  scope :active, -> { where(deleted: false) }
  scope :authenticatable, ->{ where(enabled: true).active }
  scope :m3_table_admin_autocomplete_scope, ->(q, user = nil) { where("email LIKE ?", "%#{q}%") }

  def m3_table_admin_autocomplete_label
    email + " (id = #{id})"
  end

  def to_label
    m3_table_admin_autocomplete_label
  end

  ######################
  #authentication stuff#
  ######################

  # Checks if a user can be authenticated.
  def authenticatable?
    self.enabled && self.active?
  end

  def active?
    !deleted?
  end

  ##################################
  #oauth - Facebook and Googlestuff#
  #################################

  # Creates new user from OmniAuth response.
  def self.create_from_omniauth(auth, user_params)
    user = nil
    transaction do
      user_params[:password] = SecureRandom.urlsafe_base64
      user_params[:password_confirmation] = user_params['password']
      user = User.create(user_params)

      Oauth.find_or_create_by(:provider => auth[:provider], :uid => auth[:uid], :user => user) if user.new_record?
    end
    user
  end

  # Tries to retrive a user based on omniouth hash.
  def self.find_by_omniauth(auth)
    Oauth.find_by_provider_and_uid(auth["provider"], auth["uid"]).try(:user)
  end

  # Tells if a user has connected with a authentication strategy or not.
  def strategy?(strategy)
    oauths.find{|oa| oa.provider == strategy }.present?
  end
end
