class UpdateMenuConvertidor < ActiveRecord::Migration
  def up
    execute "UPDATE menu SET orden = 159 WHERE id = 880"
  end

  def down
  end
end
