class Api::V1::TasksController < Api::V1::BaseController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = Task.all
    ActionCable.server.broadcast 'events', event: 'list_tasks'
    render json: {status: 'SUCCESS', message: 'Load tasks', data: tasks}, status: :ok
  end

  def show
    ActionCable.server.broadcast 'events', event: 'show_task', id:@task.id
    render json: {status: 'SUCCESS', message: 'Load task', data: @task}, status: :ok
  end

  def create
    task = Task.new(task_params)

    if task.save
      ActionCable.server.broadcast 'events', event: 'task_created'
      render json: { status: :created, message: 'Create task', data: task }, status: :ok
    else
      render json: { status: :unprocessable_entity, data: task.errors }, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      render json: { status: :ok, message: 'Update task', data: @task }, status: :ok
    else
      render json: { status: :unprocessable_entity, data: @task.errors }, status: :unprocessable_entity 
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    render json: {}, status: :no_content
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      id_param = params[:id]
      if id_param.start_with? "code"
        puts id_param[4..-1]
        @task = Task.find_by(code: id_param[4..-1])
      else
        @task = Task.find(id_param)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:code, :name)
    end

end
