# == Schema Information
#
# Table name: items
#
#  id                 :integer         not null, primary key
#  sku                :string(255)
#  name               :string(255)
#  description        :text
#  retail_price_cents :integer
#  active             :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class Item < ActiveRecord::Base
end
