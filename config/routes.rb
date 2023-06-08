Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :message, only: [:create]

    end
  end
end
