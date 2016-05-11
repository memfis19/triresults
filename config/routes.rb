Rails.application.routes.draw do

  # resources :racers do
  #   post "entries" => "racers#create_entry"
  # end
  # resources :races


  resources :racers do
    post "entries" => "racers#create_entry"
  end
  resources :races

  namespace :api, defaults: {format: 'json'} do
    resources :racers do
      post "entries" => "racers#create_entry"
    end
    resources :races
  end

  get "/api/races/:race_id/results" => "api/races#index"
  get "/api/races/:race_id/results/:id" => "api/races#show"
  get "/api/racers/:racer_id/entries" => "api/racers#index"
  get "/api/racers/:racer_id/entries/:id" => "api/racers#show"

  post "/api/races" => "api/races#create"
  put "/api/races/:id" => "api/races#update"
end
