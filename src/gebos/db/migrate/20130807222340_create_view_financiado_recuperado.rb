# encoding: utf-8

class CreateViewFinanciadoRecuperado < ActiveRecord::Migration
  def up
    
    execute "
      
        DROP VIEW if exists view_financiado_recuperado;

        CREATE OR REPLACE VIEW view_financiado_recuperado AS 
         SELECT solicitud.numero AS numero_tramite, prestamo.numero AS numero_financiamiento, 
                CASE
                    WHEN empresa.rif IS NULL THEN ((
                    CASE
                        WHEN persona.primer_nombre IS NULL THEN 'Falta Primer Nombre'::character varying
                        ELSE persona.primer_nombre
                    END::text || ' '::text) || 
                    CASE
                        WHEN persona.primer_apellido IS NULL THEN 'Falta Primer Apellido'::character varying
                        ELSE persona.primer_apellido
                    END::text)::character varying
                    ELSE 
                    CASE
                        WHEN empresa.nombre IS NULL THEN 'Falta Nombre Empresa'::character varying
                        ELSE empresa.nombre
                    END
                END AS nombre_beneficiario, 
                CASE
                    WHEN empresa.rif IS NULL THEN ((
                    CASE
                        WHEN persona.cedula_nacionalidad IS NULL THEN 'V'::character varying
                        ELSE persona.cedula_nacionalidad
                    END::text || '-'::text) || persona.cedula::character varying::text)::character varying
                    ELSE empresa.rif
                END AS documento_beneficiario, 
                estado.nombre AS estado_nombre,
                estado.id as estado_id,
                solicitud.sector_id, 
                sector.nombre AS sector_nombre, 
                solicitud.sub_sector_id, 
                sub_sector.nombre AS sub_sector_nombre, 
                solicitud.rubro_id, 
                rubro.nombre AS rubro_nombre, 
                solicitud.sub_rubro_id, 
                sub_rubro.nombre AS sub_rubro_nombre, 
                solicitud.actividad_id, 
                actividad.nombre AS actividad_nombre, 
                solicitud.programa_id, 
                programa.nombre AS programa_nombre, 
                prestamo.fecha_liquidacion, 
                plan_pago.fecha_fin AS fecha_vencimiento,
                solicitud.fecha_aprobacion,
                solicitud.monto_aprobado, 
                prestamo.monto_banco, 
                prestamo.monto_insumos, 
                prestamo.monto_liquidado AS monto_liquidado_banco, 
                prestamo.monto_banco - prestamo.monto_liquidado AS monto_por_liquidar_banco, 
                prestamo.monto_despachado AS monto_despachado_insumos, 
                prestamo.monto_insumos - prestamo.monto_despachado AS monto_por_despachar_insumos, 
                prestamo.monto_facturado as monto_facturado,
                prestamo.monto_inventario, prestamo.estatus AS estatus_financiamiento,
                prestamo.monto_sras_total as monto_sras_total,
                prestamo.monto_gasto_total as monto_gasto_total,

                case
                  when 
                    prestamo.monto_inventario is not null
                  then
                    case
                      when
                        prestamo.monto_inventario = 0
                      then
                        (prestamo.monto_banco + prestamo.monto_insumos + prestamo.monto_sras_total + prestamo.monto_gasto_total) 
                      else
                        (prestamo.monto_inventario + prestamo.monto_sras_total + prestamo.monto_gasto_total)
                      end
                  else
                    (prestamo.monto_banco + prestamo.monto_insumos + prestamo.monto_sras_total + prestamo.monto_gasto_total) 
                  end as total_financiamiento,
                      
                prestamo.cantidad_cuotas_vencidas, 
                prestamo.capital_vencido, 
                prestamo.interes_vencido,
                case
                  when prestamo.monto_mora is null
                    then 0.00
                    else prestamo.monto_mora
                end as monto_mora, 
                prestamo.saldo_insoluto AS saldo_deudor, 
                case
                  when prestamo.exigible is null
                    then 
                      0.00
                    else 
                      prestamo.exigible 
                end AS monto_exigible,
                case
                  when prestamo.deuda is null
                    then 0.00
                    else prestamo.deuda 
                end AS deuda_total, 
                prestamo.capital_pagado AS capital_recuperado, 
                CASE
                    WHEN prestamo.monto_banco = 0::numeric(16,2) AND prestamo.monto_insumos = 0::numeric(16,2) THEN 
                    CASE
                        WHEN prestamo.monto_inventario = 0::numeric(16,2) THEN 0::numeric(16,2)
                        ELSE (prestamo.capital_pagado / prestamo.monto_inventario * 100::numeric)::numeric(6,2)
                    END
                    ELSE (prestamo.capital_pagado / (prestamo.monto_liquidado + prestamo.monto_insumos) * 100::numeric)::numeric(6,2)
                END AS porcentaje_capital_recuperado, 
                prestamo.intereses_pagados AS interes_recuperado, 
                prestamo.remanente_por_aplicar AS excedente_por_pagar, 
                CASE
                    WHEN vepb.monto_excedente_pagado IS NULL THEN 0::numeric
                    ELSE vepb.monto_excedente_pagado
                END AS excedente_pagado
           FROM prestamo
           JOIN plan_pago ON prestamo.id = plan_pago.prestamo_id AND plan_pago.activo = true
           JOIN solicitud ON prestamo.solicitud_id = solicitud.id
           JOIN programa ON solicitud.programa_id = programa.id
           JOIN cliente ON solicitud.cliente_id = cliente.id
           LEFT JOIN view_excedente_pagado_beneficiario vepb ON vepb.prestamo_id = prestamo.id
           LEFT JOIN empresa ON cliente.empresa_id = empresa.id
           LEFT JOIN persona ON cliente.persona_id = persona.id
           JOIN sector ON solicitud.sector_id = sector.id
           JOIN sub_sector ON solicitud.sub_sector_id = sub_sector.id
           JOIN rubro ON solicitud.rubro_id = rubro.id
           JOIN sub_rubro ON solicitud.sub_rubro_id = sub_rubro.id
           JOIN actividad ON solicitud.actividad_id = actividad.id
           JOIN unidad_produccion up ON solicitud.unidad_produccion_id = up.id
           JOIN ciudad ON up.ciudad_id = ciudad.id
           JOIN estado ON ciudad.estado_id = estado.id;
      
      "
  end

  def down
  
    execute "
      
        DROP VIEW if exists view_financiado_recuperado;
    "
    
  end
end
