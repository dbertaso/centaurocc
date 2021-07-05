# encoding: utf-8

class RemoveColumnsGestionCobranzas < ActiveRecord::Migration
  def up

    execute "
        ALTER TABLE gestion_cobranzas DROP COLUMN estatus;
        ALTER TABLE gestion_cobranzas DROP COLUMN confirmada;
        ALTER TABLE compromiso_pago DROP COLUMN hora_pago;
    "
  end

  def down

    execute "
        ALTER TABLE gestion cobranzas ADD COLUMN estatus char(1) DEFAULT 'P';
        ALTER TABLE gestion_cobranzas ADD COLUMN confimada boolean DEFAULT true;

        COMMENt ON COLUMN gestion_cobranzas.estatus IS 'Indica el estatus de la cobranza P=En Proceso, C=Confirmada';

        COMMENT ON COLUMN gestion_cobranzas.confimada IS 'Indica si la gestion fue confirmada (true) o no (false)';

        COMMENT ON COLUMN compromiso_pago.estatus = 'E= En espera de cumplimiento de Fecha (estatus por default cuando se crea el Compromiso, A= Cumplido antes del Vencimiento del Compromiso, V= Cumplido en la Fecha del compromiso, R=Cumplido dentro del rango de gracia, P=Parcialmente Cumplido, N=No Cumplido (No hay pagos registrados en el sistema hasta la Fecha límite del compromiso)). NOTA IMPORTANTE: El Proceso de Pago de Cuota debe actualizar los estatus  (A,V,R,P). El estatus “N” lo actualiza el Cierre Especial de Cobranza conjuntamente con el campo Cantidad de Compromisos de Pago Incumplidos que está en el Préstamo.'
    "
  end
end
