create or replace function tabla_transaccion_prestamo(
  p_tablename varchar) returns bool as $$
declare
  _pg_type pg_type%rowtype;
  _sql_execute varchar;

begin

  select into _pg_type * from pg_type where typname = p_tablename || '_historico';

  if not found then
    
    _sql_execute = 'DROP VIEW if exists view_mega_sabana;'
      || 'create table ' || p_tablename || '_historico' || ' as select * from ' 
      || p_tablename || ' where false; '
      || 'alter table ' || p_tablename || '_historico'
      || ' add column ano integer, add column mes integer,'
      || 'ADD CONSTRAINT pk_prestamo_historico PRIMARY KEY(id, mes, ano),'
      || 'ADD CONSTRAINT prestamo_historico_fk_cliente FOREIGN KEY (cliente_id)
          REFERENCES cliente (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,'
      || 'ADD CONSTRAINT prestamo_historico_fk_solicitud FOREIGN KEY (solicitud_id)
          REFERENCES solicitud (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION;'
      || ' CREATE OR REPLACE VIEW view_mega_sabana AS 
           SELECT get_datos_cliente(prestamo_historico.cliente_id, ''tipo_organizacion''::character varying) AS tipo_organizacion, 
              get_datos_cliente(prestamo_historico.cliente_id, ''nombre''::character varying) AS nombre_organizacion, 
              get_datos_cliente(prestamo_historico.cliente_id, ''rif''::character varying) AS rif, 
              get_datos_cliente(prestamo_historico.cliente_id, ''beneficiario_nombre''::character varying) AS beneficiario_nombre, 
              get_datos_cliente(prestamo_historico.cliente_id, ''cedula''::character varying) AS cedula, 
              get_datos_cliente(prestamo_historico.cliente_id, ''capital_suscrito''::character varying) AS capital_suscrito, 
              get_datos_cliente(prestamo_historico.cliente_id, ''sector_economico''::character varying) AS sector_economico, 
              get_datos_cliente(prestamo_historico.cliente_id, ''estado''::character varying) AS estado, 
              get_datos_cliente(prestamo_historico.cliente_id, ''municipio''::character varying) AS municipio, 
              get_datos_cliente(prestamo_historico.cliente_id, ''parroquia''::character varying) AS parroquia, 
              get_datos_cliente(prestamo_historico.cliente_id, ''localidad''::character varying) AS localidad, 
              get_datos_cliente(prestamo_historico.cliente_id, ''avenida''::character varying) AS avenida, 
              get_datos_cliente(prestamo_historico.cliente_id, ''edif_casa''::character varying) AS edificio_casa, 
              get_datos_cliente(prestamo_historico.cliente_id, ''telefonos''::character varying) AS telefonos, 
              get_datos_cliente(prestamo_historico.cliente_id, ''banco_recaudador''::character varying) AS banco_recaudador, 
              get_datos_cliente(prestamo_historico.cliente_id, ''numero_cuenta''::character varying) AS numero_cuenta, 
              get_datos_cliente(prestamo_historico.cliente_id, ''tamano''::character varying) AS tamano, 
              prestamo_historico.monto_solicitado AS monto_credito, 
              prestamo_historico.monto_liquidado, prestamo_historico.fecha_liquidacion, 
              prestamo_historico.mes, prestamo_historico.ano, programa.alias, 
              ''S/I'' AS solicitud_cai, 
              ( SELECT solicitud_producto.nombre
                     FROM solicitud_producto
                    WHERE solicitud_producto.solicitud_id = prestamo_historico.solicitud_id
                   LIMIT 1) AS propuesta, 
              ''S/I'' AS tamano_organizacion, 
              ( SELECT ppc.fecha
                     FROM plan_pago_cuota ppc
                JOIN plan_pago pp ON pp.id = ppc.plan_pago_id
             JOIN prestamo_historico ph ON ph.id = pp.prestamo_id
            WHERE ph.id = prestamo_historico.id
            ORDER BY ppc.id DESC
           LIMIT 1) AS fecha_vencimiento, 
              ''S/I'' AS observaciones, ''S/I'' AS intereses_mora, 
              prestamo_historico.intereses_pagados AS total_recuperado_intereses_ordinarios, 
              prestamo_historico.mora_pagada AS total_intereses_mora_pagados, 
              prestamo_historico.saldo_insoluto AS saldo_capital, 
              ''S/I'' AS fecha_ultimo_vencimiento_no_pagado, 
              prestamo_historico.interes_diferido_vencido AS prestamo_interes_diferido_vencido, 
              prestamo_historico.interes_diferido_por_vencer AS prestamo_interes_diferido_por_vencer, 
              prestamo_historico.monto_mora AS prestamo_interes_mora, 
                      CASE
                          WHEN prestamo_historico.frecuencia_pago = 0 THEN ''pago único''::text
                          WHEN prestamo_historico.frecuencia_pago = 1 THEN ''mensual''::text
                          WHEN prestamo_historico.frecuencia_pago = 3 THEN ''trimestral''::text
                          WHEN prestamo_historico.frecuencia_pago = 6 THEN ''semestral''::text
                          WHEN prestamo_historico.frecuencia_pago = 12 THEN ''anual''::text
                          ELSE NULL::text
                      END AS modalidad_pago, 
                      CASE
                          WHEN prestamo_historico.frecuencia_pago > 0 THEN prestamo_historico.plazo / prestamo_historico.frecuencia_pago
                          ELSE prestamo_historico.plazo / prestamo_historico.plazo
                      END AS plazo, 
                      CASE
                          WHEN prestamo_historico.frecuencia_pago > 0 THEN (prestamo_historico.meses_gracia / prestamo_historico.frecuencia_pago)::integer
                          ELSE 0
                      END AS periodo_gracia, 
              prestamo_historico.meses_diferidos AS periodo_diferimiento_intereses, 
              prestamo_historico.tasa_vigente AS tasa, prestamo_historico.codigo_contable, 
              prestamo_historico.provision_individual_bandes AS provision_contrato_bandes, 
              prestamo_historico.conversion_cuotas_mensuales_sudeban, 
              prestamo_historico.clasificacion_riesgo_sudeban, 
              prestamo_historico.porcentaje_riesgo_sudeban AS porcentaje_individual_provision_sudeban, 
              prestamo_historico.conversion_cuotas_mensuales_bandes, 
              prestamo_historico.clasificacion_riesgo_bandes, 
              prestamo_historico.interes_vencido AS intereses_ordinarios_vencidos, 
              prestamo_historico.cuotas_pagadas AS prestamo_cuotas_pagadas, 
              CASE
                  WHEN prestamo_historico.frecuencia_pago > 0 THEN prestamo_historico.meses_diferidos / prestamo_historico.frecuencia_pago
                  ELSE 0
              END AS cuotas_diferidas_capital, 
              prestamo_historico.cantidad_cuotas_vencidas AS cuotas_vencidas, 
              prestamo_historico.monto_mora AS interes_mora, 
              prestamo_historico.monto_liquidado - prestamo_historico.saldo_insoluto AS monto_recuperado, 
              prestamo_historico.capital_vencido, 
              prestamo_historico.capital_por_pagar AS prestamo_capital_por_pagar, 
              prestamo_historico.banco_origen, 
              prestamo_historico.porcentaje_riesgo_bandes AS porcentaje_individual_provision_bandes, 
              prestamo_historico.dias_vigente AS prestamo_dias_vigente, 
              prestamo_historico.dias_demorado AS prestamo_dias_demorado, 
              prestamo_historico.banco_origen AS prestamo_banco_origen, 
              prestamo_historico.dias_vencido, 
              prestamo_historico.cuotas_pendientes AS prestamo_cuotas_pendientes, 
              prestamo_historico.capital_vencido AS prestamo_capital_vencido, 
              prestamo_historico.saldo_insoluto AS prestamo_saldo_insoluto, 
              prestamo_historico.exigible AS prestamo_exigible, 
              prestamo_historico.deuda AS prestamo_deuda, 
                  CASE
                      WHEN prestamo_historico.ultimo_desembolso = 0 THEN ''SI''::text
                      ELSE ''NO''::text
                  END AS prestamo_tabla, 
              mask_indice_mora(prestamo_historico.capital_vencido, prestamo_historico.monto_liquidado) AS indice_mora, 
              get_fecha_cuota_impaga(prestamo_historico.id) AS get_fecha_cuota_impaga, 
              get_ultimo_desembolso(prestamo_historico.id) AS get_ultimo_desembolso, 
              resolver_estatus(prestamo_historico.estatus::character varying) AS estatus, 
              prestamo_historico.capital_pagado AS total_recuperado_capital, 
              solicitud.monto_aprobado, solicitud.objetivo_proyecto AS objeto_proyecto, 
              solicitud.fecha_aprobacion, solicitud.van AS solicitud_van, 
              solicitud.tir AS solicitud_tir, 
              ( SELECT origen_fondo.nombre
                     FROM origen_fondo
                    WHERE origen_fondo.id = solicitud.origen_fondo_id) AS solicitud_origen_fondo, 
              ( SELECT modalidad_financiamiento.nombre
                     FROM modalidad_financiamiento
                    WHERE modalidad_financiamiento.id = solicitud.modalidad_financiamiento_id) AS solicitud_modalidad_financiamiento, 
              ( SELECT actividad_economica.descripcion
                     FROM actividad_economica
                    WHERE (actividad_economica.id IN ( SELECT unidad_negocio.actividad_economica_id
                             FROM unidad_negocio
                            WHERE unidad_negocio.solicitud_id = prestamo_historico.solicitud_id))) AS actividad_economica_unidad_negocio, 
              ( SELECT plan_pago_cuota.fecha
                     FROM plan_pago_cuota
                    WHERE (plan_pago_cuota.plan_pago_id IN ( SELECT plan_pago.id
                             FROM plan_pago
                            WHERE plan_pago.prestamo_id = prestamo_historico.id AND plan_pago.activo = true))
                    ORDER BY plan_pago_cuota.numero DESC
                   LIMIT 1) AS fecha_ultima_cuota, 
              ( SELECT sum(plan_pago_cuota.pago_interes_corriente) AS sum
                     FROM plan_pago_cuota
                    WHERE (plan_pago_cuota.plan_pago_id IN ( SELECT plan_pago.id
                             FROM plan_pago
                            WHERE plan_pago.prestamo_id = prestamo_historico.id))) AS pago_interes_corriente, 
              ( SELECT sum(plan_pago_cuota.pago_interes_mora) AS sum
                     FROM plan_pago_cuota
                    WHERE (plan_pago_cuota.plan_pago_id IN ( SELECT plan_pago.id
                             FROM plan_pago
                            WHERE plan_pago.prestamo_id = prestamo_historico.id))) AS pago_interes_mora, 
                  region.nombre AS solicitud_region, estado.nombre AS solicitud_estado, 
                  programa.nombre AS solicitud_programa, 
                  municipio.nombre AS solicitud_municipio, 
                  ciudad.nombre AS solicitud_ciudad, 
                  parroquia.nombre AS solicitud_parroquia
             FROM prestamo_historico
                 JOIN solicitud ON solicitud.id = prestamo_historico.solicitud_id
                 JOIN unidad_produccion up ON up.id = solicitud.unidad_produccion_id
                 JOIN ciudad ON up.ciudad_id = ciudad.id
                 JOIN estado ON ciudad.estado_id = estado.id
                 JOIN parroquia ON up.parroquia_id = parroquia.id
                 JOIN municipio ON up.municipio_id = municipio.id
                 JOIN region ON region.id = estado.region_id
                 JOIN programa ON programa.id = solicitud.programa_id
            WHERE prestamo_historico.estatus <> ''S''::bpchar
            ORDER BY prestamo_historico.id;';

    execute _sql_execute;
  end if;
  
  return false;
 
end;
$$ language 'plpgsql' volatile;