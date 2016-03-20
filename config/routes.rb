Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  post 'assignment' => 'assignments#show', as: :assignment_lti
  get 'assignment/:id' => 'assignments#show', as: :assignment
  post 'users/new' => 'users#new'

  get 'students/:id/to/grader' => 'students#to_grader', as: :student_to_grader
  get 'graders/:id/to/student' => 'graders#to_student', as: :grader_to_student

  get 'students/:id/assign/graders/:grader_id/' => 'students#assign_grader', as: :student_assign_grader
  get 'students/:id/unassign/grader' => 'students#unassign_grader', as: :student_unassign_grader

  post 'courses/:id/students/search' => 'courses#students_search', as: :students_search
  post 'courses/:id/graders/search' => 'courses#graders_search', as: :graders_search

  get 'submissions/assignments/:assignment_id/:status' => 'submissions#assignment', as: :assignment_submissions
  get 'submissions/:id/unsubmit' => 'submissions#unsubmit', as: :unsubmit_submission

  get 'students/courses/:course_id/:status' => 'students#course', as: :course_students
  get 'graders/courses/:course_id/:status' => 'graders#course', as: :course_graders

  resources :submissions
  resources :students
  resources :graders
  
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
