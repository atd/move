require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PublicController do

  integrate_views

  it "should render index" do
    get :index

    assert_response 200
  end
end
