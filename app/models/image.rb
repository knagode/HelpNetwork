require 'uri'

class Image < ActiveRecord::Base
  has_attached_file :attachment,
                    styles: {:thumb => "100x100#"}
                    #styles: Proc.new { |attachment| attachment.instance.styles }

  #validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment :attachment, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  def dynamic_style_format_symbol
    URI.escape(@dynamic_style_format).to_sym
  end

  def styles
    unless @dynamic_style_format.blank?
      { dynamic_style_format_symbol => @dynamic_style_format }
    else
      {}
    end
  end

  def dynamic_attachment_url(format)
    @dynamic_style_format = format
    attachment.reprocess!(dynamic_style_format_symbol) unless attachment.exists?(dynamic_style_format_symbol)
    attachment.url(dynamic_style_format_symbol)
  end

end
