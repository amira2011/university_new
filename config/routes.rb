Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'articles#index'

  resources :pages
  resources :courses
  resources :students 
  resources :articles do
    resources :comments
  end
  get 'github', to: 'pages#github'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get 'login', to: 'logins#new'
  post 'login', to: 'logins#create'
  delete 'logout', to: 'logins#destroy'

  post 'course_enroll', to: 'student_courses#create'
  get 'enrolled', to: 'student_courses#enrolled'
end
