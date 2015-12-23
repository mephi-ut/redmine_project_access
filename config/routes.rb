if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    post "project_access/update" => 'project_access#update'
    get "project_access/autocomplete_for_users" => 'project_access#autocomplete_for_users', :via => :get, :as => 'autocomplete_for_users'
#    match "changeauthor/edit" => 'changeauthor#edit'
#    match "changeauthor/auto_complete" => 'changeauthor#auto_complete', :via => :get, :as => 'auto_complete_users'
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.connect 'project_access/update', :controller => 'project_access', :action => 'update'
    map.connect "project_access/autocomplete_for_users", :controller => 'project_access', :action => 'autocomplete_for_users', :via => :get, :as => 'autocomplete_for_users'
  end
end
