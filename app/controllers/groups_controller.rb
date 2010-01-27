class GroupsController < ApplicationController
  include ActionController::StationResources

  authorization_filter :create, :group, :only => [ :new, :create ]
  authorization_filter :update, :group, :only => [ :edit, :update ]
  authorization_filter :delete, :group, :only => [ :destroy ]

  def show_with_contents
    conditions = authorized?([ :read, :content ], group) ?
      nil :
      { :public_read => true }

    @group_contents = ActiveRecord::Content.paginate(
                        { :page => params[:page], 
                          :per_page => 5,
                          :order => "updated_at DESC" }, 
                        { :containers => Array(group),
                          :conditions => conditions } )
    show_without_contents
  end

  alias_method_chain :show, :contents
end
