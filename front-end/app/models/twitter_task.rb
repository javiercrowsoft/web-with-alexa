class TwitterTask < ApplicationRecord
	self.table_name = "twitter_task"
	belongs_to :task
end
