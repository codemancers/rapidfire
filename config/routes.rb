Rapidfire::Engine.routes.draw do
  resources :question_groups do
    resources :questions
  end

  resources :answer_groups do
    resources :answers
  end

  root :to => "question_groups#index"
end
