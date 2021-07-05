# encoding: utf-8

class AddSeveralColumnsFactura < ActiveRecord::Migration
  def up


    execute "--ALTER TABLE factura ADD COLUMN pago_al_dia boolean NOT NULL DEFAULT 'f';

            ALTER TABLE pago_cuota ADD COLUMN fecha_vencimiento date;
            ALTER TABLE pago_cuota ADD COLUMN fecha_pago date;
            ALTER TABLE pago_cuota ADD COLUMN dias_atraso integer;

            COMMENT ON COLUMN factura.pago_al_dia IS 'Para indicar si el pago fue realizado al dia o no';

            COMMENT ON COLUMN pago_cuota.fecha_vencimiento IS 'Fecha en que vence la cuota (debe ser igual a la fecha de plan_pago_cuota)';
            COMMENT ON COLUMN pago_cuota.fecha_pago IS 'Fecha en la que fue realizado efectivamente el pago de cuota';
            COMMENT ON COLUMN pago_cuota.dias_atraso IS 'Cantidad de dias de atraso en el pago de la cuota (fecha_pago - fecha_vencimiento)';
            "
  end

  def down

    execute "ALTER TABLE factura DROP COLUMN pago_al_dia;

            ALTER TABLE pago_cuota DROP COLUMN fecha_vencimiento;
            ALTER TABLE pago_cuota DROP COLUMN fecha_pago;
            ALTER TABLE pago_cuota DROP COLUMN dias_atraso;"
  end

end
