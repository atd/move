require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  include ActionController::AuthenticationTestHelper
  
  integrate_views

  before(:all) do
    @photo = Factory(:photo)
  end

  describe "as Anonymous" do
    it "should render index" do
      get :index, @photo.container.class.name.foreign_key => @photo.container.to_param

      assert_response 200
    end

    it "should render atom index" do
      get :index, @photo.container.class.name.foreign_key => @photo.container.to_param, :format => 'atom'

      assert_response 200
    end

    it "should render show" do
      get :show, :id => @photo.id, @photo.container.class.name.foreign_key => @photo.container.to_param

      response.should be_success
    end
  end

  describe "as authenticated" do
    before do
      login_as(Factory(:user))
    end

    it "should render show" do
      get :show, :id => @photo.id, @photo.container.class.name.foreign_key => @photo.container.to_param

      response.should be_success
    end
  end

end

