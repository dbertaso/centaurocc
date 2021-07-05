class AddIndexTableDetallePrecioGaceta < ActiveRecord::Migration
  def up
  
     execute "CREATE UNIQUE INDEX ix_uq_valor_gaceta
              ON detalle_precio_gaceta (precio_gaceta_id ASC NULLS LAST, tipo_clase ASC NULLS LAST, actividad_id ASC NULLS LAST)
              WITH (FILLFACTOR=80);"
  end

  def down
    execute "DROP INDEX ix_uq_valor_gaceta;"
  end
end
