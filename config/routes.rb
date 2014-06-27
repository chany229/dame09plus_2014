Dame09plus::Application.routes.draw do
	resources :entries do
		resources :comments
	end
	post 'user/upload_avatar' => 'users#upload_avatar', :as => 'upload_avatar'
	put 'user/avatar/crop' => 'users#crop_avatar', :as => 'crop_avatar'
	get 'user/avatar' => 'users#avatar', :as => 'user_avatar'
	get 'user/:username' => 'users#show', :as => 'user'

	post 'create_comment(.:format)' => 'home#create_comment', :as => :create_comment
	match 'remove_comment/:entry_id/:comment_id(.:format)' => 'home#remove_comment', :as => :remove_comment
	namespace :admin do
		resources :entries
		resources :accounts
	end
	match 'logs/tag/:tag_name(/p:page)(.:format)' => 'home#tag', :as => :tag
	match 'logs/tags/:type/:tags(/p:page)(.:format)' => 'home#tags', :as => :tags
	match 'logs/keyword(/:keyword)(/p:page)(.:format)' => 'home#keyword', :as => :keyword
	match 'logs/calendar/:date(.:format)' => 'home#calendar', :as => :calendar
	match 'logs/date/:year(/p:page)(.:format)' => 'home#date',:as => :year
	match 'logs/date/:year/:month(/p:page)(.:format)' => 'home#date',:as => :month
	match 'logs/date/:year/:month/:day(/p:page)(.:format)' => 'home#date',:as => :day
	match 'logs(/p:page)(.:format)' => 'home#logs', :as => :logs
	match 'top(.:format)' => 'home#top', :as => :top
	match 'profile(.:format)' => 'home#profile', :as => :profile
	match 'links(.:format)' => 'home#links', :as => :links
	match 'frame(/:type)' => 'home#frame', :as => :frame
	authenticated :user do
		root :to => 'home#index'
	end
	root :to => "home#index"
	devise_for :users
	resources :users
end