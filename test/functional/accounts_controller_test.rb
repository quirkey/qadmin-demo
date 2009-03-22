require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users
  
  context "Accounts Controller" do
    setup { ActionMailer::Base.deliveries = [] }
    
    context "creating user" do
      context "with valid params" do
        setup { create_user }

        should_change 'User.count', :by => 1
        should_respond_with :redirect
        
        should "send welcome email" do
          assert_sent_email {|email| email.to.include?(assigns(:user).email) }
        end
  
        
        should "signup in pending state" do
          assigns(:user).reload
          assert assigns(:user).pending?
        end
        
          
        should "create activation code" do
          assigns(:user).reload
          assert_not_nil assigns(:user).activation_code
        end
      end
      
      context "with invalid params" do
        setup { create_user(:login => nil) }
                
        should_not_change 'User.count'
        should_respond_with :success
        
        should "not send welcome email" do
          assert_did_not_send_email
        end
        
        should "have errors on invalid params" do
          assert assigns(:user).errors.on(:login)
        end
      end
    end
    
    context "activating user" do
      context "with inactive user with key" do
        setup do
          @user = users(:aaron)
          get :activate, :activation_code => @user.activation_code
        end
        
        should_redirect_to "login_path"

        should "set flash message" do
          assert_not_nil flash[:notice]
        end
        
        should "activate user" do
          assert @user.reload.active?
          assert_equal @user, User.authenticate(@user.login, 'monkey')
        end
      end
      
      context "with no key" do
        should "not activate user" do
          begin
            get :activate
            assert_nil flash[:notice]
          rescue ActionController::RoutingError
            # in the event your routes deny this, we'll just bow out gracefully.
          end
        end      
      end
      
      context "with blank key" do
        should "not activate user" do
          begin
            get :activate, :activation_code => ''
            assert_nil flash[:notice]
          rescue ActionController::RoutingError
            # in the event your routes deny this, we'll just bow out gracefully.
          end
        end      
      end
    end
    
  end

  protected
    def create_user(options = {})
      post :create, :user => {
                                          :login => 'quire',
                                          :email => 'quire@example.com',
                                          :password => 'quire69', 
                                          :password_confirmation => 'quire69'
                                         }.merge(options)
    end
end