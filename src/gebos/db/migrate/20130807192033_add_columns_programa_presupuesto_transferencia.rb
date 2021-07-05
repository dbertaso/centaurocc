class AddColumnsProgramaPresupuestoTransferencia < ActiveRecord::Migration
  def up
execute "
    
      ALTER TABLE presupuesto_transferencia ADD COLUMN programa_id_origen integer NOT NULL DEFAULT 0;
      ALTER TABLE presupuesto_transferencia ADD COLUMN programa_id_destino integer NOT NULL DEFAULT 0;
      
      COMMENT ON COLUMN presupuesto_transferencia.programa_id_origen IS 'Codigo del programa de donde proviene el monto de presupuesto a transferir';
      COMMENT ON COLUMN presupuesto_transferencia.programa_id_destino IS 'Codigo del programa receptor el monto de presupuesto a transferir (usualmente es el mismo)';

    "
  end

  def down
  
    execute "
      ALTER TABLE presupuesto_transferencia DROP COLUMN programa_id_origen;
      ALTER TABLE presupuesto_transferencia DROP COLUMN programa_id_destino;
    "
  end
end
