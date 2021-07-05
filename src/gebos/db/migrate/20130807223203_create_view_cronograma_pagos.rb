# encoding: utf-8

class CreateViewCronogramaPagos < ActiveRecord::Migration
  
  def up
    
    execute "
    
      DROP VIEW IF EXISTS view_cronograma_pagos;
      
      CREATE OR REPLACE VIEW view_cronograma_pagos AS     
      select 
              ppc.id,
              pp.prestamo_id,
              pp.activo,
              pp.fecha_fin,
              ppc.fecha,
              ppc.numero,
              ppc.valor_cuota,
              ppc.amortizado as capital,
              ppc.tipo_cuota,
              ppc.estatus_pago,
              ppc.interes_corriente,
              ppc.interes_diferido,
              ppc.interes_mora,
              ppc.saldo_insoluto
      from
            plan_pago pp
              inner join plan_pago_cuota ppc on (pp.id = ppc.plan_pago_id and
                                                pp.activo = true);
    
    "

  end

  def down
  
    execute "
    
      DROP VIEW IF EXISTS view_cronograma_pagos;
      "
  end

end
