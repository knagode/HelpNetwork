class HelpRequest < ActiveRecord::Base
  has_many :help_request_rescuer
  belongs_to :user

  def find_and_create_nearest_rescuer
    nearest_user = User.all.first # TODO - who is nearest user?
    help_request_rescuer = HelpRequestRescuer.create(user: nearest_user, state: "waiting_for_response")
    help_request_rescuer.send_push_notification()
  end
end
