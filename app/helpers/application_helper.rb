module ApplicationHelper
  def fontello_icon(code)
    raw "<span class=\"ficon ficon-#{code}\"></span>"
  end
end
