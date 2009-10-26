require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  include ActionController::AuthenticationTestHelper

  integrate_views

  describe 'when not authenticated' do
    it "should redirect index" do
      get :index, :format => :html

      assert_response 302
      response.should redirect_to(new_session_path)
    end
  end

  describe 'when authenticated' do
    before do
      login_as(Factory(:user))
    end

    it "should render index" do
      get :index

      assert_response 200
    end
  end
end
