class UpdateColumnsCompromisoPago < ActiveRecord::Migration
  def up

    execute "

       ALTER TABLE compromiso_pago DROP COLUMN senal_rango_gracia;
       ALTER TABLE compromiso_pago ADD COLUMN monto_efectivamente_pago numeric(16,2) DEFAULT 0;
       ALTER TABLE telecobranzas DROP COLUMN cantidad_intentos_fallidos;"
  end

  def down

    execute "

       ALTER TABLE compromiso_pago ADD COLUMN senal_rango_gracia character(1);
       ALTER TABLE compromiso_pago DROP COLUMN monto_efectivamente_pago;
       ALTER TABLE telecobranzas ADD COLUMN cantidad_intentos_fallidos integer;"
  end
end
