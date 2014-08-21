class Page < ActiveRecord::Base
  belongs_to :user

  before_save do
    self.slug = self.title.parameterize
  end
end
