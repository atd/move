require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  
  integrate_views

  before(:all) do
    @article = Factory(:article)
    # FIXME
    Anonymous.current.authorization_cache[@article] = Hash.new
  end

  it "should render show" do
    get :show, :id => @article.id, @article.container.class.to_s.foreign_key.to_sym => @article.container.id

    response.should be_success
  end

end

