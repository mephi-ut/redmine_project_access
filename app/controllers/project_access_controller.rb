class ProjectAccessController < ApplicationController
  unloadable

  before_filter :find_project, :except => :autocomplete_for_users
  before_filter :authorize, :except => :autocomplete_for_users

  def update
    @project = Project.find(params[:project_id])
    if request.post?
      ProjectNonMemberUser.transaction do
        project = Project.find(:first, :conditions => { :id => params[:project_id]})
        ProjectNonMemberUser.delete_all(:project_id => project.id)
        user_ids = []
        user_ids = params[:user_ids] if params[:user_ids]
        user_ids.each do |user_id|
          pnmu = ProjectNonMemberUser.new
          if user = User.find(:first, :conditions => {:id => user_id})
            pnmu.user_id = user.id
          elsif group = Group.find(:first, :conditions => {:id => user_id})
            pnmu.group_id = group.id
          end
          pnmu.project_id = project.id
          pnmu.save!
        end
      end
    end
    redirect_to(:controller => 'projects', :action => 'settings', :id => @project, :tab => 'project_access')
  end

  def autocomplete_for_users
    @users = []
    q = (params[:q] || params[:term]).to_s.strip.downcase

    if q.present?
      @users = Principal.like(q).active.find(:all)
    end  
    render :layout => false
  end
  
  
private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end
end

