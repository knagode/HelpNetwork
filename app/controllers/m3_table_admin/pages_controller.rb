class M3TableAdmin::PagesController < M3TableAdmin::ApplicationController

  before_action :set_table

  private
    def set_table
      @table = M3TableAdmin::Table.new("pages")

      @table.add_column "slug", "text", {"index" => false}

      @table.add_column "title", "text", {"index" => true}
      @table.add_column "content", "wysihtml5", {"index" => false}


      @table.add_column "status", "select", {:collection => ["published", "unpublished", "archived"]}

      @table.add_column "visible_in_menu", "checkbox"

      @table.add_filters "status", ["published", "unpublished", "archived", "all"]

    end
end
