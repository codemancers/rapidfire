Rapidfire::Engine.routes.draw do
  resources :surveys do
    member do
      get 'results'
    end

    get 'results/:id', to: 'surveys#show_result', as: 'result'

    resources :questions
    resources :attempts, only: [:new, :create, :edit, :update, :show]
  end

  root :to => "surveys#index"
end
