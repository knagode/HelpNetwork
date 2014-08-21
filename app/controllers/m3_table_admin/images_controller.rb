class M3TableAdmin::ImagesController < M3TableAdmin::ApplicationController

  before_action :set_table

  private
    def set_table
      @table = M3TableAdmin::Table.new("images")
      @table.add_column "name", "text", {"index" => true}
      @table.add_column "attachment", "attachment", {"index" => false}

    end
end
