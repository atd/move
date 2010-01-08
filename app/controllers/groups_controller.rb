class GroupsController < ApplicationController
  include ActionController::StationResources

  authorization_filter :create, :group, :only => [ :new, :create ]
  authorization_filter :update, :group, :only => [ :edit, :update ]
  authorization_filter :delete, :group, :only => [ :destroy ]

  def show_with_contents
    conditions = authorized?([ :read, :content ], group) ?
      nil :
      { :public_read => true }

    @group_contents = group.contents(:page => params[:page], 
                                     :per_page => 5, 
                                     :conditions => conditions)
    show_without_contents
  end

  alias_method_chain :show, :contents
end
