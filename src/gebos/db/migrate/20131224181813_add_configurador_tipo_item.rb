class AddConfiguradorTipoItem < ActiveRecord::Migration
  def up
	execute "ALTER TABLE configurador ADD COLUMN tipo_item character varying(1);"
  end

  def down
  end
end
