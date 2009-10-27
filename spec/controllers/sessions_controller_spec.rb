require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  describe "new" do
    it 'should render' do
      get :new

      assert_response 200
    end
  end

  describe "create" do
    describe 'with valid login and password' do
      before do
        user_attributes = Factory.attributes_for(:user)
        @user = User.create(user_attributes)
        @user.activate
        @credentials = user_attributes.reject{ |k, v| 
          ! [ :login, :password ].include?(k)
        }
      end

      it 'should validate user' do
        post :create, @credentials
        
        assert controller.current_user == @user
        response.should redirect_to(home_path) 
      end
    end

    describe 'with invalid login and password' do
      before do
        @credentials = { :login => 'bad', :password => 'incorrect' }
      end

      it 'should NOT validate user' do
        post :create, @credentials
        
        controller.current_user.should be(Anonymous.current)
        assert_response 200
        response.should render_template('new')
      end
    end

    describe 'with valid openid' do
      before do
        @credentials = { :openid_identifier => 'dit.upm.es/atapiador' }
        @openid_provider = 'http://irss.dit.upm.es/openid_server'
      end

      it 'should redirect to OpenID provider' do
        post :create, @credentials

        assert_response 302
        response.should have_text(/#{ @openid_provider }/)
      end
    end


  end

  describe "on logout" do
    before do
      login_as Factory(:user)
    end

    it 'should destroy session' do
      get :destroy

      session[:agent_id].should be_nil
      session[:agent_type].should be_nil
      response.should be_redirect
    end
  end
end

