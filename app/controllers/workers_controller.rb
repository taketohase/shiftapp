class WorkersController < ApplicationController
  before_action :authenticate_user, {only: [:show, :edit, :update, :destroy]}
  before_action :forbid_login_user, {only: [:top, :new, :create, :login_form, :login]}
  before_action :ensure_correct_worker, {only: [:show, :edit, :update, :destroy]}

  def top
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      # アカウント作成が成功したらそのままログイン状態にする。
      session[:user_id] = @worker.id
      session[:user_type] = "worker"

      # フラッシュメッセージを表示する。
      flash[:notice] = "アカウントを作成しました"

      # ユーザーページへリダイレクトする。
      redirect_to(@worker)
    else
      # 失敗すると再度登録フォームを表示する。
      render("workers/new")
    end
  end

  def edit
    @worker = Worker.find(params[:id])
    @edit_password_message = "パスワードを変更する方は以下に新しいパスワードを入力"
  end

  def update
    @worker = Worker.find(params[:id])

    if @worker.update(worker_params)
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to(@worker)
    else
      render("workers/edit")
    end
  end

  def login_form
  end

  def login
    # 従業員データの中から、ユーザーIDが一致するものを探す。
    @worker = Worker.find_by(userid: params[:userid])

    if @worker && @worker.authenticate(params[:password])
      # ログイン状態にする。
      session[:user_id] = @worker.id
      session[:user_type] = "worker"

      # フラッシュメッセージを表示する。
      flash[:notice] = "ログインしました"

      # ユーザーページへリダイレクトする。
      redirect_to(tasks_path)
    else
      @error_message = "ユーザーIDまたはパスワードが間違っています"
      render("workers/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_type] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def search_owner
    @owner = Owner.find_by(userid: params[:userid])
  end

  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to("/")
  end

  private
  def worker_params
    params.require(:worker).permit(:name, :userid, :email, :password, :password_confirmation)
  end

  def ensure_correct_worker
    if !(@current_user.class == Worker && @current_user.id == params[:id].to_i)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
