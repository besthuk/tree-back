Rails.application.routes.draw do
  resources :group_messages
  resources :group_user_requests
  resources :group_users
  resources :groups
  resources :relationships
  resources :relationship_types
  resources :personal_infos
  resources :works
  resources :studies
  resources :users
  namespace "api" do
    namespace "v1" do
      post 'login'
      post 'challenge_required'
      post 'register'
      post 'upload_photo'
      resources :user do
        get 'user', on: :member
        get 'get_parents', on: :member
        get 'get_childrens', on: :member
        get 'change_login', on: :member
        get 'challenge_login', on: :member
        get 'profile', to: 'user#show'
        collection do
          get 'search'
          post 'add_request'
          post 'answer_request'
          get 'get_inbox_request'
          get 'get_outbox_request'
          get 'get_groups'
        end
      end
      resource :groups do
        collection do
          get 'get_group_inbox_request'
          get 'get_group_outbox_request'
        end
        get ':id', to: 'groups#show'
        get ':id/delete_user', to: 'groups#delete_user'
        get ':id/delete', to: 'groups#delete'
        get ':id/get_inbox_request', to: 'groups#get_inbox_request'
        get ':id/get_outbox_request', to: 'groups#get_outbox_request'
        get ':id/answer_request', to: 'groups#answer_request'
        get ':id/join', to: 'groups#join'
        get ':id/invite', to: 'groups#invite'
        resource :messages do
          collection do
            get 'create'
          end
          get ':id/edit', to: 'messages#edit'
          get ':id/delete', to: 'messages#delete'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
