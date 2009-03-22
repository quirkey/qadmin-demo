class UsersController < AdminController
  
  qadmin do |q|
    q.display_columns.only = [:login, :email, :first_name, :last_name, :created_at, :updated_at]
  end

end
