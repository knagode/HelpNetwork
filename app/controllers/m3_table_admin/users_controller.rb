class M3TableAdmin::UsersController < M3TableAdmin::ApplicationController

  def setup
    # set_table "users"
    # add_column "email", "text", index: true
    # add_column "role", "text", index: false
  end

  before_action :set_table

  private
    def set_table
      @table = M3TableAdmin::Table.new("users")
      @table.add_column("email", "text", {"index" => true})
      @table.add_column("role", "wysihtml5", {"index" => false})
    end
end
