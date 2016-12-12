Rails.application.routes.draw do

  root 'parse#index'
  get 'dashboard' => 'parse#dashboard'
  get 'api_doc' => 'parse#api_doc'
  get 'error'=>'parse#error'
  get 'get_graph'=>'parse#get_graph'

  resources :users do 
    get 'sign_up',on: :collection
    get 'sign_in',on: :collection
    get 'sign_out',on: :collection
    post 'create_sign_up',on: :collection
    post 'create_sign_in',on: :collection
    get 'coin_rank',on: :collection
  end
  resources :coins do
    post 'coin_update',on: :member,as: :coin_update
  end
  resources :challanges do 
    post 'trigger_create',on: :collection,as: :trigger_create
    put 'trigger_update',on: :member,as: :trigger_update
    get 'get_coin_type',on: :collection
  end
  resources :tags do
    post 'create_tag',on: :collection,as: :create_tag
    put 'update_tag',on: :member,as: :update_tag
  end
  resources :histories do
    get 'history_coin_tag_rank',on: :collection
    put 'update_history',on: :member,as: :update_history
  end
end
