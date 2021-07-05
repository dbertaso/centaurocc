class AddColumnGestionCobranzas < ActiveRecord::Migration
  def up

    execute "

      ALTER TABLE gestion_cobranzas ADD COLUMN hora_registro time(6) without time zone;

      COMMENT ON COLUMN gestion_cobranzas.hora_registro IS 'Hora de registro en base de datos de la gestion de cobranzas:

      COMMENT ON COLUMN compromiso_pago.monto_efectivamente_pago IS Monto real pagado por el cliente;'
    "
  end

  def down

    execute "

      ALTER TABLE gestion_cobranzas DROP COLUMN hora_registro;
    "
  end
end
