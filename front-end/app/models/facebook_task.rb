class FacebookTask < ApplicationRecord
	self.table_name = "facebook_task"
	belongs_to :task
end
