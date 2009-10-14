require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  include ActionController::AuthenticationTestHelper
  
  integrate_views

  before(:all) do
    @article = Factory(:article)
  end

  describe "as Anonymous" do
    it "should render show" do
      get :show, :id => @article.id, @article.container.class.to_s.foreign_key.to_sym => @article.container.id

      response.should be_success
    end
  end

  describe "as authenticated" do
    before do
      login_as(Factory(:user))
    end

    it "should render show" do
      get :show, :id => @article.id, @article.container.class.to_s.foreign_key.to_sym => @article.container.id

      response.should be_success
    end
  end

end

