require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users
  
  context "Sessions Controller" do
    setup do
      @user = users(:quentin)
    end
    
    context "logging in" do
      context "with bad login" do
        setup do
          post :create, :login => @user.login, :password => 'Bas PSSS'
        end

        should_respond_with :success
        should_set_the_flash_to(/Couldn\'t log you in/i)

        should "not set user in session" do
          assert !@controller.send(:current_user)
        end

      end

      context "with good login" do
        setup do
          post :create, :login => @user.login, :password => 'monkey'
        end

        should_respond_with :redirect

        should "set user in session" do
          assert_equal @user, @controller.send(:current_user)
        end
      end

      context "with remember me" do
        setup do
          @request.cookies["auth_token"] = nil
          post :create, :login => @user.login, :password => 'monkey', :remember_me => "1"
        end

        should "set auth token" do
          assert_not_nil @response.cookies["auth_token"]
        end
      end

      context "without remember me" do
        setup do
          @request.cookies["auth_token"] = nil
          post :create, :login => @user.login, :password => 'monkey', :remember_me => "0"
        end

        should "not set auth token" do
          assert @response.cookies["auth_token"].blank?
        end
      end

      context "with cookie" do
        setup do
          users(:quentin).remember_me
          @request.cookies["auth_token"] = cookie_for(:quentin)
          get :new
        end
        
        should "auto be logged in" do
          assert @controller.send(:logged_in?)
        end
      end

      context "with expired cookie" do
        setup do
          users(:quentin).remember_me
          users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
          @request.cookies["auth_token"] = cookie_for(:quentin)
          get :new
        end

        should "not auto log in" do
          assert !@controller.send(:logged_in?)
        end
      end

      context "with invalid cookie" do
        setup do
          users(:quentin).remember_me
          @request.cookies["auth_token"] = auth_token('invalid_auth_token')
          get :new
        end
        
        should "not auto log in" do
          assert !@controller.send(:logged_in?)
        end
      end
      
      context "with explicit redirect" do
        setup do
          post :create, :login => @user.login, :password => 'monkey', :r => '/path/to/redirect'
        end
        
        should_redirect_to "'/path/to/redirect'"
        
        should "be logged in" do
          assert @controller.send(:logged_in?)
        end
      end
    end

    context "logging out" do
      setup do
        login_as :quentin
        get :destroy
      end

      should_respond_with :redirect

      should "set user to nil" do
        assert_nil session[:user_id]
      end

      should "delete token" do
        assert @response.cookies["auth_token"].blank?
      end
    end
  end
  
  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
