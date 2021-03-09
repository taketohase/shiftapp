class RequestsController < ApplicationController
  before_action :authenticate_user
  before_action :permit_only_worker, {only: [:create]}
  before_action :permit_only_owner, {only: [:index]}
  before_action :ensure_correct_owner_for_destroy, {only: [:destroy]}

  def index
    # ログイン中の管理者に対する従業員からの登録リクエストを取得する。
    @requests = @current_user.requests.order(created_at: :desc)
  end

  def create
    # owner_idに該当する管理者を探す。
    @owner = Owner.find(params[:owner_id])

    # 見つかれば
    if @owner
      @request = Request.new(owner_id: @owner.id, worker_id: @current_user.id)
      # クラスメソッドalready_linked?（models\owner_worker.rb）
      # すでにowner_workersテーブルに同じ内容のレコードがある場合trueを返す。
      if OwnerWorker.already_linked?(@request)
        @error_message = "既に登録済みです"
        render("workers/search_owner")
      # インスタンスメソッドalready_requested?（models\request.rb）
      # すでにrequestsテーブルに同じ内容のレコードがある場合trueを返す。
      elsif @request.already_requested?
        @error_message = "既にリクエストを送信済みです"
        render("workers/search_owner")
      elsif @request.save
        flash[:notice] = "リクエストを送信しました"
        redirect_to(worker_path(@current_user))
      else
        render("workers/search_owner")
      end
    else
      render("workers/search_owner")
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    flash[:notice] = "リクエストを削除しました"
    redirect_to("/requests")
  end

  private

  def ensure_correct_owner_for_destroy
    @request = Request.find(params[:id])
    if !(@current_user.class == Owner && @request.owner_id == @current_user.id)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
