Dame09plus::Application.routes.draw do
	post 'create_comment(.:format)' => 'home#create_comment', :as => :create_comment
	namespace :admin do
		resources :entries
	end
	match 'logs/tag/:tag_name(/p:page)(.:format)' => 'home#tag', :as => :tag
	match 'logs/tags/:type/:tags(/p:page)(.:format)' => 'home#tags', :as => :tags
	match 'logs/keyword/:keyword(.:format)' => 'home#keyword', :as => :keyword
	match 'logs/calendar/:date(.:format)' => 'home#calendar', :as => :calendar
	match 'logs/date/:year(/p:page)(.:format)' => 'home#date',:as => :year
	match 'logs/date/:year/:month(/p:page)(.:format)' => 'home#date',:as => :month
	match 'logs/date/:year/:month/:day(/p:page)(.:format)' => 'home#date',:as => :day
	match 'logs(.:format)' => 'home#logs', :as => :logs
	match 'top(.:format)' => 'home#top', :as => :top
	match 'frame(/:type)' => 'home#frame', :as => :frame
	authenticated :user do
		root :to => 'home#index'
	end
	root :to => "home#index"
	devise_for :users
	resources :users
end