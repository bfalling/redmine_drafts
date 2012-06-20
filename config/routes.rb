RedmineApp::Application.routes.draw do
  resources :drafts, :only => [:create, :destroy] do
    put 'restore', :on => :member
    post 'autosave', :on => :collection
  end
end
