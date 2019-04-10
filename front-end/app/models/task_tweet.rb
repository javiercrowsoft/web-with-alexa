class TaskTweet < ApplicationRecord
	self.table_name = "task_tweet"
	belongs_to :task
	belongs_to :tweet
end
