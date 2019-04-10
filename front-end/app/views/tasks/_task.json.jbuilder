json.extract! task, :id, :code, :name, :created_at, :updated_at
json.url task_url(task, format: :json)
