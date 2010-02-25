class UsersController < ApplicationController
  # Include some methods and filters. 
  include ActionController::Agents
  
  alias_method :user, :agent
  helper_method :user
  
  authorization_filter :update, :user, :only => [ :edit, :update ]

  def show
    conditions = {}
    conditions[:public_read] = true unless authorized?([ :read, :content ], user)

    @contents = ActiveRecord::Content.paginate(
                  { :page => params[:page], 
                    :per_page => 5,
                    :order => "updated_at DESC" },
                  { :containers => Array(user),
                    :conditions => conditions } )

    respond_to do |format|
      format.html {
        if user.agent_options[:openid_server]
          headers['X-XRDS-Location'] = polymorphic_url(@agent, :format => :xrds)
          @openid_server_agent = @agent
        end
      }
      format.atomsvc
      format.xrds
      format.atom
    end
  end

  def update
    respond_to do |format|
      if user.update_attributes(params[:user])
        flash[:success] = t('user.updated')
        format.html { redirect_to @user }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
