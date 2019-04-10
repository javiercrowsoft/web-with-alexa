class Tweet < ApplicationRecord
	self.table_name = "tweet"
	has_many :task_tweet
	has_one :analysis_result
end
