class User < ActiveRecord::Base

  scope :m3_table_admin_autocomplete_scope, ->(q, user = nil) { where("email LIKE ?", "%#{q}%") }

  def m3_table_admin_autocomplete_label
    email + " (id = #{id})"
  end

  def to_label
    m3_table_admin_autocomplete_label
  end

end
