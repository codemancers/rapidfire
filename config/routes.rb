Rapidfire::Engine.routes.draw do
  resources :surveys do
    get 'results', on: :member

    resources :questions
    resources :answer_groups, only: [:new, :create]
  end

  root :to => "surveys#index"
end
