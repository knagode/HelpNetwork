class ImagesController < ApplicationController
  def thumbnail
    @image = Image.find(params[:id])
    redirect_to @image.dynamic_attachment_url("#{params['width']}x#{params['height']}>")
  end

end
