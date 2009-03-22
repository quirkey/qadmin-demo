class ItemsController < AdminController

  qadmin do |q|
    q.display_columns.exclude = ['id', 'description']
  end

end
