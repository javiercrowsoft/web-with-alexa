class TaskCountry < ApplicationRecord
	self.table_name = "task_countries"
  belongs_to :task
	belongs_to :country
end
