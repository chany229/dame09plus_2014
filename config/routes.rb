Dame09plus::Application.routes.draw do
	namespace :admin do
		resources :entries
	end
	match 'logs/tag/:tag_name(.:format)' => 'home#tag', :as => :tag
	match 'logs/keyword/:keyword(.:format)' => 'home#keyword', :as => :keyword  
	match 'logs/date/:year(/p:page)(.:format)' => 'home#date',:as => :year
	match 'logs/date/:year/:month(/p:page)(.:format)' => 'home#date',:as => :month
	match 'logs/date/:year/:month/:day(/p:page)(.:format)' => 'home#date',:as => :day
	match 'logs/calendar/:date(.:format)' => 'home#calendar', :as => :calendar
	match 'logs(.:format)' => 'home#logs', :as => :logs
	match 'top(.:format)' => 'home#top', :as => :top
	match 'frame(.:format)' => 'home#frame', :as => :frame
	authenticated :user do
		root :to => 'home#index'
	end
	root :to => "home#index"
	devise_for :users
	resources :users
end