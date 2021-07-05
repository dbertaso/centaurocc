# encoding: utf-8
class AddColumnObservacionProgramaPresupuestoTransferencia < ActiveRecord::Migration
  def up
  execute "
      --ALTER TABLE presupuesto_transferencia ADD COLUMN observaciones_justificacion text;
      
      COMMENT ON COLUMN presupuesto_transferencia.observaciones_justificacion IS 'Observaciones sobre la transferencia'
    "
  end

  def down
  end
end
