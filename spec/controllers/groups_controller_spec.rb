require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  describe "show" do
    it "should work for Anonymous" do
      get :show, :id => Factory(:group).to_param

      assert_response 200
    end
  end

  describe "new" do
    it "should ask for authentication to Anonymous" do
      get :new
      assert redirect_to login_path
    end
    
    describe "as authenticated" do
      before do
        login_as Factory.create(:user)
      end

      it "should render" do
        get :new
        response.should be_success
      end
    end
  end

  describe "create" do
    it "should ask for authentication to Anonymous" do
      post :create, :group => Factory.attributes_for(:group)

      assert redirect_to login_path
      assigns(:group).should be_new_record
    end

    describe "as authenticated" do
      before do
        @user = Factory.create(:user)
        login_as @user
      end

      it "should create group and include the author" do
        post :create, :group => Factory.attributes_for(:group)

        assigns(:group).should be_valid
        assert assigns(:group).users.include?(@user)
        assigns(:group).user.should == @user

        assert redirect_to(assigns(:group))
      end
    end
  end

end

