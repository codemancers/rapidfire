Rapidfire::Engine.routes.draw do
  resources :question_groups, controller: Rapidfire.controllers[:question_groups] do
    get 'results', on: :member

    resources :questions, controller: Rapidfire.controllers[:questions]
    resources :answer_groups, only: [:new, :create], controller: Rapidfire.controllers[:answer_groups]
  end

  root to: "#{Rapidfire.controllers[:question_groups]}#index"
end
