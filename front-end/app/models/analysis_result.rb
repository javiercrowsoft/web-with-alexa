class AnalysisResult < ApplicationRecord
	self.table_name = "analysis_result"
  belongs_to :tweet
end
