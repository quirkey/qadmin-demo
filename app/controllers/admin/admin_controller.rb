class AdminController < ApplicationController
  layout "admin"
  before_filter :login_required
  
  self.prepend_view_path 'app/views/admin'

  protected
  
  def self.controller_path
    @controller_path ||= File.join('admin', name.gsub(/Controller$/, '').underscore)
  end
  
end
