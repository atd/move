require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  it 'should render edit' do
    @task = Factory(:task)
    login_as Factory(:admin, :stage => @task.container).agent

    get :edit, :id => @task.to_param, :group_id => @task.container.to_param

    assert_response 200
  end
end

