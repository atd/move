class GroupsController < ApplicationController
  include ActionController::StationResources

  authorization_filter :create, :group, :only => [ :new, :create ]
  authorization_filter :update, :group, :only => [ :edit, :update ]
  authorization_filter :delete, :group, :only => [ :destroy ]

  def show_with_contents
    conditions = authorized?([ :read, :content ], :resource) ?
      nil :
      { :public_read => true }

    @contents = ActiveRecord::Content.all(:container => resource,
                                          :page => params[:page], 
                                          :per_page => 10, 
                                          :select => "id, title, created_at, updated_at, owner_id, owner_type, author_id, author_type",
                                          :conditions => conditions)
    show_without_contents
  end

  alias_method_chain :show, :contents
end
