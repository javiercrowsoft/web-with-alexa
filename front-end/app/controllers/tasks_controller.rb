class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task.load_sentiment
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save

        save_facebook
        save_twitter
        save_countries

        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_facebook
    @task.facebook_task ||= FacebookTask.new
    @task.facebook_task.page = params[:task][:page]
    @task.facebook_task.topic = params[:task][:topic]
    @task.facebook_task.save
  end

  def save_twitter
    @task.twitter_task ||= TwitterTask.new
    @task.twitter_task.hashtag = params[:task][:hashtag]
    @task.twitter_task.keyword = params[:task][:keyword]
    @task.twitter_task.save
  end

  def save_countries
    country_list = params[:country][:country_ids].select{|id| ! id.blank?}.map(&:to_i)
    TaskCountry.where("task_id = #{@task.id} AND country_id NOT IN (#{country_list.join(',')})").destroy_all if country_list.any?
    contry_list_to_add = country_list - @task.task_country.all.map(&:country_id)
    contry_list_to_add.each do |id|
      tc = TaskCountry.new
      tc.task_id = @task.id
      tc.country_id = id
      tc.save
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)

        save_facebook
        save_twitter
        save_countries

        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params
      .require(:task)
      .permit(:code, :name, :task_status_id, :start_date, :end_date, :hashtag, :keyword, :page, :topic)
      .except(:hashtag, :keyword, :page, :topic)
    end
end
