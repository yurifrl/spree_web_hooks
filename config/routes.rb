Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :web_hooks do
      collection do
        get 'notification/:id' => 'web_hooks#show_notification', as: :notification
        get 'notification/:id/retry' => 'web_hooks#retry_notification', as: :retry_notification
        get 'log/:id' => 'web_hooks#show_log', as: :log
      end
    end
  end
end
