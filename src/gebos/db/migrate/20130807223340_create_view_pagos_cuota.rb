# encoding: utf-8

class CreateViewPagosCuota < ActiveRecord::Migration
  def up
    
    execute " 
    
          DROP VIEW if exists view_pagos_estado_cuenta;
          DROP VIEW if exists view_pagos_cuota;
    
          CREATE OR REPLACE VIEW view_pagos_cuota AS
    
         SELECT pp.prestamo_id, pp.pago_cliente_id, 
                CASE
                    WHEN sum(pc.interes_corriente) IS NULL THEN 0.00
                    ELSE sum(pc.interes_corriente)
                END AS pago_interes, 
                CASE
                    WHEN sum(pc.interes_diferido) IS NULL THEN 0.00
                    ELSE sum(pc.interes_diferido)
                END AS pago_interes_diferido, 
                CASE
                    WHEN sum(pc.interes_mora) IS NULL THEN 0.00
                    ELSE sum(pc.interes_mora)
                END AS pago_interes_mora, 
                CASE
                    WHEN sum(pc.capital) IS NULL THEN 0.00
                    ELSE sum(pc.capital)
                END AS pago_capital
           FROM pago_prestamo pp    
           LEFT JOIN pago_cuota pc ON pp.id = pc.pago_prestamo_id
          group by pp.prestamo_id, pp.pago_cliente_id;

          COMMENT ON VIEW view_pagos_cuota IS 'Pagos de cuota agrupadas por prestamo_id y pago_cliente_id';

          CREATE OR REPLACE VIEW view_pagos_estado_cuenta AS 
           SELECT factura.prestamo_id, factura.pago_cliente_id, factura.fecha_realizacion, factura.fecha, factura.tipo, factura.monto AS monto_pago, factura.remanente_por_aplicar, factura.abono_capital AS abono_capital, 
             vpc.pago_interes + factura.pago_interes as pago_interes,
             vpc.pago_interes_diferido,
             vpc.pago_interes_mora,
             vpc.pago_capital
             FROM factura
             
             JOIN view_pagos_cuota vpc on vpc.prestamo_id = factura.prestamo_id  and vpc.pago_cliente_id = factura.pago_cliente_id
            WHERE factura.tipo = ANY (ARRAY['P'::bpchar, 'R'::bpchar])
            ORDER BY factura.prestamo_id, factura.pago_cliente_id, factura.fecha_realizacion DESC;
            
           COMMENT ON VIEW view_pagos_estado_cuenta IS 'Relación de facturas de pago';
    "
  end

  def down
  end
end
