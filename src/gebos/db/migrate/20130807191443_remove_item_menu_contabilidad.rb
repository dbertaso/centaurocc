class RemoveItemMenuContabilidad < ActiveRecord::Migration
  def up
  execute "
      delete from menu where id = 835;
    "
  end

  def down
  end
end
