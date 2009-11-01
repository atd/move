class PublicController < ApplicationController
  def index
    @contents = ActiveRecord::Content.all :conditions => { :public_read => true },
                                          :select => "id, title, created_at, updated_at, owner_id, owner_type, author_id, author_type",
                                          :order => 'updated_at DESC',
                                          :per_page => 5,
                                          :page => params[:page]

  end
end
