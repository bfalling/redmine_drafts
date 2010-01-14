class DraftsController < ApplicationController
  unloadable
  
  before_filter :require_login

  def create
    has_to_be_saved = !params[:notes].blank?
    has_to_be_saved ||= (params[:issue_id].to_i == 0 && !params[:issue][:subject].blank?)
    if request.xhr? && has_to_be_saved
      @draft = Draft.find_or_create_for_issue(:user_id => params[:user_id].to_i,
                                              :element_id => params[:issue_id].to_i,
                                              :element_lock_version => params[:issue][:lock_version].to_i)
      @draft.content = params.reject{|k,v| !%w(issue notes).include?(k)}
      if @draft.save
        render :partial => "saved", :layout => false
      else
        render :text => "Error saving draft"
      end
    else
      render :nothing => true
    end
  end

  def restore
    @draft = Draft.find(params[:id])
    if @draft.element_id == 0
      redirect_to({:controller => "issues", :action => "new", :project_id => params[:project_id].to_i}.merge(@draft.content))
    else
      redirect_to({:controller => "issues", :action => "edit", :id => @draft.element_id}.merge(@draft.content))
    end
  end
  
  def destroy
    @draft = Draft.find(params[:id])
    @draft.destroy
    render :nothing => true
  end
end
