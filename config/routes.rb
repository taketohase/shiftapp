Rails.application.routes.draw do
  get "/" => "home#top"

  resources :tasks do
    resources :entries, only: [:new, :create, :edit, :update]
  end


  # workerに関するルーティング
  get "workers/top" => "workers#top"

  # ログインフォームとログイン処理
  get "workers/login" => "workers#login_form"
  post "workers/login" => "workers#login"

  # 従業員側から、シフトのやり取りをする管理者を検索し、紐づけできるように
  # するため、管理者検索フォームを実装する
  get "workers/search_owner" => "workers#search_owner"

  # ログアウトする。workerでもownerでも処理は同じであるため、
  # workersコントローラのアクションを使う
  post "logout" => "workers#logout"

  resources :workers, only: [:show, :new, :create, :edit, :update, :destroy]



  # ownerに関するルーティング
  get "owners/top" => "owners#top"

  # ログインフォームとログイン処理
  get "owners/login" => "owners#login_form"
  post "owners/login" => "owners#login"

  resources :owners, only: [:show, :new, :create, :edit, :update, :destroy]


  # owner_workersに関するルーティング
  get "owner_workers" => "owner_workers#index"
  post "owner_workers/create/:request_id" => "owner_workers#create"
  post "owner_workers/:id/destroy" => "owner_workers#destroy"


  # 従業員から管理者に対するユーザー紐づけリクエスト"request"
  # に関するルーティング
  get "requests" => "requests#index"
  post "requests/:owner_id" => "requests#create"
  post "requests/:id/destroy" => "requests#destroy"

end
