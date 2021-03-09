class ApplicationController < ActionController::Base
  before_action :set_current_user

  # ログインしているユーザーを@current_userとして特定する
  def set_current_user
    if session[:user_type] == "worker"
      @current_user = Worker.find_by(id: session[:user_id])
    elsif session[:user_type] == "owner"
      @current_user = Owner.find_by(id: session[:user_id])
    end
  end

  # ログイン状態以外では実行させないアクションの前に呼び出す
  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/")
    end
  end

  # すでにログイン状態の場合、募集中一覧へリダイレクトする
  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to(tasks_path)
    end
  end

  # ログイン中のユーザーが従業員ユーザーであることを確認する。
  def permit_only_worker
    if @current_user.class != Worker
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end

  # ログイン中のユーザーが管理者ユーザーであることを確認する。
  def permit_only_owner
    if @current_user.class != Owner
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end

end
