class HomeController < ApplicationController
  before_action :already_login

  def top
  end

  # すでにログインしている場合、topは募集中一覧へリダイレクトする。
  def already_login
    if @current_user
      redirect_to(tasks_path)
    end
  end
end
