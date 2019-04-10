class Task < ApplicationRecord
	self.table_name = "task"
	belongs_to :task_status
	has_one :twitter_task
	has_one :facebook_task
	has_many :task_country
	has_many :task_tweet

	attr_accessor :positive
	attr_accessor :neutral
	attr_accessor :negative

	POSITIVE = 1
	NEGATIVE = 2
	NEUTRAL = 3

	ASSOCIATE_TWEETS = "select link_task_with_tweets"
  SENTIMENT_COUNT = "select count(*)" +
										" from task" +
										" inner join task_tweet on task.id = task_tweet.task_id" +
										" inner join analysis_result r on task_tweet.tweet_id = r.id" +
										" where r.sentiment = "

  LAST_ANALYSIS_RESULT = "select distinct 'tweet' as type, tweet.body as text, r.sentiment, tweet.created_at" +
													" from task" +
													" inner join task_tweet on task.id = task_tweet.task_id" +
													" inner join tweet on task_tweet.tweet_id = tweet.id" +
													" inner join analysis_result r on task_tweet.tweet_id = r.id" +
													" where task.id ="


	def country_ids
		task_country.map do |tc|
			country = Country.find(tc.country_id)
			[country.name, country.id]
		end
	end

  def load_sentiment
		ActiveRecord::Base.connection.execute(ASSOCIATE_TWEETS + "(#{self.id})")
		self.positive = count_sentiment_of_type(POSITIVE)
		self.neutral = count_sentiment_of_type(NEUTRAL)
		self.negative = count_sentiment_of_type(NEGATIVE)
	end

	def load_last_analysis_result(limit)
		ActiveRecord::Base.connection.execute(LAST_ANALYSIS_RESULT + self.id.to_s + " order by tweet.created_at desc limit "+ limit.to_s)
	end

	def count_sentiment_of_type(type)
		ActiveRecord::Base.connection.execute(SENTIMENT_COUNT + type.to_s + " AND task.id = " + self.id.to_s)[0]['count']
	end

end
