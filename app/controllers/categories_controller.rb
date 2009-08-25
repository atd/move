# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/categories_controller"

class CategoriesController
  authorization_filter [ :read, :content ], :current_categories_domain, :only => [ :show ]
  authorization_filter [ :create, :content ], :current_categories_domain,
    :only => [ :index, :new, :create, :edit, :update, :destroy ]

  def show_with_authorization
    show_without_authorization

    @categorizables.delete_if{ |t| !t.authorize?(:read, :to => current_agent) }
  end

  alias_method_chain :show, :authorization
end
