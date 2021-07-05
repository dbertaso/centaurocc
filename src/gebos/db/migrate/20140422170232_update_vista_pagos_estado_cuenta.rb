# encoding: utf-8
class UpdateVistaPagosEstadoCuenta < ActiveRecord::Migration
  def change

    execute "

        DROP VIEW if exists view_pagos_estado_cuenta;

        CREATE OR REPLACE VIEW view_pagos_estado_cuenta AS 
         SELECT factura.prestamo_id,
            factura.pago_cliente_id,
            factura.fecha_realizacion,
            factura.fecha,
            factura.tipo,
            factura.monto::double precision AS monto_pago,
            factura.remanente_por_aplicar::double precision AS remanente_por_aplicar,
            factura.abono_capital::double precision AS abono_capital,
                CASE
                    WHEN vpc.pago_interes IS NULL THEN factura.pago_interes::double precision
                    ELSE vpc.pago_interes::double precision
                END AS pago_interes,
            vpc.pago_interes_diferido::double precision AS pago_interes_diferido,
            vpc.pago_interes_mora::double precision AS pago_interes_mora,
            vpc.pago_capital::double precision AS pago_capital
           FROM factura
           JOIN view_pagos_cuota vpc ON vpc.prestamo_id = factura.prestamo_id AND vpc.pago_cliente_id = factura.pago_cliente_id
          WHERE factura.tipo = ANY (ARRAY['P'::bpchar, 'R'::bpchar])
          ORDER BY factura.prestamo_id, factura.pago_cliente_id, factura.fecha_realizacion DESC;

    "
  end


end
