# encoding: utf-8

class AddColumnsPresupuestoPidanV1 < ActiveRecord::Migration
  def up
    
    execute "
    
      ALTER TABLE presupuesto_pidan ADD COLUMN monto_liquidado numeric(16,2) DEFAULT 0;
      ALTER TABLE presupuesto_pidan ADD COLUMN monto_por_liquidar numeric(16,2) DEFAULT 0;
      
      COMMENT ON COLUMN presupuesto_pidan.monto_liquidado IS 'Monto de banco entregado al beneficiario';
      COMMENT ON COLUMN presupuesto_pidan.monto_por_liquidar IS 'Monto de banco pendiente de entregar al beneficiario';
      
    "
  end

  def down
  
    execute "
    
      ALTER TABLE presupuesto_pidan DROP COLUMN monto_liquidado;
      ALTER TABLE presupuesto_pidan DROP COLUMN monto_liquidado_por_liquidar;
    "
  end
end
