class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :permit_only_owner, {only: [:new, :create]}
  before_action :ensure_correct_owner, {only: [:edit, :update, :destroy]}


  def index
    # 管理者ユーザーの場合、自らのtasksを表示する。
    if @current_user.class == Owner
      @tasks = @current_user.tasks.order(:deadline)

    # 従業員ユーザーの場合、関係を持つ管理者のtasksを表示する。
    elsif @current_user.class == Worker
      @owners = @current_user.owners
      @tasks = []
      @owners.each do |owner|
        owner.tasks.order(:deadline).each do |task|
          @tasks.push(task)
        end
      end
    end
  end

  def show
    @task = Task.find(params[:id])
    @owner = Owner.find(@task.owner_id)
    @workers = @owner.workers.order(:userid)
    # インスタンスメソッド"get_days"(models\task.rb)
    # taskには、何日から何日までの希望が欲しいかの情報が含まれる。その期間の日付を配列で渡す。
    @days = @task.get_days
    @entries_table = {}

    # このtaskに属するentryが存在する場合
    if @task.entries.empty? == false
      # インスタンスメソッド"get_entries_table"(models\task.rb)
      # キーに従業員の名前、バリューに日数分の出勤可能時間の配列を持ったハッシュを取得する。
      @entries_table = @task.get_entries_table
    end

    # 指定されたフォーマットによって処理を変える。
    respond_to do |format|
      # htmlなら、通常通りテンプレートを表示する。
      format.html
      # xlsxなら、ファイルをダウンロードさせる。
      # Content-Dispositionで、ウェブページ（又はその一部）として表示するか、ダウンロードファイル
      # とするか選べる。attachmentを指定したので、ダウンロードファイルとなる。
      # ファイル名は"今日の日付.xlsx"。
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{Date.today}.xlsx"
      end
    end
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.owner_id = @current_user.id

    # インスタンスメソッド"task_setting_errors"(models\task.rb)
    # 設定が不適切だと、そのメッセージが配列になって返ってくる。
    if @error_messages = @task.task_setting_errors
      render("tasks/new")
    elsif @task.save
      flash[:notice] = "投稿しました"
      redirect_to(tasks_path)
    else
      render("tasks/new")
    end

  end

  def update
    @task = Task.find(params[:id])

    # 編集はコメントに対してしか受け付けない。
    if @task.update(edit_task_params)
      flash[:notice] = "編集しました"
      redirect_to(@task)
    else
      render("tasks/edit")
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to(tasks_path)
  end

  def task_params
    params.require(:task).permit(:title, :from_date, :to_date, :deadline, :comment)
  end

  def edit_task_params
    params.require(:task).permit(:comment)
  end

  private

  def ensure_correct_owner
    @task = Task.find(params[:id])
    if !(@current_user.class == Owner && @task.owner_id == @current_user.id)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
