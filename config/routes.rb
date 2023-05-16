Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show]
    end
  end
end