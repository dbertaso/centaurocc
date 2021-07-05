# encoding: utf-8

class AddColumnsTablaEstatus < ActiveRecord::Migration

  def change

    execute "


      DROP VIEW if exists view_configuracion_avance;
    
      DROP VIEW if exists view_gestionar_garantias;
      DROP VIEW if exists view_actualizar_cartera_tabla;
      DROP VIEW if exists view_apertura_cuenta;
      DROP VIEW if exists view_asignar_maquinaria;
      DROP VIEW if exists view_configuracion_reverso;
      DROP VIEW if exists view_consulta_evento;
      DROP VIEW if exists view_detalle_compromiso;
      DROP VIEW if exists view_envio_maquinaria;
      DROP VIEW if exists view_liquidacion_maquinaria_equipo;
      DROP VIEW if exists view_list_orden_despacho;
      DROP VIEW if exists view_list_orden_despacho_consulta;
      DROP VIEW if exists view_list_orden_despacho_insumo;
      DROP VIEW if exists view_list_solicitud;
      DROP VIEW if exists view_solicitud_pre_evaluacion;
      DROP VIEW if exists view_solicitud_resguardo;

      ALTER TABLE estatus ADD COLUMN activo boolean DEFAULT false;
      ALTER TABLE estatus ALTER COLUMN nombre TYPE text;

      CREATE OR REPLACE VIEW view_solicitud_resguardo AS 
               SELECT s.id AS solicitud_id, s.numero, e.id AS cliente_numero, 
                  e.rif AS cedula_rif, e.nombre, es.nombre AS estatus, 
                  s.monto_solicitado, p.nombre AS programa, est.id AS estado_id, 
                  est.nombre AS estado, 
                  (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, 
                  s.estatus_id, s.liberada, s.usuario_resguardo, es.const_id, 
                  s.consultoria, s.decision_final AS avaluo, 
                  s.confirmacion AS resguardo, 
                      CASE
                          WHEN sr.completado > 0 THEN sr.completado
                          ELSE 0
                      END AS completado, 
                      CASE
                          WHEN sr.completado_resguardo > 0 THEN sr.completado_resguardo
                          ELSE 0
                      END AS completado_resguardo, 
                  s.oficina_id
                 FROM solicitud s
            JOIN cliente c ON c.id = s.cliente_id
         JOIN empresa e ON e.id = c.empresa_id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN programa p ON p.id = s.programa_id
         JOIN municipio m ON m.id = s.municipio_id
         JOIN estado est ON est.id = m.estado_id
         LEFT JOIN usuario u ON s.usuario_resguardo::text = u.nombre_usuario::text
         LEFT JOIN solicitud_resguardo sr ON s.id = sr.solicitud_id
      UNION 
               SELECT s.id AS solicitud_id, s.numero, per.id AS cliente_numero, 
                  per.cedula || ''::text AS cedula_rif, 
                  (per.primer_nombre::text || ' '::text) || per.primer_apellido::text AS nombre, 
                  es.nombre AS estatus, s.monto_solicitado, p.nombre AS programa, 
                  est.id AS estado_id, est.nombre AS estado, 
                  (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, 
                  s.estatus_id, s.liberada, s.usuario_resguardo, es.const_id, 
                  s.consultoria, s.decision_final AS avaluo, 
                  s.confirmacion AS resguardo, 
                      CASE
                          WHEN sr.completado > 0 THEN sr.completado
                          ELSE 0
                      END AS completado, 
                      CASE
                          WHEN sr.completado_resguardo > 0 THEN sr.completado_resguardo
                          ELSE 0
                      END AS completado_resguardo, 
                  s.oficina_id
                 FROM solicitud s
            JOIN cliente c ON c.id = s.cliente_id
         JOIN persona per ON per.id = c.persona_id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN programa p ON p.id = s.programa_id
         JOIN municipio m ON m.id = s.municipio_id
         JOIN estado est ON est.id = m.estado_id
         LEFT JOIN usuario u ON s.usuario_resguardo::text = u.nombre_usuario::text
         LEFT JOIN solicitud_resguardo sr ON s.id = sr.solicitud_id;

      CREATE OR REPLACE VIEW view_solicitud_pre_evaluacion AS 
               SELECT s.id AS solicitud_id, s.numero, e.id AS cliente_numero, 
                  e.rif AS cedula_rif, e.nombre, es.nombre AS estatus, 
                  s.monto_solicitado, p.nombre AS programa, est.id AS estado_id, 
                  est.nombre AS estado, 
                  (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, 
                  s.estatus_id, s.liberada, s.usuario_pre_evaluacion, es.const_id, 
                  s.consultoria, s.decision_final, s.confirmacion, s.oficina_id, 
                  s.sector_id, sec.nombre AS sector, s.sub_sector_id, 
                  sub.nombre AS sub_sector, s.rubro_id, r.nombre AS rubro, 
                  up.nombre AS unidad_produccion, up.municipio_id, 
                  m.nombre AS municipio, up.parroquia_id, pa.nombre AS parroquia, 
                  s.sub_rubro_id, sr.nombre AS sub_rubro, s.actividad_id, 
                  a.nombre AS actividad
                 FROM solicitud s
            JOIN cliente c ON c.id = s.cliente_id
         JOIN empresa e ON e.id = c.empresa_id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN programa p ON p.id = s.programa_id
         JOIN sector sec ON sec.id = s.sector_id
         JOIN sub_sector sub ON sub.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id
         JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
         JOIN actividad a ON a.id = s.actividad_id
         LEFT JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
         LEFT JOIN municipio m ON m.id = up.municipio_id
         LEFT JOIN parroquia pa ON pa.id = up.parroquia_id
         LEFT JOIN estado est ON est.id = m.estado_id
         LEFT JOIN usuario u ON s.usuario_pre_evaluacion::text = u.nombre_usuario::text
      UNION 
               SELECT s.id AS solicitud_id, s.numero, per.id AS cliente_numero, 
                  ((per.cedula_nacionalidad::text || ' '::text) || per.cedula) || ''::text AS cedula_rif, 
                  (per.primer_nombre::text || ' '::text) || per.primer_apellido::text AS nombre, 
                  es.nombre AS estatus, s.monto_solicitado, p.nombre AS programa, 
                  est.id AS estado_id, est.nombre AS estado, 
                  (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, 
                  s.estatus_id, s.liberada, s.usuario_pre_evaluacion, es.const_id, 
                  s.consultoria, s.decision_final, s.confirmacion, s.oficina_id, 
                  s.sector_id, sec.nombre AS sector, s.sub_sector_id, 
                  sub.nombre AS sub_sector, s.rubro_id, r.nombre AS rubro, 
                  up.nombre AS unidad_produccion, up.municipio_id, 
                  m.nombre AS municipio, up.parroquia_id, pa.nombre AS parroquia, 
                  s.sub_rubro_id, sr.nombre AS sub_rubro, s.actividad_id, 
                  a.nombre AS actividad
                 FROM solicitud s
            JOIN cliente c ON c.id = s.cliente_id
         JOIN persona per ON per.id = c.persona_id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN programa p ON p.id = s.programa_id
         JOIN sector sec ON sec.id = s.sector_id
         JOIN sub_sector sub ON sub.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id
         JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
         JOIN actividad a ON a.id = s.actividad_id
         LEFT JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
         LEFT JOIN municipio m ON m.id = up.municipio_id
         LEFT JOIN parroquia pa ON pa.id = up.parroquia_id
         LEFT JOIN estado est ON est.id = m.estado_id
         LEFT JOIN usuario u ON s.usuario_pre_evaluacion::text = u.nombre_usuario::text;

      CREATE OR REPLACE VIEW view_list_solicitud AS 
       SELECT s.id AS solicitud_id, s.fecha_solicitud, s.numero, 
          c.id AS cliente_numero, 
              CASE
                  WHEN e.rif IS NULL THEN ((per.cedula_nacionalidad::text || '-'::text) || per.cedula::text)::character varying
                  ELSE e.rif
              END AS cedula_rif, 
              CASE
                  WHEN e.nombre IS NULL THEN 
                  CASE
                      WHEN per.primer_nombre IS NULL THEN ('Sin Primer nombre'::text || ' '::text) || 
                      CASE
                          WHEN per.primer_apellido IS NULL THEN 'Sin Primer Apellido'::character varying
                          ELSE per.primer_apellido
                      END::text
                      ELSE (per.primer_nombre::text || ' '::text) || 
                      CASE
                          WHEN per.primer_apellido IS NULL THEN 'Sin Primer Apellido'::character varying
                          ELSE per.primer_apellido
                      END::text
                  END::character varying
                  ELSE e.nombre
              END AS nombre, 
          r.nombre AS rubro, es.nombre AS estatus, s.monto_solicitado, 
          p.nombre AS programa, p.id AS programa_id, p.moneda_id, 
          su.nombre AS sub_sector, s.estatus_id, s.liberada, s.transcriptor, 
          es.const_id, s.oficina_id, se.nombre AS sector, s.sector_id, 
          s.sub_sector_id, s.rubro_id, s.consultoria, s.sub_rubro_id, 
          sr.nombre AS sub_rubro, s.actividad_id, a.nombre AS actividad, 
          est.nombre AS estado, ci.estado_id, o.nombre AS oficina
         FROM solicitud s
         JOIN cliente c ON c.id = s.cliente_id
         LEFT JOIN empresa e ON e.id = c.empresa_id
         LEFT JOIN persona per ON per.id = c.persona_id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN programa p ON p.id = s.programa_id
         JOIN moneda mon ON mon.id = p.moneda_id
         JOIN sector se ON se.id = s.sector_id
         JOIN sub_sector su ON su.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id
         JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
         JOIN actividad a ON a.id = s.actividad_id
         JOIN oficina o ON o.id = s.oficina_id
         JOIN ciudad ci ON ci.id = o.ciudad_id
         JOIN estado est ON est.id = ci.estado_id;

      CREATE OR REPLACE VIEW view_list_orden_despacho_insumo AS 
       SELECT DISTINCT ON ((sol.numero::text || '^'::text) || fac_or_des.numero_factura::text) ode.prestamo_id AS prestamo, 
          cli.id AS cliente_id, fac_or_des.numero_factura, 
              CASE
                  WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
                  ELSE emp.nombre
              END AS nombre, 
              CASE
                  WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
                  ELSE emp.rif
              END AS cedula_rif, 
          sol.numero::text AS numero, sol.id AS solicitud_id, 
          ode.id AS orden_despacho_id, r.nombre AS rubro, es.nombre AS estatus, 
          sol.monto_solicitado, pr.nombre AS programa, su.nombre AS sub_sector, 
          ode.estatus_id, sol.liberada, sol.transcriptor, casa_prov.tipo_cuenta, 
          casa_prov.numero_cuenta, casa_prov.entidad_financiera_id, sol.oficina_id, 
          se.nombre AS sector, sol.sector_id, sol.sub_sector_id, sol.rubro_id, 
          sol.consultoria, mu.nombre AS municipio, pa.nombre AS parroquia, 
          est.nombre AS estado, est.id AS estado_id, ode.monto, 
          fac_or_des.numero_factura AS num_factura, fac_or_des.fecha_factura, 
          ode.fecha_orden_despacho AS fecha_orden, 
          fac_or_des.casa_proveedora_id AS casa_proveedora, 
          casa_prov.tipo_pago AS tipo_pago_casa_proveedora, acti.id AS actividad_id, 
          sub_r.id AS sub_rubro_id, vmtf.monto_total_factura, 
          (sol.numero::text || '^'::text) || fac_or_des.numero_factura::text AS identificador
         FROM factura_orden_despacho fac_or_des
         LEFT JOIN view_monto_total_factura vmtf ON fac_or_des.numero_factura::text = vmtf.numero_factura::text
         JOIN casa_proveedora casa_prov ON casa_prov.id = fac_or_des.casa_proveedora_id
         LEFT JOIN orden_despacho_detalle odsd ON odsd.id = fac_or_des.orden_despacho_detalle_id
         LEFT JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id AND ode.id = vmtf.orden_despacho_id
         LEFT JOIN solicitud sol ON ode.solicitud_id = sol.id
         JOIN programa pr ON pr.id = sol.programa_id
         JOIN cliente cli ON sol.cliente_id = cli.id
         LEFT JOIN empresa emp ON cli.empresa_id = emp.id
         LEFT JOIN persona per ON cli.persona_id = per.id
         LEFT JOIN cuenta_bancaria cuenta_ban ON cli.id = cuenta_ban.cliente_id
         JOIN estatus es ON es.id = sol.estatus_id
         JOIN sector se ON se.id = sol.sector_id
         JOIN sub_sector su ON su.id = sol.sub_sector_id
         JOIN rubro r ON r.id = sol.rubro_id
         JOIN sub_rubro sub_r ON sol.sub_rubro_id = sub_r.id
         JOIN actividad acti ON sol.actividad_id = acti.id
         JOIN unidad_produccion up ON up.id = sol.unidad_produccion_id
         JOIN municipio mu ON mu.id = up.municipio_id
         JOIN parroquia pa ON pa.id = up.parroquia_id
         JOIN estado est ON est.id = mu.estado_id
        WHERE fac_or_des.confirmada = true AND fac_or_des.emitida = true AND fac_or_des.factura_estatus_id <> 10070 AND (sol.estatus_id = ANY (ARRAY[10090, 10070, 10110, 10100, 10057, 10060]))
        ORDER BY (sol.numero::text || '^'::text) || fac_or_des.numero_factura::text DESC;

      CREATE OR REPLACE VIEW view_list_orden_despacho_consulta AS 
       SELECT DISTINCT ON (ode.id) ode.prestamo_id AS prestamo, cli.id AS cliente_id, 
          fac_or_des.numero_factura, 
              CASE
                  WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
                  ELSE emp.nombre
              END AS nombre, 
              CASE
                  WHEN sol.estatus_id = 10130 THEN 
                  CASE
                      WHEN prest.monto_insumos = prest.monto_despachado THEN 'NO VA'::text
                      ELSE ''::text
                  END
                  ELSE ''::text
              END AS no_va, 
              CASE
                  WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
                  ELSE emp.rif
              END AS cedula_rif, 
          sol.numero::text AS numero, sol.id AS solicitud_id, 
          ode.id AS orden_despacho_id, r.nombre AS rubro, es.nombre AS estatus, 
          es.id AS estatus_tramite_id, sol.monto_solicitado, su.nombre AS sub_sector, 
          ode.estatus_id, sol.oficina_id, se.nombre AS sector, sol.sector_id, 
          sol.sub_sector_id, sol.rubro_id, seg_vis.codigo_visita, 
          seg_vis.fecha_visita, ode.monto, ode.fecha_orden_despacho AS fecha_orden, 
          acti.id AS actividad_id, sub_r.id AS sub_rubro_id, sol.moneda_id
         FROM factura_orden_despacho fac_or_des
         LEFT JOIN orden_despacho_detalle odsd ON odsd.id = fac_or_des.orden_despacho_detalle_id
         LEFT JOIN orden_despacho ode ON odsd.orden_despacho_id = ode.id
         LEFT JOIN solicitud sol ON ode.solicitud_id = sol.id
         LEFT JOIN prestamo prest ON prest.solicitud_id = sol.id
         JOIN seguimiento_visita seg_vis ON seg_vis.solicitud_id = sol.id
         JOIN cliente cli ON sol.cliente_id = cli.id
         LEFT JOIN empresa emp ON cli.empresa_id = emp.id
         LEFT JOIN persona per ON cli.persona_id = per.id
         JOIN estatus es ON es.id = sol.estatus_id
         JOIN sector se ON se.id = sol.sector_id
         JOIN sub_sector su ON su.id = sol.sub_sector_id
         JOIN rubro r ON r.id = sol.rubro_id
         JOIN sub_rubro sub_r ON sol.sub_rubro_id = sub_r.id
         JOIN actividad acti ON sol.actividad_id = acti.id
        WHERE fac_or_des.confirmada = true AND fac_or_des.emitida = true AND (sol.estatus_id <> ALL (ARRAY[10140, 10150, 10130]));

      CREATE OR REPLACE VIEW view_list_orden_despacho AS 
       SELECT s.id AS solicitud_id, 
              CASE
                  WHEN e.nombre IS NULL THEN ((p.primer_nombre::text || ' '::text) || p.primer_apellido::text)::character varying
                  ELSE e.nombre
              END AS nombre, 
              CASE
                  WHEN s.estatus_id = 10130 THEN 
                  CASE
                      WHEN prest.monto_insumos = prest.monto_despachado THEN 'NO VA'::text
                      ELSE ''::text
                  END
                  ELSE ''::text
              END AS no_va, 
              CASE
                  WHEN e.rif IS NULL THEN ((p.cedula_nacionalidad::text || ' '::text) || p.cedula::text)::character varying
                  ELSE e.rif
              END AS cedula_rif, 
          s.numero, r.nombre AS rubro, es.nombre AS estatus, s.monto_solicitado, 
          pr.nombre AS programa, s.programa_id, su.nombre AS sub_sector, 
          or_des.estatus_id, s.transcriptor, s.oficina_id, se.nombre AS sector, 
          s.sector_id, s.sub_sector_id, s.rubro_id, s.consultoria, 
          mu.nombre AS municipio, pa.nombre AS parroquia, est.nombre AS estado, 
          est.id AS estado_id, 
              CASE
                  WHEN cp.nombre IS NULL THEN 'N/A'::character varying
                  ELSE cp.nombre
              END AS ciclo, 
              CASE
                  WHEN cp.id IS NULL THEN 0
                  ELSE cp.id
              END AS ciclo_id, 
          or_des.id AS orden_despacho_id, or_des.fecha_orden_despacho, or_des.monto, 
          acti.id AS actividad_id, sub_r.id AS sub_rubro_id, s.moneda_id
         FROM cliente c
         LEFT JOIN empresa e ON c.empresa_id = e.id
         LEFT JOIN persona p ON c.persona_id = p.id
         JOIN solicitud s ON s.cliente_id = c.id
         LEFT JOIN prestamo prest ON prest.solicitud_id = s.id
         JOIN estatus es ON es.id = s.estatus_id
         JOIN prestamo pres ON pres.solicitud_id = s.id
         JOIN programa pr ON pr.id = s.programa_id
         JOIN sector se ON se.id = s.sector_id
         JOIN sub_sector su ON su.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id
         JOIN sub_rubro sub_r ON s.sub_rubro_id = sub_r.id
         JOIN actividad acti ON s.actividad_id = acti.id
         JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
         JOIN municipio mu ON mu.id = up.municipio_id
         JOIN parroquia pa ON pa.id = up.parroquia_id
         JOIN estado est ON est.id = mu.estado_id
         LEFT JOIN ciclo_productivo cp ON cp.id = acti.ciclo_productivo_id
         JOIN oficina ofi ON ofi.id = s.oficina_id
         JOIN orden_despacho or_des ON s.id = or_des.solicitud_id
         JOIN seguimiento_visita seg_vi ON seg_vi.id = or_des.seguimiento_visita_id AND seg_vi.confirmada = true
        WHERE (c.empresa_id IS NOT NULL OR c.persona_id IS NOT NULL) AND (s.estatus_id <> ALL (ARRAY[10140, 10150, 10130]));

      CREATE OR REPLACE VIEW view_liquidacion_maquinaria_equipo AS 
       SELECT s.id AS solicitud_id, s.cliente_id, s.numero AS numero_tramite, 
          s.fecha_solicitud, s.fecha_registro, s.monto_aprobado, s.estatus, 
          s.estatus_id, s.oficina_id, s.sector_id, s.sub_sector_id, s.rubro_id, 
          s.por_inventario, s.conf_maquinaria, s.sub_rubro_id, s.actividad_id, 
          p.id AS prestamo_id, p.numero AS prestamo_numero, o.id AS oficina, 
          o.nombre AS nombre_oficina, m.id AS municipio, m.nombre AS municipio_nombre, 
          e.id AS estado, e.nombre AS estado_nombre, est.nombre AS estatus_tramite, 
          sec.nombre AS nombre_sector, sub.nombre AS nombre_sub_sector, 
          r.nombre AS nombre_rubro, 
              CASE
                  WHEN empresa.nombre IS NULL THEN ((btrim(persona.primer_nombre::text) || ' '::text) || btrim(persona.primer_apellido::text))::character varying
                  ELSE empresa.nombre
              END AS nombre_beneficiario, 
              CASE
                  WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::character varying::text)::character varying
                  ELSE empresa.rif
              END AS documento_beneficiario
         FROM solicitud s
         JOIN prestamo p ON s.id = p.solicitud_id
         JOIN cliente ON s.cliente_id = cliente.id
         LEFT JOIN empresa ON cliente.empresa_id = empresa.id
         LEFT JOIN persona ON cliente.persona_id = persona.id
         JOIN oficina o ON o.id = s.oficina_id
         JOIN municipio m ON m.id = o.municipio_id
         JOIN estado e ON e.id = m.estado_id
         JOIN estatus est ON est.id = s.estatus_id
         JOIN sector sec ON sec.id = s.sector_id
         JOIN sub_sector sub ON sub.id = s.sub_sector_id
         JOIN rubro r ON r.id = s.rubro_id;

      CREATE OR REPLACE VIEW view_envio_maquinaria AS 
       SELECT DISTINCT s.id AS solicitud_id, s.numero AS nro_tramite, 
          s.unidad_produccion_id, s.estatus_id, clie.id AS cliente_id, 
          s.por_inventario, s.fecha_solicitud, s.oficina_id, 
              CASE
                  WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
                  ELSE empresa.rif
              END AS cedula_rif, 
              CASE
                  WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
                  ELSE empresa.nombre
              END AS productor, 
          up.nombre AS unidad_produccion, up.direccion AS unidad_produccion_direccion, 
          est.nombre AS estado, est.id AS estado_id, mun.nombre AS municipio, 
          mun.id AS municipio_id, par.id AS parroquia_id, par.nombre AS parroquia, 
          st.nombre AS estatus, 
          (ofi.primer_nombre_supervisor::text || ' '::text) || ofi.primer_apellido_supervisor::text AS encargado, 
              CASE
                  WHEN (( SELECT DISTINCT empresa_telefono.id
                     FROM empresa_telefono
                    WHERE empresa_telefono.empresa_id = empresa.id)) IS NULL THEN ((( SELECT (persona_telefono.codigo::text || '-'::text) || persona_telefono.numero::text AS telefono
                     FROM persona_telefono
                    WHERE persona_telefono.persona_id = persona.id
                   LIMIT 1))::character varying)::text
                  ELSE ( SELECT DISTINCT (empresa_telefono.codigo::text || '-'::text) || empresa_telefono.numero::text AS telefono
                     FROM empresa_telefono
                    WHERE empresa_telefono.empresa_id = empresa.id
                   LIMIT 1)
              END AS telefono, 
              CASE
                  WHEN s.estatus_id = 10040 THEN true
                  WHEN s.estatus_id = 10095 THEN true
                  WHEN s.estatus_id = 10048 THEN true
                  WHEN s.estatus_id = 10090 THEN true
                  ELSE false
              END AS estatus_solicitud
         FROM solicitud s
         JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
         JOIN municipio mun ON mun.id = up.municipio_id
         JOIN estado est ON est.id = mun.estado_id
         JOIN parroquia par ON par.id = up.parroquia_id
         JOIN cliente clie ON clie.id = s.cliente_id
         LEFT JOIN persona ON clie.persona_id = persona.id
         LEFT JOIN empresa ON clie.empresa_id = empresa.id
         JOIN estatus st ON s.estatus_id = st.id
         JOIN oficina ofi ON s.oficina_id = ofi.id
        WHERE (s.estatus_id = ANY (ARRAY[10040, 10095, 10048, 10090])) AND (s.id IN ( SELECT solicitud_maquinaria.solicitud_id
         FROM solicitud_maquinaria
        WHERE solicitud_maquinaria.estatus::text = 'I'::text))
        ORDER BY s.estatus_id;

      CREATE OR REPLACE VIEW view_detalle_compromiso AS 
       SELECT ofi.nombre AS oficina, esta.nombre AS estado, 
          sec.nombre AS \"Nombre Sector\", ssec.nombre AS \"Nombre Sub Sector\", 
          rub.nombre AS \"Nombre Rubro\", srub.nombre AS \"Nombre Sub Rubro\", 
          sol.numero AS \"Numero Solicitud\", pre.numero AS \"Numero Prestamo\", 
              CASE
                  WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || '-'::text) || per.cedula::character varying::text)::character varying
                  ELSE emp.rif
              END AS documento, 
              CASE
                  WHEN emp.nombre IS NULL THEN ((((((
                  CASE
                      WHEN per.primer_apellido IS NULL THEN ' '::character varying
                      ELSE per.primer_apellido
                  END::text || ' '::text) || 
                  CASE
                      WHEN per.segundo_apellido IS NULL THEN ' '::character varying
                      ELSE per.segundo_apellido
                  END::text) || ' '::text) || 
                  CASE
                      WHEN per.primer_nombre IS NULL THEN ' '::character varying
                      ELSE per.primer_nombre
                  END::text) || ' '::text) || 
                  CASE
                      WHEN per.segundo_nombre IS NULL THEN ' '::character varying
                      ELSE per.segundo_nombre
                  END::text)::character varying
                  ELSE emp.nombre
              END AS \"Nombre Beneficiario\", 
          est.nombre AS estatus, pre.monto_banco, pre.monto_insumos, 
          pre.monto_sras_total, pre.monto_gasto_total, 
          pre.monto_banco + pre.monto_insumos + pre.monto_sras_total + pre.monto_gasto_total AS \"Compromiso\"
         FROM solicitud sol
         JOIN oficina ofi ON sol.oficina_id = ofi.id
         JOIN municipio mun ON ofi.municipio_id = mun.id
         JOIN estado esta ON mun.estado_id = esta.id
         JOIN sector sec ON sol.sector_id = sec.id
         JOIN sub_sector ssec ON sol.sub_sector_id = ssec.id
         JOIN rubro rub ON sol.rubro_id = rub.id
         JOIN sub_rubro srub ON sol.sub_rubro_id = srub.id
         JOIN prestamo pre ON sol.id = pre.solicitud_id
         JOIN cliente cli ON sol.cliente_id = cli.id
         LEFT JOIN persona per ON per.id = cli.persona_id
         LEFT JOIN empresa emp ON emp.id = cli.empresa_id
         JOIN estatus est ON est.id = sol.estatus_id
        WHERE sol.estatus_id = ANY (ARRAY[10033, 10034, 10040, 10045, 10048, 10050, 10055, 10057, 10060, 10070, 10080, 10085, 10100, 10110])
        ORDER BY est.id, srub.nombre;

      CREATE OR REPLACE VIEW view_consulta_evento AS 
       SELECT control_solicitud.solicitud_id, control_solicitud.accion AS accion2, 
          control_solicitud.fecha AS fecha_evento, 
          estatus_origen.nombre AS estatus_origen, 
          estatus_destino.nombre AS estatus_destino, 
              CASE
                  WHEN diferimiento_renuncia.causa_diferimiento_id IS NOT NULL THEN 'Diferimiento'::text
                  WHEN diferimiento_renuncia.causa_renuncia_id IS NOT NULL THEN 'Renuncia'::text
                  WHEN control_solicitud.estatus_id < control_solicitud.estatus_origen_id THEN 'Deshacer'::text
                  ELSE 'Avance'::text
              END AS accion, 
          control_solicitud.comentario AS observacion, 
          usuario.nombre_usuario AS cuenta_usuario
         FROM control_solicitud
         LEFT JOIN diferimiento_renuncia ON diferimiento_renuncia.control_solicitud_id = control_solicitud.id
         LEFT JOIN estatus estatus_origen ON estatus_origen.id = control_solicitud.estatus_origen_id
         LEFT JOIN estatus estatus_destino ON estatus_destino.id = control_solicitud.estatus_id
         JOIN usuario ON usuario.id = control_solicitud.usuario_id;

      CREATE OR REPLACE VIEW view_configuracion_reverso AS 
       SELECT conf.estatus_origen_id, conf.estatus_destino_id, 
          origen.area AS area_origen, destino.area AS area_destino
         FROM configuracion_reverso conf, estatus origen, estatus destino
        WHERE conf.estatus_origen_id = origen.id AND conf.estatus_destino_id = destino.id;

      CREATE OR REPLACE VIEW view_asignar_maquinaria AS 
               SELECT s.id AS solicitud_id, s.numero, 
                  (p.primer_nombre::text || ' '::text) || p.primer_apellido::text AS beneficiario, 
                  p.cedula || ''::text AS cedula_rif, es.nombre::text AS estatus, 
                  e.nombre AS estado, m.nombre AS municipio, pa.nombre AS parroquia, 
                  u.nombre AS unidad_produccion, u.municipio_id, m.estado_id, 
                  u.parroquia_id
                 FROM solicitud s
            JOIN estatus es ON es.id = s.estatus_id AND es.const_id::text = 'ST0006'::text
         JOIN cliente c ON c.id = s.cliente_id
         JOIN persona p ON p.id = c.persona_id
         JOIN unidad_produccion u ON u.id = s.unidad_produccion_id
         JOIN municipio m ON m.id = u.municipio_id
         JOIN estado e ON e.id = m.estado_id
         JOIN parroquia pa ON pa.id = u.parroquia_id
         JOIN sub_sector ss ON ss.id = s.sub_sector_id AND ss.nemonico::text = 'MA'::text
      UNION 
               SELECT s.id AS solicitud_id, s.numero, em.nombre AS beneficiario, 
                  em.rif AS cedula_rif, es.nombre::text AS estatus, 
                  e.nombre AS estado, m.nombre AS municipio, pa.nombre AS parroquia, 
                  u.nombre AS unidad_produccion, u.municipio_id, m.estado_id, 
                  u.parroquia_id
                 FROM solicitud s
            JOIN estatus es ON es.id = s.estatus_id AND es.const_id::text = 'ST0006'::text
         JOIN cliente c ON c.id = s.cliente_id
         JOIN empresa em ON em.id = c.empresa_id
         JOIN unidad_produccion u ON u.id = s.unidad_produccion_id
         JOIN municipio m ON m.id = u.municipio_id
         JOIN estado e ON e.id = m.estado_id
         JOIN parroquia pa ON pa.id = u.parroquia_id
         JOIN sub_sector ss ON ss.id = s.sub_sector_id AND ss.nemonico::text = 'MA'::text;

      CREATE OR REPLACE VIEW view_apertura_cuenta AS 
               SELECT DISTINCT s.id AS solicitud_id, s.numero AS numero_solicitud, 
                  s.estatus_id, s.control, c.tipo_cliente_id, 
                  ((p.primer_nombre::text || ' '::text) || ' '::text) || p.primer_apellido::text AS nombre, 
                  (p.cedula_nacionalidad::text || ' '::text) || p.cedula::character varying::text AS cedula_rif, 
                      CASE
                          WHEN e.nombre IS NULL THEN 'SIN CUENTA'::character varying
                          ELSE e.nombre
                      END AS entidad_financiera, 
                      CASE
                          WHEN e.id IS NULL THEN 0
                          ELSE e.id
                      END AS entidad_financiera_id, 
                      CASE
                          WHEN a.id IS NULL THEN 0
                          ELSE a.id
                      END AS agencia_bancaria_id, 
                      CASE
                          WHEN m.estado_id IS NULL THEN 0
                          ELSE m.estado_id
                      END AS estado_id, 
                      CASE
                          WHEN a.codigo IS NULL THEN '0'::character varying
                          ELSE a.codigo
                      END AS oficina, 
                      CASE
                          WHEN a.nombre IS NULL THEN 'SIN AGENCIA'::character varying
                          ELSE a.nombre
                      END AS nombre_agencia, 
                  es.nombre AS status, 
                      CASE
                          WHEN est.nombre IS NULL THEN 'SIN ESTADO'::character varying
                          ELSE est.nombre
                      END AS estado, 
                      CASE
                          WHEN m.nombre IS NULL THEN 'SIN MUNICIPIO'::character varying
                          ELSE m.nombre
                      END AS municipio, 
                      CASE
                          WHEN ci.nombre IS NULL THEN 'SIN CIUDAD'::character varying
                          ELSE ci.nombre
                      END AS ciudad
                 FROM solicitud s
            JOIN cliente c ON s.cliente_id = c.id
         JOIN persona p ON p.id = c.persona_id
         JOIN estatus es ON s.estatus_id = es.id
         JOIN unidad_produccion up ON s.unidad_produccion_id = up.id
         LEFT JOIN agencia_bancaria a ON a.ciudad_id = up.ciudad_id AND a.municipio_id = up.municipio_id
         LEFT JOIN municipio m ON m.id = up.municipio_id
         LEFT JOIN estado est ON est.id = m.estado_id
         LEFT JOIN ciudad ci ON ci.id = up.ciudad_id, entidad_financiera e
      UNION 
               SELECT DISTINCT s.id AS solicitud_id, s.numero AS numero_solicitud, 
                  s.estatus_id, s.control, c.tipo_cliente_id, em.alias AS nombre, 
                  em.rif AS cedula_rif, 
                      CASE
                          WHEN e.nombre IS NULL THEN 'SIN CUENTA'::character varying
                          ELSE e.nombre
                      END AS entidad_financiera, 
                      CASE
                          WHEN e.id IS NULL THEN 0
                          ELSE e.id
                      END AS entidad_financiera_id, 
                      CASE
                          WHEN a.id IS NULL THEN 0
                          ELSE a.id
                      END AS agencia_bancaria_id, 
                      CASE
                          WHEN m.estado_id IS NULL THEN 0
                          ELSE m.estado_id
                      END AS estado_id, 
                      CASE
                          WHEN a.codigo IS NULL THEN '0'::character varying
                          ELSE a.codigo
                      END AS oficina, 
                      CASE
                          WHEN a.nombre IS NULL THEN 'SIN AGENCIA'::character varying
                          ELSE a.nombre
                      END AS nombre_agencia, 
                  es.nombre AS status, 
                      CASE
                          WHEN est.nombre IS NULL THEN 'SIN ESTADO'::character varying
                          ELSE est.nombre
                      END AS estado, 
                      CASE
                          WHEN m.nombre IS NULL THEN 'SIN MUNICIPIO'::character varying
                          ELSE m.nombre
                      END AS municipio, 
                      CASE
                          WHEN ci.nombre IS NULL THEN 'SIN CIUDAD'::character varying
                          ELSE ci.nombre
                      END AS ciudad
                 FROM solicitud s
            JOIN cliente c ON s.cliente_id = c.id
         JOIN empresa em ON c.empresa_id = em.id
         JOIN estatus es ON s.estatus_id = es.id
         JOIN unidad_produccion up ON s.unidad_produccion_id = up.id
         LEFT JOIN agencia_bancaria a ON a.ciudad_id = up.ciudad_id AND a.municipio_id = up.municipio_id
         LEFT JOIN municipio m ON m.id = up.municipio_id
         LEFT JOIN estado est ON est.id = m.estado_id
         LEFT JOIN ciudad ci ON ci.id = up.ciudad_id, entidad_financiera e;

      CREATE OR REPLACE VIEW view_actualizar_cartera_tabla AS 
              ( SELECT s.id AS solicitud_id, s.numero AS numero_solicitud, 
                  pre.estatus AS prestamo_estatus, s.fecha_actual_estatus, 
                  s.estatus_desembolso_id, s.monto_solicitado, s.control, 
                  c.tipo_cliente_id, 
                  ((p.primer_nombre::text || ' '::text) || ' '::text) || p.primer_apellido::text AS nombre, 
                  p.cedula::character varying AS cedula_rif, c.entidad_financiera_id, 
                  m.estado_id, e.nombre AS estatus, s.programa_id, 
                  pr.alias AS programa, pre.numero AS numero_prestamo, 
                  pre.id AS prestamo_id, pre.estatus_desembolso, pre.tipo_cartera_id, 
                  p.sector_economico_id
                 FROM prestamo pre
            JOIN solicitud s ON s.id = pre.solicitud_id
         JOIN cliente c ON s.cliente_id = c.id
         JOIN estatus e ON s.estatus_id = e.id
         JOIN programa pr ON pr.id = s.programa_id
         JOIN persona p ON p.id = c.persona_id
         JOIN persona_direccion pd ON p.id = pd.persona_id
         JOIN municipio m ON pd.municipio_id = m.id
         JOIN tipo_cartera ON pre.tipo_cartera_id = tipo_cartera.id
        WHERE pre.estatus <> ALL (ARRAY['S'::bpchar, 'F'::bpchar, 'A'::bpchar])
        ORDER BY s.id, s.numero, s.estatus_desembolso_id, s.monto_solicitado, s.control, c.tipo_cliente_id, c.entidad_financiera_id, m.estado_id, e.nombre, s.programa_id, pr.alias, pre.numero, pre.id, pre.estatus_desembolso, s.fecha_actual_estatus, pre.tipo_cartera_id)
      UNION 
              ( SELECT DISTINCT s.id AS solicitud_id, s.numero AS numero_solicitud, 
                  pre.estatus AS prestamo_estatus, s.fecha_actual_estatus, 
                  s.estatus_desembolso_id, s.monto_solicitado, s.control, 
                  c.tipo_cliente_id, em.alias AS nombre, em.rif AS cedula_rif, 
                  c.entidad_financiera_id, m.estado_id, e.nombre AS estatus, 
                  s.programa_id, pr.alias AS programa, pre.numero AS numero_prestamo, 
                  pre.id AS prestamo_id, pre.estatus_desembolso, pre.tipo_cartera_id, 
                  em.sector_economico_id
                 FROM prestamo pre
            JOIN solicitud s ON s.id = pre.solicitud_id
         JOIN cliente c ON s.cliente_id = c.id
         JOIN empresa em ON c.empresa_id = em.id
         JOIN estatus e ON s.estatus_id = e.id
         JOIN programa pr ON pr.id = s.programa_id
         JOIN empresa_direccion ed ON em.id = ed.empresa_id
         JOIN municipio m ON ed.municipio_id = m.id
         JOIN tipo_cartera ON pre.tipo_cartera_id = tipo_cartera.id
        WHERE pre.estatus <> ALL (ARRAY['S'::bpchar, 'F'::bpchar, 'A'::bpchar])
        ORDER BY s.id, s.numero, s.estatus_desembolso_id, s.monto_solicitado, s.control, c.tipo_cliente_id, em.alias, em.rif, c.entidad_financiera_id, m.estado_id, e.nombre, s.programa_id, pr.alias, pre.numero, pre.id, pre.estatus_desembolso, s.fecha_actual_estatus, pre.tipo_cartera_id, em.sector_economico_id);

      CREATE VIEW view_configuracion_avance AS
      select
            ca.id,
            estatus_origen_id,
            eo.nombre as estatus_origen_nombre,
            estatus_destino_id,
            ed.nombre as estatus_destino_nombre,
            programa_id,
            programa.nombre as programa_nombre,
            ruta_primaria,
            condicionado
      from
            configuracion_avance ca
            inner join programa on (programa.id = ca.programa_id)
            inner join estatus eo on (eo.id = ca.estatus_origen_id)
            inner join estatus ed on (ed.id = ca.estatus_destino_id)
      where 
            estatus_origen_id > 9000;

      CREATE OR REPLACE VIEW view_gestionar_garantias AS 
      SELECT s.id AS solicitud_id, s.numero, s.monto_solicitado, s.estatus_id, 
      s.liberada, s.usuario_pre_evaluacion, s.consultoria, s.decision_final, 
      s.confirmacion, s.oficina_id, s.sector_id, s.sub_sector_id, s.rubro_id, 
      s.sub_rubro_id, s.actividad_id, 
          CASE
              WHEN e.id IS NULL THEN per.id
              ELSE e.id
          END AS cliente_numero, 
          CASE
              WHEN e.rif IS NULL THEN ((per.cedula_nacionalidad::text || '-'::text) || per.cedula::text)::character varying
              ELSE e.rif
          END AS cedula_rif, 
          CASE
              WHEN e.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
              ELSE e.nombre
          END AS nombre, 
      es.nombre AS estatus, es.const_id, p.nombre AS programa, 
      pr.numero AS financiamiento, est.id AS estado_id, est.nombre AS estado, 
      (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario, 
      sec.nombre AS sector, sub.nombre AS sub_sector, r.nombre AS rubro, 
      up.nombre AS unidad_produccion, up.municipio_id, up.parroquia_id, 
      m.nombre AS municipio, pa.nombre AS parroquia, sr.nombre AS sub_rubro, 
      a.nombre AS actividad, s.moneda_id, mon.nombre AS moneda
      FROM solicitud s
      JOIN cliente c ON c.id = s.cliente_id
      LEFT JOIN empresa e ON e.id = c.empresa_id
      LEFT JOIN persona per ON per.id = c.persona_id
      JOIN estatus es ON es.id = s.estatus_id
      JOIN programa p ON p.id = s.programa_id
      LEFT JOIN prestamo pr ON pr.solicitud_id = s.id
      JOIN sector sec ON sec.id = s.sector_id
      JOIN sub_sector sub ON sub.id = s.sub_sector_id
      JOIN rubro r ON r.id = s.rubro_id
      JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
      JOIN actividad a ON a.id = s.actividad_id
      JOIN moneda mon ON mon.id = s.moneda_id
      LEFT JOIN unidad_produccion up ON up.id = s.unidad_produccion_id
      LEFT JOIN municipio m ON m.id = up.municipio_id
      LEFT JOIN parroquia pa ON pa.id = up.parroquia_id
      LEFT JOIN estado est ON est.id = m.estado_id
      LEFT JOIN usuario u ON s.usuario_pre_evaluacion::text = u.nombre_usuario::text;

      insert into menu (nombre,
                      parent_id,
                      orden) 

                values 
                      ('Estatus/Rutas',
                        (select id from menu where nombre = 'General'),
                        5);  

      insert into opcion (nombre,
                        tiene_acciones,
                        ruta,
                        opcion_grupo_id) 
                  values 
                        ('Estatus',
                          true,
                          'basico/estatus',
                          3);

      insert into menu (nombre,
                      parent_id,
                      orden,
                      opcion_id) 

                values 
                      ('Estatus',
                        (select id from menu where nombre = 'Estatus/Rutas'),
                        1,
                        currval('opcion_id_seq'));   

      insert into opcion (nombre,
                        tiene_acciones,
                        ruta,
                        opcion_grupo_id) 
                  values 
                        ('Ruta Aprobación',
                          true,
                          'basico/configuracion_avance',
                          3);

      insert into menu (nombre,
                      parent_id,
                      orden,
                      opcion_id) 

                values 
                      ('Ruta Aprobación',
                        (select id from menu where nombre = 'Estatus/Rutas'),
                        2,
                        currval('opcion_id_seq'));   

      insert into opcion (nombre,
                        tiene_acciones,
                        ruta,
                        opcion_grupo_id) 
                  values 
                        ('Ruta Reverso',
                          true,
                          'basico/configuracion_reverso',
                          3);

      insert into menu (nombre,
                      parent_id,
                      orden,
                      opcion_id) 

                values 
                      ('Ruta Reverso',
                        (select id from menu where nombre = 'Estatus/Rutas'),
                        3,
                        currval('opcion_id_seq'));  


    "
  end

end
