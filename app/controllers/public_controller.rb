class PublicController < ApplicationController
  def index
    @contents = ActiveRecord::Content.paginate(
                  { :order => 'updated_at DESC',
                    :per_page => 5,
                    :page => params[:page] },
                  { :contents => User.contents | Group.contents,
                    :conditions => { :public_read => true } } )
  end
end
