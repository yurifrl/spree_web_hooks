Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :web_hooks do
      collection do
        get 'log/:id' => 'web_hooks#show_log', as: :log
      end
    end
  end
end