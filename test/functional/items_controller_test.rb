require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  
  context "Items" do
    setup do
      @item = items(!!FIXTURE_NAME)
      @item_params = {
:sku => '',
	:name => '',
	:description => '',
	:retail_price_cents => '',
	:active => 'false',
	:created_at => '',
	:updated_at => ''
      }
    end

    context "html" do
      context "GET index" do
        setup do
          get :index
        end

        should_respond_with :success

        should "load paginated collection of items" do
          assert assigns(:items)
          assert assigns(:items).respond_to?(:next_page)
        end

        should "display item" do
          assert_select "#item_#{@item.id}"
        end
      end

      context "GET show" do
        setup do
          get :show, :id => @item.id
        end

        should_respond_with :success
        should_assign_to :item

        should "load item" do
          assert_equal @item, assigns(:item)
        end

        should "display item" do
          assert_select "#item_#{@item.id}"
        end
      end

      context "GET new" do
        setup do
          get :new
        end

        should_respond_with :success
        should_assign_to :item

        should "display form" do
          assert_select 'form'
        end
      end

      context "POST create with valid item" do
        setup do
          post :create, :item => @item_params
        end

        should_change 'Item.count', :by => 1
        should_redirect_to "item_path(@item)"
        should_assign_to :item
      end

      context "GET edit" do
        setup do
          get :edit, :id => @item.id
        end

        should_respond_with :success
        should_assign_to :item

        should "load item" do
          assert_equal @item, assigns(:item)
        end

        should "display form" do
          assert_select 'form'
        end
      end

      context "PUT update" do
        setup do
          put :update, :id => @item.id, :item => @item_params
        end

        should_not_change 'Item.count'
        should_redirect_to "item_path(@item)"
        should_assign_to :item

        should "load item" do
          assert_equal @item, assigns(:item)
        end
      end

      context "DELETE destroy" do
        setup do
          delete :destroy, :id => @item.id
        end

        should_change 'Item.count', :by => -1
        should_redirect_to "items_path"
        should_assign_to :item
      end
    end
  end
  
end
