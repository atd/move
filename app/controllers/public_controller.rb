class PublicController < ApplicationController
  def index
    @contents = ActiveRecord::Content.all :conditions => { :public_read => true },
                                          :contents => User.contents & Group.contents,
                                          :order => 'updated_at DESC',
                                          :per_page => 5,
                                          :page => params[:page]

  end
end
