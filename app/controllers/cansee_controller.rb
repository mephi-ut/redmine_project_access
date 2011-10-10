class CanseeController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :authorize

  def index
    @project = Project.find(params[:project_id])
    @pnmu = ProjectNonMemberUser.find(:all, :conditions => { :project_id => @project.id})
    @can_see = User.find(:all, :conditions => ["id IN (?)", @pnmu.map(&:user_id)])
    if @pnmu.map(&:user_id) == []
      @cant_see = User.find(:all)
    else
      @cant_see = User.find(:all, :conditions => ["id NOT IN (?)", @pnmu.map(&:user_id)])
    end
  end

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
          pnmu.user_id = user_id
          pnmu.project_id = project.id
          pnmu.save!
        end
      end
    end
    redirect_to :back
  end

private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end
end

