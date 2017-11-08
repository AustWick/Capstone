Rails.application.routes.draw do
  get '/' => 'documents#index'
  get '/documents' => 'documents#index'
  get "/documents/new" => "documents#new"
  post "/documents" => "documents#create"

  get '/documents/:id' => 'documents#show'

  delete '/documents/:id' => 'documents#destroy'


  get '/elements/:id' => 'elements#show'
end
