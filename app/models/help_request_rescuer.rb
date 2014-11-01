class HelpRequestRescuer < ActiveRecord::Base
  belongs_to :user
  belongs_to :help_request

  def send_push_notification
    # TODO: implement this ...
    #send_push_notification "Help please!!!"
  end
end
