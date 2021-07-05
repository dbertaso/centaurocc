class CreateViewCarteraProgramaPlazo < ActiveRecord::Migration
  def up
  execute " 
    
          DROP VIEW if exists view_cartera_programa_plazo;
          
          CREATE OR REPLACE VIEW view_cartera_programa_plazo AS
          
            SELECT
                   prestamo.numero AS prestamo_numero,
                   prestamo.estatus AS prestamo_estado,
                   prestamo.saldo_insoluto  - prestamo.capital_pago_parcial AS prestamo_saldo_insoluto,
                   prestamo.interes_vencido AS prestamo_interes_vencido,
                   prestamo.monto_mora AS prestamo_monto_mora,
                   prestamo.causado_no_devengado AS prestamo_causado_no_devengado,
                   prestamo.interes_diferido_vencido AS prestamo_interes_diferido_vencido,
                   prestamo.interes_diferido_por_vencer AS prestamo_interes_diferido_por_vencer,
                   prestamo.interes_vencido + prestamo.interes_diferido_vencido AS prestamo_interes_vencido_total,
                   prestamo.capital_pago_parcial AS prestamo_capital_pago_parcial,
                   prestamo.capital_vencido AS prestamo_capital_vencido,
                   prestamo.remanente_por_aplicar AS prestamo_remanente_por_aplicar,
                   prestamo.capital_pagado AS prestamo_capital_pagado,
                   prestamo.deuda AS prestamo_deuda,
                   prestamo.interes_desembolso_vencido AS prestamo_interes_desembolso_vencido,
                   solicitud.monto_aprobado as monto_aprobado,
                   solicitud.numero as solicitud_numero,
                   case when actividad.plazo_ciclo = 'C' then 'Corto Plazo' else  'Largo Plazo' end AS plazo,
                   case when empresa.nombre is null then persona.primer_nombre || ' ' || persona.primer_apellido else empresa.nombre end AS nombre,
                   programa.id AS programa_id,
                   programa.nombre AS programa_nombre,
                   programa.tipo_credito_id AS programa_tipo_credito_id,
                   rubro.nombre AS partida_nombre,
                   sub_rubro.nombre AS sub_rubro_nombre,
                    actividad.nombre AS actividad_nombre
            FROM
                 prestamo 
                  INNER JOIN solicitud on (prestamo.solicitud_id = solicitud.id)
                  INNER JOIN cliente ON  (cliente.id = solicitud.cliente_id)
                  left JOIN public.empresa empresa ON (cliente.empresa_id = empresa.id)
                  left JOIN public.persona persona ON (cliente.persona_id = persona.id)
                  INNER JOIN public.programa programa ON (solicitud.programa_id = programa.id)
                  INNER JOIN public.rubro rubro ON (prestamo.rubro_id = rubro.id)
                  INNER JOIN public.sub_rubro sub_rubro ON (prestamo.sub_rubro_id = sub_rubro.id)
                  INNER JOIN public.actividad actividad ON (prestamo.actividad_id = actividad.id)
            WHERE
                 prestamo.estatus not in ('C', 'L', 'S')
            ORDER BY
              programa_nombre,
              actividad.plazo_ciclo,
              partida_nombre,
              nombre;
              
      COMMENT ON VIEW view_cartera_programa_plazo IS 'Cartera vigente y vencida por programa y plazo';
    "
  end

  def down
  
    execute " 
      DROP VIEW IF EXISTS view_cartera_programa_plazo;
    "
  end
end
