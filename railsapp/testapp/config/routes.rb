Rails.application.routes.draw do

	resources :subjects do
		member do
			get :delete
		end
	end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#get 'display/index'
#get ':controller(/:action(/:id))'
end
