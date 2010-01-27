module CommonContents
  class << self
    def included(base)
      base.class_eval do
        before_filter :path_container!, :except => [ :index, :show ]
        authorization_filter :read, :resource, :only => [ :show ]
        authorization_filter :create, :resource, :only => [ :new, :create ]
        authorization_filter :update, :resource, :only => [ :edit, :update ]
        authorization_filter :delete, :resource, :only => [ :destroy ]

        alias_method_chain :index, :public
      end
    end
  end

  def index_with_public(&block)
    @conditions = ( path_container && authorized?([ :read, :content], path_container) ?
                   nil :
                   { :public_read => true } )

    params[:order] ||= 'updated_at'
    params[:direction] ||= "DESC"
      
    index_without_public(&block)
  end
end
