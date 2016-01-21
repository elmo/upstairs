require 'test_helper'

class TenanciesControllerTest < ActionController::TestCase
  setup do
    @tenancy = tenancies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tenancies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tenancy" do
    assert_difference('Tenancy.count') do
      post :create, tenancy: {  }
    end

    assert_redirected_to tenancy_path(assigns(:tenancy))
  end

  test "should show tenancy" do
    get :show, id: @tenancy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tenancy
    assert_response :success
  end

  test "should update tenancy" do
    patch :update, id: @tenancy, tenancy: {  }
    assert_redirected_to tenancy_path(assigns(:tenancy))
  end

  test "should destroy tenancy" do
    assert_difference('Tenancy.count', -1) do
      delete :destroy, id: @tenancy
    end

    assert_redirected_to tenancies_path
  end
end
