module CommonContents
  class << self
    def included(base)
      base.class_eval do
        before_filter :container!
        authorization_filter :read, :resource, :only => [ :show ]
        authorization_filter [ :create, :content ], :container, :only => [ :new, :create ]
        authorization_filter :update, :resource, :only => [ :edit, :update ]
        authorization_filter :delete, :resource, :only => [ :destroy ]

        alias_method_chain :index, :public
      end
    end
  end

  def index_with_public
    @conditions = ( container && authorized?([ :read, :content], container) ?
                   nil :
                   { :public_read => true } )
      
    index_without_public
  end
end
