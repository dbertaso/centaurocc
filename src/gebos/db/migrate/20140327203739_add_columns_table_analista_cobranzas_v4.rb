
# encoding: utf-8

class AddColumnsTableAnalistaCobranzasV4 < ActiveRecord::Migration
  def change


    execute "

      ALTER TABLE analista_cobranzas ADD COLUMN cantidad_cobranzas integer DEFAULT 0;
      ALTER TABLE analista_cobranzas ADD COLUMN carga_trabajo integer DEFAULT 0;

      COMMENT ON COLUMN analista_cobranzas.cantidad_cobranzas IS 'Cantidad de cobranzas efectuadas por el analista';
      COMMENT ON COLUMN analista_cobranzas.carga_trabajo IS 'Cantidad de Creditos asignados al analista';
      
    "

  end


end
