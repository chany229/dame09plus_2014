Dame09plus::Application.routes.draw do
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