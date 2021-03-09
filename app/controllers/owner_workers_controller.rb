class OwnerWorkersController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_owner_for_create, {only: [:create]}
  before_action :ensure_correct_user_for_destroy, {only: [:destroy]}

  def index
    # ログイン中のユーザーが管理者の場合従業員のリストを
    # ログイン中のユーザーが従業員の場合管理者のリストを表示する。
    if @current_user.class == Owner
      @workers = @current_user.workers.order(:userid)
      render("owner_workers/workers_index") and return
    elsif @current_user.class == Worker
      @owners = @current_user.owners.order(:userid)
      render("owner_workers/owners_index") and return
    end
  end

  def create
    # 取得したidに該当するリクエストを探す。
    @request = Request.find(params[:request_id])
    # 見つかれば
    if @request
      # 登録リクエスト通りにowner_workerを作成する。
      @owner_worker = OwnerWorker.new(owner_id: @request.owner_id,
                                      worker_id: @request.worker_id)
      # クラスメソッドalready_linked?（models\owner_worker.rb）
      # すでにowner_workersテーブルに同じ内容のレコードがある場合trueを返す。
      if OwnerWorker.already_linked?(@owner_worker)
        flash[:notice] = "既に登録済みです"
        render("requests/index")
      elsif @owner_worker.save
        flash[:notice] = "登録しました"
        # 同時にrequestsから削除する
        @request.destroy
        redirect_to("/requests")
      else
        render("requests/index")
      end
    else
      render("requests/index")
    end
  end

  def destroy
    @owner_worker = OwnerWorker.find(params[:id])
    @owner_worker.destroy
    flash[:notice] = "削除しました"
    redirect_to("/owner_workers")
  end

  private

  # owner_workerは管理者側、従業員側のどちらからでも削除することができるため、
  # 以下のように場合分けする。
  def ensure_correct_user_for_destroy
    @owner_worker = OwnerWorker.find(params[:id])
    if @current_user.class == Owner
      if @owner_worker.owner_id != @current_user.id
        flash[:notice] = "権限がありません"
        redirect_to("/")
      end
    elsif @current_user.class == Worker
      if @owner_worker.worker_id != @current_user.id
        flash[:notice] = "権限がありません"
        redirect_to("/")
      end
    end
  end

  def ensure_correct_owner_for_create
    @request = Request.find(params[:request_id])
    if !(@current_user.class == Owner && @request.owner_id == @current_user.id)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
