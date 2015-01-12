Rails.application.routes.draw do

  mount Rapidfire::Engine => "/rapidfire"

  get :foobar, to: 'application#index', as: :main_app_route
end
