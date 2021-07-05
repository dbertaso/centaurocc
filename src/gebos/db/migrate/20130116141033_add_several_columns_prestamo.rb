# encoding: utf-8

class AddSeveralColumnsPrestamo < ActiveRecord::Migration

  def up

    execute " ALTER TABLE prestamo ADD COLUMN moneda_id integer NOT NULL DEFAULT 0;
                ALTER TABLE prestamo ADD COLUMN cantidad_veces_mora integer NOT NULL DEFAULT 0;
                ALTER TABLE prestamo ADD COLUMN cantidad_veces_vigente integer NOT NULL DEFAULT 0;
                ALTER TABLE prestamo ADD COLUMN cantidad_dias_mora_acumulados integer NOT NULL DEFAULT 0;
                ALTER TABLE prestamo ADD COLUMN cantidad_compromisos_incumplidos integer NOT NULL DEFAULT 0;
                ALTER TABLE prestamo ADD COLUMN empresa_cobranza_id integer;
                ALTER TABLE prestamo ADD COLUMN tasa_conversion numeric(16,2) NOT NULL DEFAULT 1;
                ALTER TABLE prestamo ADD COLUMN fecha_tasa_conversion date NOT NULL DEFAULT 'now()';
                ALTER TABLE prestamo ADD COLUMN valor_moneda_nacional numeric(16,2);

                UPDATE prestamo set moneda_id = (select id from moneda where nombre = 'Bolivar');
                UPDATE prestamo set valor_moneda_nacional = monto_solicitado;

                ALTER TABLE prestamo ADD CONSTRAINT prestamo_moneda_id_fkey FOREIGN KEY (moneda_id)
                  REFERENCES moneda (id) MATCH SIMPLE
                  ON UPDATE NO ACTION ON DELETE NO ACTION;

                COMMENT ON COLUMN prestamo.moneda_id IS 'Moneda en la que se expresan los montos del prestamo';
                COMMENT ON COLUMN prestamo.cantidad_veces_mora IS 'Cantidad de veces que el prestamo ha estado moroso';
                COMMENT ON COLUMN prestamo.cantidad_veces_vigente IS 'Cantidad de veces que el prestamo ha estado vigente';
                COMMENT ON COLUMN prestamo.cantidad_dias_mora_acumulados IS 'Cantidad de dias acumulado de mora que ha tenido el prestamo';
                COMMENT ON COLUMN prestamo.empresa_cobranza_id IS 'Empresa a la cual se le ha asignado la cobranza externa';
                COMMENT ON COLUMN prestamo.tasa_conversion IS 'Valor de la tasa de conversión de la moneda';
                COMMENT ON COLUMN prestamo.fecha_tasa_conversion IS 'Ultima fecha en la cual cambio el valor de la tasa de conversion';
                COMMENT ON COLUMN prestamo.valor_moneda_nacional IS 'valor del monto del prestamo en moneda nacional';
                "
  end

  def self.down

    execute "ALTER TABLE prestamo DROP COLUMN moneda_id;
              ALTER TABLE prestamo DROP COLUMN cantidad_veces_mora;
              ALTER TABLE prestamo DROP COLUMN cantidad_veces_vigente;
              ALTER TABLE prestamo DROP COLUMN cantidad_dias_mora_acumulados;
              ALTER TABLE prestamo DROP COLUMN cantidad_compromisos_incumplidos;
              ALTER TABLE prestamo DROP COLUMN empresa_cobranza_id;
              ALTER TABLE prestamo DROP COLUMN tasa_conversion;
              ALTER TABLE prestamo DROP COLUMN fecha_tasa_conversion;
              ALTER TABLE prestamo DROP COLUMN valor_moneda_nacional;"
  end

end
