class EntriesController < ApplicationController
  before_action :authenticate_user
  before_action :permit_only_worker
  before_action :ensure_correct_worker, {only: [:edit, :update]}

  def new
    @task = Task.find(params[:task_id])
    @days = @task.get_days
    # 複数レコードを一括保存するためのコレクションモデルEntryCollectionを作成・使用する。
    @form = Form::EntryCollection.new({}, @days.length)
  end

  def create
    @task = Task.find(params[:task_id])
    @days = @task.get_days
    @form = Form::EntryCollection.new(entry_collection_params, @days.length)

    # インスタンスメソッド"save"(models\form\entry_collection.rb)
    # 複数レコードの一括保存を行う。一つでも失敗するとfalseが返ってくる
    if @form.save(@current_user.id, @task.id, @days)
      redirect_to(task_path(@task))
    else
      @error_message = "登録に失敗しました。（内容の変更は希望表のリンクから行うことができます）"
      render("entries/new")
    end
  end

  def edit
    @task = Task.find(params[:task_id])
    @entry = Entry.find(params[:id])
  end

  def update
    @task = Task.find(params[:task_id])
    @entry = Entry.find(params[:id])
    if @entry.update(entry_params)
      flash[:notice] = "編集しました"
      redirect_to(@task)
    else
      render("entries/edit")
    end
  end

  private

  def entry_collection_params
      params
          .require(:form_entry_collection)
          .permit(entries_attributes: [:attendance, :from_time_h, :from_time_m, :to_time_h, :to_time_m])
  end

  def entry_params
    params.require(:entry).permit(:attendance, :from_time_h, :from_time_m, :to_time_h, :to_time_m)
  end

  # ログイン中のユーザーが従業員ユーザーで、かつ対象のentryがこのユーザーの物である
  # ことを確認する。before_actionで使用する。
  def ensure_correct_worker
    @entry = Entry.find(params[:id])
    if !(@current_user.class == Worker && @entry.worker_id == @current_user.id)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
