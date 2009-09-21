require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CategoriesController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  describe "index" do
    before do
      @category = Factory.create(:category)
      @group = @category.domain
      @admin = Factory(:admin, :stage => @group).agent
    end

    describe "for admin" do
      before do
        login_as(@admin)
      end

      it "should render" do
        get :index, :group_id => @group.id

        response.should be_success
      end
    end
  end
end

