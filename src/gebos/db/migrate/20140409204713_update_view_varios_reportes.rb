class UpdateViewVariosReportes < ActiveRecord::Migration
  def up 
    execute "
   -- View: view_cobranza_aplicada_efectiva

DROP VIEW if exists view_cobranza_aplicada_efectiva;

CREATE OR REPLACE VIEW view_cobranza_aplicada_efectiva AS 
 SELECT pc.id AS pago_cliente_id, pc.fecha, pc.modalidad, pc.monto, pc.cliente_id, pc.fecha_realizacion, pc.numero_voucher, pc.entidad_financiera_id, p.numero AS numero_prestamo, pp.id AS pago_prestamo_id, (( SELECT sum(pago_cuota.interes_corriente) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id))::double precision AS interes_corriente, (( SELECT sum(pago_cuota.interes_diferido) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id))::double precision AS interes_diferido, (( SELECT sum(pago_cuota.interes_mora) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id))::double precision AS interes_mora, ( SELECT sum(pago_cuota.capital)::double precision AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS capital, (( SELECT sum(pago_cuota.remanente_por_aplicar) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id))::double precision AS remanente_por_aplicar, s.numero AS numero_solicitud, ef.alias AS entidad_financiera, cb.numero AS numero_cuenta, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS nombre_cliente, m.abreviatura AS moneda
   FROM pago_cliente pc
   JOIN factura f ON f.pago_cliente_id = pc.id
   JOIN pago_prestamo pp ON pp.pago_cliente_id = pc.id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   JOIN moneda m ON s.moneda_id = m.id
  WHERE pc.modalidad = 'D'::bpchar;



-- View: view_cobranza_aplicada_general

DROP VIEW if exists view_cobranza_aplicada_general;

CREATE OR REPLACE VIEW view_cobranza_aplicada_general AS 
 SELECT 
	pc.id AS pago_cliente_id, 
	pc.fecha, 
	pc.modalidad, 
	pc.monto::float(25), 
	pc.cliente_id, 
	pc.fecha_realizacion, 
	pc.numero_voucher, 
	pc.entidad_financiera_id, 
	p.numero AS numero_prestamo, 
	pp.id, 
	sum(
		CASE
		    WHEN pt.id IS NULL THEN pp.remanente_por_aplicar
		    ELSE pt.remanente_por_aplicar
		END)::float(25) AS remanente_por_aplicar, 
	sum(pt.interes_corriente)::float(25) AS interes_corriente, 
	sum(pt.interes_diferido)::float(25) AS interes_diferido, 
	sum(pt.interes_mora)::float(25) AS interes_mora, 
	sum(pt.capital)::float(25) AS capital, 
	sum(pt.remanente_por_aplicar)::float(25) AS remanente_cuota, 
	s.numero AS numero_solicitud, 
	s.moneda_id, 
	ef.alias AS entidad_financiera, 
	cb.numero AS numero_cuenta, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS nombre_cliente, 
        m.abreviatura AS moneda
   FROM pago_cliente pc
   JOIN pago_prestamo pp ON pc.id = pp.pago_cliente_id
   LEFT JOIN pago_cuota pt ON pp.id = pt.pago_prestamo_id
   JOIN factura f ON f.pago_cliente_id = pc.id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   LEFT JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   LEFT JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   LEFT JOIN moneda m ON m.id = s.moneda_id
  GROUP BY pc.id, pp.id, p.id, s.id, ef.id, cb.id, empresa.id, persona.id, m.id;


-- View: view_rechazo_cobranza_aplicada
drop view if exists view_rechazo_cobranza_aplicada;

CREATE OR REPLACE VIEW view_rechazo_cobranza_aplicada AS 
 SELECT 
	rc.id AS rechazo_cobranza_id, 
	rc.fecha AS fecha_rechazo, 
	rc.prestamo_numero, 
	rc.monto_pago::float(25), 
	rc.codigo_error, 
	rc.descripcion_error, 
	rc.archivo, 
	s.numero AS numero_solicitud, 
        CASE
            WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || '-'::text) || persona.cedula::text)::character varying
            ELSE empresa.rif
        END AS cedula_rif, 
        CASE
            WHEN empresa.nombre IS NULL THEN ((persona.primer_nombre::text || ' '::text) || persona.primer_apellido::text)::character varying
            ELSE empresa.nombre
        END AS nombre_cliente, 
        ef.alias AS entidad_financiera, 
        cb.numero AS numero_cuenta, 
        m.abreviatura AS moneda
   FROM rechazo_cobranza rc
   JOIN prestamo p ON p.numero = rc.prestamo_numero
   JOIN solicitud s ON s.id = p.solicitud_id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   JOIN entidad_financiera ef ON rc.entidad_financiera_id = ef.id
   LEFT JOIN cuenta_bancaria cb ON cb.cliente_id = p.cliente_id
   JOIN moneda m ON s.moneda_id = m.id
  ORDER BY rc.id;


    
    "
  end

  def down
  end
end
