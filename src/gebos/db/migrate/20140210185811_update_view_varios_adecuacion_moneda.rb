# encoding: utf-8
class UpdateViewVariosAdecuacionMoneda < ActiveRecord::Migration
  def up 
    execute"

-- View: view_list_desembolso

-- DROP VIEW view_list_desembolso;

CREATE OR REPLACE VIEW view_list_desembolso AS 

 SELECT 
	s.oficina_id,
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS beneficiario,
        CASE
            WHEN empresa.nombre IS NULL THEN persona_email.email
            ELSE empresa_email.email
        END AS email,
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif,
	s.id AS solicitud_id,
	s.numero AS nro_tramite,
	des.entidad_financiera_id,
	ent.nombre AS banco,
	ent.cod_swift,
	des.tipo_cuenta,
	des.numero_cuenta,
	s.unidad_produccion_id,
	uni.ciudad_id,
	ciu.nombre AS ciudad,
	ciu.estado_id,
	est.nombre AS estado,
	sect.id AS sector_id,
	sect.nombre AS sector,
	rub.nombre AS rubro,
	s.rubro_id,
	act.ciclo_productivo_id AS ciclo,
	cic.nombre,
	des.id AS desembolso_id,
	des.numero AS numero_desembolso,
	s.estatus_id AS estatus,
	des.monto::numeric(16,2) AS monto_liquidar,
	pres.monto_banco,
	pres.monto_liquidado,
	srub.nombre AS subrubro,
	act.nombre AS actividad,
	s.sub_sector_id,
	s.actividad_id,
	s.sub_rubro_id,
	s.moneda_id,
	mon.nombre as moneda
   FROM cliente cli
   LEFT JOIN persona ON cli.persona_id = persona.id
   LEFT JOIN empresa ON cli.empresa_id = empresa.id
   LEFT JOIN persona_email ON cli.persona_id = persona.id AND persona_email.persona_id = persona.id AND persona_email.tipo = 'P'::bpchar
   LEFT JOIN empresa_email ON cli.empresa_id = empresa.id AND empresa_email.empresa_id = empresa.id AND empresa_email.tipo = 'P'::bpchar
   JOIN solicitud s ON cli.id = s.cliente_id
   JOIN unidad_produccion uni ON uni.id = s.unidad_produccion_id
   JOIN ciudad ciu ON ciu.id = uni.ciudad_id
   JOIN estado est ON est.id = ciu.estado_id
   JOIN rubro rub ON rub.id = s.rubro_id
   JOIN sub_rubro srub ON srub.id = s.sub_rubro_id
   JOIN sub_sector ssect ON ssect.id = s.sub_sector_id
   JOIN actividad act ON act.id = s.actividad_id
   LEFT JOIN ciclo_productivo cic ON cic.id = act.ciclo_productivo_id
   JOIN prestamo pres ON pres.solicitud_id = s.id
   JOIN desembolso des ON des.prestamo_id = pres.id AND des.realizado = false AND des.confirmado = true
   JOIN entidad_financiera ent ON des.entidad_financiera_id = ent.id
   JOIN oficina ofi ON ofi.id = s.oficina_id
   JOIN sector sect ON sect.id = rub.sector_id
   JOIN moneda mon ON mon.id = s.moneda_id
  WHERE s.estatus_id = 10050;



-- View: view_list_desembolso_cheque

-- DROP VIEW view_list_desembolso_cheque;

CREATE OR REPLACE VIEW view_list_desembolso_cheque AS 

 SELECT
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS beneficiario,
        CASE
            WHEN empresa.nombre IS NULL THEN persona_email.email
            ELSE empresa_email.email
        END AS email,
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif,
    s.oficina_id,
    s.id AS solicitud_id,
    s.numero AS nro_tramite,
    pres.id AS prestamo_id,
    cli.entidad_financiera_id,
    ent.nombre AS banco,
    ent.cod_swift,
    cli.tipo_cuenta,
    cli.numero_cuenta,
    s.unidad_produccion_id,
    uni.ciudad_id,
    ciu.nombre AS ciudad,
    ciu.estado_id,
    est.nombre AS estado,
    mun.id AS municipio_id,
    mun.nombre AS municipio,
    sect.id AS sector_id,
    sect.nombre AS sector,
    rub.nombre AS rubro,
    s.rubro_id,
    act.ciclo_productivo_id AS ciclo,
    cic.nombre,
    des.id AS desembolso_id,
    des.numero AS numero_desembolso,
    des.tipo_cheque,
    des.referencia,
    s.estatus_id AS estatus,
    des.monto::numeric(16,2) AS monto_liquidar,
    pres.monto_banco,
    pres.monto_liquidado,
    srub.nombre AS subrubro,
    act.nombre AS actividad,
    s.sub_sector_id,
    s.actividad_id,
    s.sub_rubro_id,
    s.moneda_id,
    mon.nombre as moneda
   FROM cliente cli
   LEFT JOIN persona ON cli.persona_id = persona.id
   LEFT JOIN empresa ON cli.empresa_id = empresa.id
   LEFT JOIN persona_email ON cli.persona_id = persona.id AND persona_email.persona_id = persona.id AND persona_email.tipo = 'P'::bpchar
   LEFT JOIN empresa_email ON cli.empresa_id = empresa.id AND empresa_email.empresa_id = empresa.id AND empresa_email.tipo = 'P'::bpchar
   LEFT JOIN entidad_financiera ent ON cli.entidad_financiera_id = ent.id
   JOIN solicitud s ON cli.id = s.cliente_id
   JOIN unidad_produccion uni ON uni.id = s.unidad_produccion_id
   JOIN ciudad ciu ON ciu.id = uni.ciudad_id
   JOIN estado est ON est.id = ciu.estado_id
   JOIN municipio mun ON mun.id = uni.municipio_id
   JOIN rubro rub ON rub.id = s.rubro_id
   JOIN sub_rubro srub ON srub.id = s.sub_rubro_id
   JOIN sub_sector ssect ON ssect.id = s.sub_sector_id
   JOIN actividad act ON act.id = s.actividad_id
   LEFT JOIN ciclo_productivo cic ON cic.id = act.ciclo_productivo_id
   JOIN prestamo pres ON pres.solicitud_id = s.id
   JOIN desembolso des ON des.prestamo_id = pres.id AND des.realizado = false
   JOIN oficina ofi ON ofi.id = s.oficina_id
   JOIN sector sect ON sect.id = rub.sector_id
   JOIN moneda mon ON mon.id = s.moneda_id
  WHERE s.estatus_id = 10055 AND cli.entidad_financiera_id IS NULL;



-- View: view_fecha_liquidacion

-- DROP VIEW view_fecha_liquidacion;

CREATE OR REPLACE VIEW view_fecha_liquidacion AS 
 SELECT 
	s.oficina_id,
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS beneficiario,
        CASE
            WHEN empresa.nombre IS NULL THEN persona_email.email
            ELSE empresa_email.email
        END AS email,
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif,
	s.id AS solicitud_id,
	s.numero AS nro_tramite,
	s.control,
	s.fecha_liquidacion,
	pres.numero AS nro_prestamo,
	pres.id AS prestamo_id,
	cli.tipo_cliente_id,
	des.entidad_financiera_id,
	ent.nombre AS banco,
	ent.cod_swift,
	des.tipo_cuenta,
	des.numero_cuenta,
	s.unidad_produccion_id,
	uni.ciudad_id,
	ciu.nombre AS ciudad,
	ciu.estado_id,
	est.nombre AS estado,
	sect.id AS sector_id,
	sect.nombre AS sector,
	rub.nombre AS rubro,
	s.rubro_id,
	act.ciclo_productivo_id AS ciclo,
	cic.nombre,
	des.id AS desembolso_id,
	des.numero AS numero_desembolso,
	s.estatus_desembolso_id,
	s.estatus_id,
	s.monto_solicitado::numeric(16,2) AS monto_solicitado,
	des.monto::numeric(16,2) AS monto_liquidar,
	pres.monto_banco,
	pres.monto_liquidado,
	sr.nombre AS sub_rubro_nombre,
	sr.id AS sub_rubro_id,
	act.nombre AS actividad_nombre,
	act.id AS actividad_id,
	s.moneda_id,
	mon.nombre AS moneda
   FROM cliente cli
   LEFT JOIN persona ON cli.persona_id = persona.id
   LEFT JOIN empresa ON cli.empresa_id = empresa.id
   LEFT JOIN persona_email ON cli.persona_id = persona.id AND persona_email.persona_id = persona.id AND persona_email.tipo = 'P'::bpchar
   LEFT JOIN empresa_email ON cli.empresa_id = empresa.id AND empresa_email.empresa_id = empresa.id AND empresa_email.tipo = 'P'::bpchar
   JOIN solicitud s ON cli.id = s.cliente_id
   JOIN unidad_produccion uni ON uni.id = s.unidad_produccion_id
   JOIN ciudad ciu ON ciu.id = uni.ciudad_id
   JOIN estado est ON est.id = ciu.estado_id
   JOIN rubro rub ON rub.id = s.rubro_id
   JOIN sub_rubro sr ON sr.id = s.sub_rubro_id
   JOIN actividad act ON act.id = s.actividad_id
   LEFT JOIN ciclo_productivo cic ON cic.id = act.ciclo_productivo_id
   JOIN prestamo pres ON pres.solicitud_id = s.id
   JOIN desembolso des ON des.prestamo_id = pres.id AND des.realizado = false AND des.confirmado = true
   JOIN entidad_financiera ent ON des.entidad_financiera_id = ent.id
   JOIN oficina ofi ON ofi.id = s.oficina_id
   JOIN sector sect ON sect.id = s.sector_id
   JOIN moneda mon ON mon.id = s.moneda_id;


-- View: view_generacion_tabla

-- DROP VIEW view_generacion_tabla;

CREATE OR REPLACE VIEW view_generacion_tabla AS 
 SELECT s.oficina_id,
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS beneficiario,
        CASE
            WHEN empresa.nombre IS NULL THEN persona_email.email
            ELSE empresa_email.email
        END AS email,
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif,
    s.id AS solicitud_id,
    s.numero AS nro_tramite,
    s.control,
    s.fecha_liquidacion,
    pres.numero AS nro_prestamo,
    pres.id AS prestamo_id,
    pres.monto_sras_total AS monto_sras,
    cli.tipo_cliente_id,
    des.entidad_financiera_id,
    ent.nombre AS banco,
    ent.cod_swift,
    des.tipo_cuenta,
    des.numero_cuenta,
    s.unidad_produccion_id,
    uni.ciudad_id,
    ciu.nombre AS ciudad,
    ciu.estado_id,
    est.nombre AS estado,
    sect.id AS sector_id,
    sect.nombre AS sector,
    rub.nombre AS rubro,
    s.rubro_id,
    act.ciclo_productivo_id AS ciclo,
    cic.nombre,
    des.id AS desembolso_id,
    des.numero AS numero_desembolso,
    s.estatus_desembolso_id,
    s.estatus_id,
    s.monto_solicitado::numeric(16,2) AS monto_solicitado,
    des.monto::numeric(16,2) AS monto_liquidar,
    pres.monto_banco,
    pres.monto_liquidado,
    pres.monto_insumos,
    ofi.nombre AS oficina_nombre,
    ssec.id AS sub_sector_id,
    s.sub_rubro_id,
    s.actividad_id,
    srub.nombre AS subrubro,
    act.nombre AS actividad,
    s.moneda_id,
    mon.nombre AS moneda
   FROM cliente cli
   LEFT JOIN persona ON cli.persona_id = persona.id
   LEFT JOIN empresa ON cli.empresa_id = empresa.id
   LEFT JOIN persona_email ON cli.persona_id = persona.id AND persona_email.persona_id = persona.id AND persona_email.tipo = 'P'::bpchar
   LEFT JOIN empresa_email ON cli.empresa_id = empresa.id AND empresa_email.empresa_id = empresa.id AND empresa_email.tipo = 'P'::bpchar
   JOIN solicitud s ON cli.id = s.cliente_id
   JOIN unidad_produccion uni ON uni.id = s.unidad_produccion_id
   JOIN ciudad ciu ON ciu.id = uni.ciudad_id
   JOIN estado est ON est.id = ciu.estado_id
   JOIN rubro rub ON rub.id = s.rubro_id
   JOIN sub_rubro srub ON srub.id = s.sub_rubro_id
   JOIN actividad act ON act.id = s.actividad_id
   LEFT JOIN ciclo_productivo cic ON cic.id = act.ciclo_productivo_id
   JOIN prestamo pres ON pres.solicitud_id = s.id
   JOIN desembolso des ON des.prestamo_id = pres.id AND des.realizado = false
   JOIN entidad_financiera ent ON des.entidad_financiera_id = ent.id
   JOIN oficina ofi ON ofi.id = s.oficina_id
   JOIN sector sect ON sect.id = rub.sector_id
   JOIN sub_sector ssec ON rub.sub_sector_id = ssec.id
   JOIN moneda mon ON mon.id = s.moneda_id;


-- View: view_gestionar_garantias

-- DROP VIEW view_gestionar_garantias;

CREATE OR REPLACE VIEW view_gestionar_garantias AS 
 SELECT s.id AS solicitud_id,
    s.numero,
    s.monto_solicitado,
    s.estatus_id,
    s.liberada,
    s.usuario_pre_evaluacion,
    s.consultoria,
    s.decision_final,
    s.confirmacion,
    s.oficina_id,
    s.sector_id,
    s.sub_sector_id,
    s.rubro_id,
    s.sub_rubro_id,
    s.actividad_id,
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
    es.nombre AS estatus,
    es.const_id,
    p.nombre AS programa,
    pr.numero AS financiamiento,
    est.id AS estado_id,
    est.nombre AS estado,
    (u.primer_nombre::text || ' '::text) || u.primer_apellido::text AS usuario,
    sec.nombre AS sector,
    sub.nombre AS sub_sector,
    r.nombre AS rubro,
    up.nombre AS unidad_produccion,
    up.municipio_id,
    up.parroquia_id,
    m.nombre AS municipio,
    pa.nombre AS parroquia,
    sr.nombre AS sub_rubro,
    a.nombre AS actividad,
    s.moneda_id,
    mon.nombre AS moneda
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




    "
  end

  def down
  end
end
