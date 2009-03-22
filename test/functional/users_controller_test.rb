require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  context "Users" do
    setup do
      @user = users(!!FIXTURE_NAME)
      @user_params = {
:login => '',
	:email => '',
	:first_name => '',
	:last_name => '',
	:crypted_password => '',
	:salt => '',
	:created_at => '',
	:updated_at => '',
	:remember_token => '',
	:remember_token_expires_at => '',
	:activation_code => '',
	:activated_at => '',
	:state => 'passive',
	:deleted_at => ''
      }
    end

    context "html" do
      context "GET index" do
        setup do
          get :index
        end

        should_respond_with :success

        should "load paginated collection of users" do
          assert assigns(:users)
          assert assigns(:users).respond_to?(:next_page)
        end

        should "display user" do
          assert_select "#user_#{@user.id}"
        end
      end

      context "GET show" do
        setup do
          get :show, :id => @user.id
        end

        should_respond_with :success
        should_assign_to :user

        should "load user" do
          assert_equal @user, assigns(:user)
        end

        should "display user" do
          assert_select "#user_#{@user.id}"
        end
      end

      context "GET new" do
        setup do
          get :new
        end

        should_respond_with :success
        should_assign_to :user

        should "display form" do
          assert_select 'form'
        end
      end

      context "POST create with valid user" do
        setup do
          post :create, :user => @user_params
        end

        should_change 'User.count', :by => 1
        should_redirect_to "user_path(@user)"
        should_assign_to :user
      end

      context "GET edit" do
        setup do
          get :edit, :id => @user.id
        end

        should_respond_with :success
        should_assign_to :user

        should "load user" do
          assert_equal @user, assigns(:user)
        end

        should "display form" do
          assert_select 'form'
        end
      end

      context "PUT update" do
        setup do
          put :update, :id => @user.id, :user => @user_params
        end

        should_not_change 'User.count'
        should_redirect_to "user_path(@user)"
        should_assign_to :user

        should "load user" do
          assert_equal @user, assigns(:user)
        end
      end

      context "DELETE destroy" do
        setup do
          delete :destroy, :id => @user.id
        end

        should_change 'User.count', :by => -1
        should_redirect_to "users_path"
        should_assign_to :user
      end
    end
  end
  
end
