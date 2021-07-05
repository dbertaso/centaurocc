# encoding: utf-8

class UpdateViewsCalidadCarteraV2 < ActiveRecord::Migration
  def up
    
     execute "
    
        DROP VIEW if exists totalprestamosestadorubro;

        CREATE OR REPLACE VIEW totalprestamosestadorubro AS 
         SELECT count(prestamo.numero) AS cantidaprestamos, sum(prestamo.capital_vencido) AS cap_vencidopv, sum(prestamo.interes_vencido + prestamo.interes_diferido_vencido) AS int_vencidopv, rubro.id AS rubro_id, estado.id AS estado_id
           FROM prestamo prestamo
           JOIN solicitud solicitud ON solicitud.id = prestamo.solicitud_id
           JOIN rubro ON rubro.id = solicitud.rubro_id
           JOIN unidad_produccion up ON solicitud.unidad_produccion_id = up.id
           JOIN ciudad ON up.ciudad_id = ciudad.id
           JOIN estado ON ciudad.estado_id = estado.id
          WHERE prestamo.estatus in ('E', 'P')
          GROUP BY estado.id,rubro.id 
          ORDER BY estado.id,rubro.id;
        
        DROP VIEW if exists totalprestamosrubroestado;

        CREATE OR REPLACE VIEW totalprestamosrubroestado AS 
         SELECT count(prestamo.numero) AS cantidaprestamos, sum(prestamo.capital_vencido) AS cap_vencidopv, sum(prestamo.interes_vencido + prestamo.interes_diferido_vencido) AS int_vencidopv, rubro.id AS rubro_id, estado.id AS estado_id
           FROM prestamo prestamo
           JOIN solicitud solicitud ON solicitud.id = prestamo.solicitud_id
           JOIN rubro ON rubro.id = solicitud.rubro_id
           JOIN unidad_produccion up ON solicitud.unidad_produccion_id = up.id
           JOIN ciudad ON up.ciudad_id = ciudad.id
           JOIN estado ON ciudad.estado_id = estado.id
          WHERE prestamo.estatus in ('E', 'P')  GROUP BY rubro.id, estado.id
          ORDER BY rubro.id, estado.id;
          
        DROP VIEW if exists view_recuperacion_cartera;
        DROP VIEW if exists view_excedente_pagado_beneficiario;

        CREATE OR REPLACE VIEW view_excedente_pagado_beneficiario AS 
          SELECT orden_abono_excedente_arrime.prestamo_id, sum(orden_abono_excedente_arrime.monto_abono) AS monto_excedente_pagado
          FROM orden_abono_excedente_arrime
        WHERE orden_abono_excedente_arrime.estatus_id = ANY (ARRAY[30100, 30110])
        GROUP BY orden_abono_excedente_arrime.prestamo_id
        ORDER BY orden_abono_excedente_arrime.prestamo_id;

        CREATE OR REPLACE VIEW view_recuperacion_cartera AS 
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
                END AS documento_beneficiario, estado.nombre AS estado_nombre, solicitud.sector_id, sector.nombre AS sector_nombre, solicitud.sub_sector_id, sub_sector.nombre AS sub_sector_nombre, solicitud.rubro_id, rubro.nombre AS rubro_nombre, solicitud.sub_rubro_id, sub_rubro.nombre AS sub_rubro_nombre, solicitud.actividad_id, actividad.nombre AS actividad_nombre, solicitud.programa_id, programa.nombre AS programa_nombre, prestamo.fecha_liquidacion, plan_pago.fecha_fin AS fecha_vencimiento, solicitud.monto_aprobado, prestamo.monto_banco, prestamo.monto_insumos, prestamo.monto_liquidado AS monto_liquidado_banco, prestamo.monto_banco - prestamo.monto_liquidado AS monto_por_liquidar_banco, prestamo.monto_despachado AS monto_despachado_insumos, prestamo.monto_insumos - prestamo.monto_despachado AS monto_por_despachar_insumos, prestamo.estatus AS estatus_financiamiento, prestamo.cantidad_cuotas_vencidas, prestamo.capital_vencido, prestamo.interes_vencido, prestamo.monto_mora, prestamo.saldo_insoluto AS saldo_deudor, prestamo.exigible AS monto_exigible, prestamo.deuda AS deuda_total, prestamo.capital_pagado AS capital_recuperado, prestamo.intereses_pagados AS interes_recuperado, prestamo.remanente_por_aplicar AS excedente_por_pagar, plan_pago_cuota.fecha AS fecha_cuota, plan_pago_cuota.amortizado AS capital_recuperar, plan_pago_cuota.interes_corriente + plan_pago_cuota.interes_diferido AS interes_recuperar,
                       case when vepb.monto_excedente_pagado is null then 0 else vepb.monto_excedente_pagado end as excedente_pagado
           FROM prestamo
           JOIN plan_pago ON prestamo.id = plan_pago.prestamo_id AND plan_pago.activo = true
           JOIN plan_pago_cuota ON plan_pago_cuota.plan_pago_id = plan_pago.id
           JOIN solicitud ON prestamo.solicitud_id = solicitud.id
           JOIN programa ON solicitud.programa_id = programa.id
           JOIN cliente ON solicitud.cliente_id = cliente.id
           left join view_excedente_pagado_beneficiario vepb on vepb.prestamo_id = prestamo.id
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
  end
end
