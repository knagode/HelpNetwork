class User < ActiveRecord::Base

  # belongs_to :owner
  # has_many :controller_users, :class => "User", :foreign_key => "owner_id"
  has_many :oauths
  has_many :authentication_tokens


  # all we need for the password is this and a value password digest inside the user model

  attr_accessor :require_password, :require_password_confirmation, :contract_accepted, :require_contract_acceptance, :driver_score

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  #validates :birthday, :name, :sex, presence: true
  has_secure_password
  validates :password, length: { minimum: 6 }, confirmation: { if: ->{ require_password_confirmation }}, if: ->{ require_password || require_password_confirmation }
  #validates :contract_accepted, acceptance: { if: ->{ require_contract_acceptance }}
  validates :password_reset_token, uniqueness: true, allow_nil: true
  validates :email_verification_token, uniqueness: true, allow_nil: true

  after_create :generate_email_verification_token

  scope :active, -> { where(deleted: false) }
  scope :authenticatable, ->{ where(enabled: true).active }
  scope :find_in_ids, -> user_ids { where("users.id in (?)", user_ids) }
  scope :m3_table_admin_autocomplete_scope, ->(q, user = nil) { where("email LIKE ?", "%#{q}%").select("email as value, id as id") }

  def m3_table_admin_autocomplete_label
    email #+ " (id = #{id})"
  end

  def create_default_mode
    UserMode.create(:user => self, :user_mode_type => UserModeType.find_by_type_nice_id("business"))
  end

  def my_score
    if self.driver_score
      self.driver_score
    else
      0
    end
  end

  #oauth - Facebook and Google for now zone
  # Creates new user from OmniAuth response.
  def self.create_from_omniauth(auth, user_params)
    user = nil
    transaction do
      if user_params[:sex] == "female"
        user_params[:sex] = 1
      else
        user_params[:sex] = 0
      end

      if (user_params[:birthday]) && !(user_params[:birthday].blank?)
        user_params[:birthday]         = user_params['birthday']
      else
        user_params[:birthday]         = "1-1-1980"
      end

      user_params[:name] = "#{user_params[:firstname]} #{user_params[:lastname]}"
      user_params[:password] = SecureRandom.urlsafe_base64
      user_params[:password_confirmation] = user_params['password']
      puts user_params.to_yaml
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

  #return the current (last selected) mode that the user returned
  def current_mode
    self.user_modes.last.nice_id
  end

  def create_auth_token
    if self.id.blank?
      return nil
    end

    token = SecureRandom.urlsafe_base64
    # token = loop do
    #   random_token = SecureRandom.urlsafe_base64
    #   random_token = "#{random_token}"
    #   break random_token unless AuthenticationToken.exists?(token: random_token)
    # end

    AuthenticationToken.create(:user => self, :token => token)

    return {user_id: self.id, token: token}
  end

  #########################
  #authentication stuff#
  #########################



  # Checks if a user can be authenticated.
  def authenticatable?
    self.enabled && self.active?
  end

  def active?
    !deleted?
  end

  ######################
  #password reset stuff#
  ######################
  def send_password_reset locale
    generate_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    if !Rails.env.test?
      UserMailer.password_reset(self, locale)
    end
  end

  # Generates uniq password reset token.
  def generate_password_reset_token
    self.password_reset_token = "#{self.id}#{SecureRandom.hex(10)}"
  end

  # Tells if password reset token is still valid.
  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  ##########################
  #email verification stuff#
  ##########################

  # Sends email verification email.
  def send_email_verification locale
    generate_email_verification_token
    self.email_verification_sent_at = Time.zone.now
    save!

    if !Rails.env.test?
      UserMailer.email_verification(self, locale)
    end
  end

  # Generates uniq email verification token.
  def generate_email_verification_token
    self.email_verification_token = "#{self.id}#{SecureRandom.hex(10)}"
  end

  # Tells if email verification token is still valid.
  def email_verification_expired?
    email_verification_sent_at < 2.hours.ago
  end

  # Marks email as verified.
  def verify_email!
    self.email_verified = true
    self.email_verified_at = Time.zone.now
    save!
  end

  def email_verified?
    self.email_verified
  end

  ########################
  #fleet acception stuff#
  ########################

  def send_email_fleet_accept(locale, new_user = false, fleet_relationship)
    generate_relationship_request_token(fleet_relationship)

    if !Rails.env.test?
      UserMailer.email_fleet_relationship_accept(self, locale, new_user, fleet_relationship)
    end
  end

  # Generates uniq email verification token.
  def generate_relationship_request_token(fleet_relationship)
    fleet_relationship.request_token = "#{fleet_relationship.id}#{SecureRandom.hex(10)}"
    fleet_relationship.save!
  end

  #########################
  #push notification stuff#
  #########################

  def send_push_notification message

    if token = self.mobile_devices.last.push_notification_token
      require 'houston'

      #certificate = File.read(Rails.root + "public/ulu_push_certificate.pem")
      certificate = File.read(Rails.root + "public/ulu_push.pem")
      passphrase = "Topniska45"
      # connection = Houston::Connection.new(Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, passphrase)
      connection = Houston::Connection.new(Houston::APPLE_PRODUCTION_GATEWAY_URI, certificate, passphrase)
      connection.open

      #for Rok
      #token = "<18977c38 e3e26c65 c2609501 9d2b48f4 6072a3a5 ded28c1b dbd5063e 7f1f388b>"
      #for Marko
      #token = "<b41d3a77 af0b7726 8c25dc44 a3c4586a bde8615a 08a82f6c 81c1af06 4b9964b8>"
      notification = Houston::Notification.new(device: token)
      notification.alert = message
      connection.write(notification.message)
      puts "Push notification sent!"
      connection.close
    else
      puts "Token for user #{self.email} is null. Cant send push notification."
    end

  end

  #########################
  #authorization stuff#
  #########################

  def admin?
    admin_role = self.user_roles.find_by_role("admin")
    if admin_role
      return true
    end
    return false
  end

end
