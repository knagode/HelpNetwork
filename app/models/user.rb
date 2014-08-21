class User < ActiveRecord::Base
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

end
