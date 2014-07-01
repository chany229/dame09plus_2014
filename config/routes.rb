Dame09plus::Application.routes.draw do
	resources :entries do
		resources :comments
	end
	post 'accounts/upload_avatar' => 'accounts#upload_avatar', :as => 'upload_avatar'
	put 'accounts/avatar/crop' => 'accounts#crop_avatar', :as => 'crop_avatar'
	get 'accounts/avatar' => 'accounts#avatar', :as => 'user_avatar'
	get 'accounts/:username' => 'accounts#show', :as => 'user'

	post 'create_comment(.:format)' => 'home#create_comment', :as => :create_comment
	match 'remove_comment/:entry_id/:comment_id(.:format)' => 'home#remove_comment', :as => :remove_comment
	namespace :admin do
		resources :entries
		resources :users
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
	match 'mobile' => 'home#mobile', :as => :mobile
	authenticated :user do
		root :to => 'home#index'
	end
	root :to => "home#index"
	devise_for :users
end