class M3TableAdmin::ProjectsController < M3TableAdmin::ApplicationController

  before_action :set_table

  private
    def set_table
      @table = M3TableAdmin::Table.new("projects")
      @table.add_column "name", "text", {"index" => true}
      @table.add_column "description", "wysihtml5", {"index" => false}
      @table.add_column "content", "wysihtml5", {"index" => false}

      @table.add_column "url", "text"
      @table.add_column "itunes_url", "text"
      @table.add_column "google_url", "text"

      @table.add_column "image", "attachment", {"index" => false}

      @table.add_column "status", "select", {:collection => ["published", "unpublished"]}

      @table.add_column "created_at", "datetime"

    end
end
