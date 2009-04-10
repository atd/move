class PublicController < ApplicationController
  def index
    @contents = ActiveRecord::Content.all :conditions => { :public_read => true },
                                          :select => "id, title, created_at, updated_at, owner_id, owner_type",
                                          :order => 'created_at DESC',
                                          :per_page => 10,
                                          :page => params[:page]

  end
end
