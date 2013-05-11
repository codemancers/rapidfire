Rapidfire::Engine.routes.draw do
  resources :question_groups do
    resources :questions
    resources :answer_groups, only: [:new, :create]
  end

  root :to => "question_groups#index"
end
