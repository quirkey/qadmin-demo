require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  should_require_attributes :login, :email, :password, :password_confirmation
  should_require_unique_attributes :login, :email

  context "creating a regular user" do
    setup do
      @user = create_user
      @user.reload
    end

    should "save user" do
      assert !@user.new_record?, "#{@user.errors.full_messages.to_sentence}"
    end
  
    should "initialize activation code" do
      assert_not_nil @user.activation_code
    end
    should "start in pending state" do
      assert @user.pending?
    end

  end

  context "a user" do
    setup do
      @user = users(:quentin)
    end

    context "authenticating" do

      should "authenticate user by login" do
        assert_equal @user, User.authenticate(@user.login, 'monkey')
      end

      should "reset password on update" do
        @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
        assert_equal @user, User.authenticate(@user.login, 'new password')
      end

      should "not rehash password if password is not included when updating" do
        @user.update_attributes(:email => 'quentin2@example.com')
        assert_equal @user, User.authenticate(@user.login, 'monkey')
      end

    end    

    
    context "with states" do
      context "creating a user without passwords" do
        setup do
          @user = create_user(:password => nil, :password_confirmation => nil)
        end
        
        should "be passive" do
          assert @user.passive?
        end
        
        should "transition to pending on register!" do
          @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
          @user.register!
          assert @user.pending?
        end
      end
    end
    
    context "deleting user" do
      setup do
        @user.delete!
        @user.reload
      end
      
      should "set deleted time" do
        assert_not_nil @user.deleted_at
      end 
      
      should "transition to deleted state" do
        @user.deleted?
      end 
    end

    context "a suspended user" do
      setup do
        @user.suspend!
      end

      should "be suspended" do
        assert @user.suspended?
      end

      should "not authenticate" do
        assert_not_equal @user, User.authenticate(@user.login, 'monkey')
      end

      should "unsuspend user to active state" do
        @user.unsuspend!
        assert @user.active?
      end
      
      context "unsuspending a suspended user without activation code and nil activated_at" do
        should "transition to passive" do
          User.update_all :activation_code => nil, :activated_at => nil
          @user.reload.unsuspend!
          assert @user.passive?
        end
      end
      
      context "unsuspending a suspended user with activation code and nil activated_at" do
        should "transition to pending" do
          User.update_all :activation_code => 'foo-bar', :activated_at => nil
          @user.reload.unsuspend!
          assert @user.pending?
        end
      end        
    end

    
    context "remembering" do
      context "remember_me" do        
        setup do
          @remembered = 2.weeks.from_now.utc
          @user.remember_me
        end
        
        should "set remember token" do
          assert_not_nil @user.remember_token
          assert_not_nil @user.remember_token_expires_at
        end
        
        should "remember for default two weeks" do
          assert @user.remember_token_expires_at.between?(@remembered, 2.weeks.from_now.utc)
        end
      end

      context "forget_me" do
        should "unset token" do
          @user.remember_me
          @user.forget_me
          assert_nil @user.remember_token
        end
      end
    
      context "remember_me_for" do
        should "remember me for one week" do
          before = 1.week.from_now.utc
          @user.remember_me_for 1.week
          after = 1.week.from_now.utc
          assert_not_nil @user.remember_token
          assert_not_nil @user.remember_token_expires_at
          assert @user.remember_token_expires_at.between?(before, after)
        end
      end
    
      context "remember me until" do
        should "remember me until one week" do
          time = 1.week.from_now.utc
          @user.remember_me_until time
          assert_not_nil @user.remember_token
          assert_not_nil @user.remember_token_expires_at
          assert_equal @user.remember_token_expires_at, time
        end
      end
      
    end

  end

  protected
  def create_user(options = {})
    record = User.new({:login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end