class AddColumnUsuarioLenguaje < ActiveRecord::Migration
  def up
    execute "--ALTER TABLE usuario ADD COLUMN lenguaje character varying(2) NOT NULL DEFAULT 'es';"
  end

  def down
  end
end
