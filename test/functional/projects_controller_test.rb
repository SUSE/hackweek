require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in :user, User.find('1')
    @project = projects(:linux)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { description: @project.description, title: @project.title }
    end
    
    assert_equal users(:linus), assigns(:project).originator

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    put :update, id: @project, project: { description: @project.description, title: @project.title }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should have three users" do
    assert_equal @project.users.count, 3
  end

  test "should have two comments" do
    # The project has one comment
    assert_equal @project.comments.count, 1
    # The comment has one reply
    assert_equal @project.comments[0].comments.count, 1
  end

  test "should have three keywords" do
    assert_equal @project.keywords.count, 3
  end

end
