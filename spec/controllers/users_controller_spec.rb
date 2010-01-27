require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  describe "show" do
    it "should work for Anonymous" do
      get :show, :id => Factory(:user).to_param

      assert_response 200
    end
  end
end
