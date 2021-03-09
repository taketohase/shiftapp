class OwnersController < ApplicationController
  before_action :authenticate_user, {only: [:show, :edit, :update, :destroy]}
  before_action :forbid_login_user, {only: [:top, :new, :create, :login_form, :login]}
  before_action :ensure_correct_owner, {only: [:show, :edit, :update, :destroy]}

  def top
  end

  def show
    @owner = Owner.find(params[:id])
  end

  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(owner_params)
    if @owner.save
      # アカウント作成が成功したらそのままログイン状態にする。
      session[:user_id] = @owner.id
      session[:user_type] = "owner"

      # フラッシュメッセージを表示する。
      flash[:notice] = "アカウントを作成しました"

      # ユーザーページへリダイレクトする。
      redirect_to(@owner)
    else
      # 失敗すると再度登録フォームを表示する。
      render("owners/new")
    end
  end

  def edit
    @owner = Owner.find(params[:id])
    @edit_password_message = "パスワードを変更する方は以下に新しいパスワードを入力"
  end

  def update
    @owner = Owner.find(params[:id])

    if @owner.update(owner_params)
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to(@owner)
    else
      render("owners/edit")
    end
  end

  def login_form
  end

  def login
    # 従業員データの中から、ユーザーIDが一致するものを探す
    @owner = Owner.find_by(userid: params[:userid])

    if @owner && @owner.authenticate(params[:password])
      # ログイン状態にする
      session[:user_id] = @owner.id
      session[:user_type] = "owner"

      # フラッシュメッセージを表示する
      flash[:notice] = "ログインしました"

      # 募集中一覧へリダイレクトする
      redirect_to(tasks_path)
    else
      @error_message = "ユーザーIDまたはパスワードが間違っています"
      render("owners/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_type] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def destroy
    @owner = Owner.find(params[:id])
    @owner.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to("/")
  end

  private
  def owner_params
    params.require(:owner).permit(:name, :userid, :email, :password, :password_confirmation)
  end

  def ensure_correct_owner
    if !(@current_user.class == Owner && @current_user.id == params[:id].to_i)
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
