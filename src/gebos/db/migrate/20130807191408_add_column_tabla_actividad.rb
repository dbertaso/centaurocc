class AddColumnTablaActividad < ActiveRecord::Migration
  def up
  execute "
        --ALTER TABLE actividad ADD COLUMN plazo_ciclo CHAR(1);
        
        COMMENT ON COLUMN actividad.plazo_ciclo IS 'Indica si el finaciamiento resultante sera de (C)orto plazo o (L)argo plazo';
    "
  end

  def down
  execute " 
      ALTER TABLE actividad DROP COLUMN plazo_ciclo;
    "
  end
end
