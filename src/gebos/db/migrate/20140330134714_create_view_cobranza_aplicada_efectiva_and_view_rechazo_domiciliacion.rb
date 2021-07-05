class CreateViewCobranzaAplicadaEfectivaAndViewRechazoDomiciliacion < ActiveRecord::Migration
  def up
    execute "
    -- View: view_rechazo_cobranza_aplicada

DROP VIEW IF EXISTS view_rechazo_cobranza_aplicada;

CREATE OR REPLACE VIEW view_rechazo_cobranza_aplicada AS 
 SELECT rc.id AS rechazo_cobranza_id,
    rc.fecha AS fecha_rechazo,
    rc.prestamo_numero,
    rc.monto_pago,
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


-- View: view_cobranza_aplicada_efectiva

DROP VIEW IF EXISTS  view_cobranza_aplicada_efectiva;

CREATE OR REPLACE VIEW view_cobranza_aplicada_efectiva AS 
 SELECT pc.id AS pago_cliente_id,
    pc.fecha,
    pc.modalidad,
    pc.monto,
    pc.cliente_id,
    pc.fecha_realizacion,
    pc.numero_voucher,
    pc.entidad_financiera_id,
    p.numero AS numero_prestamo,
    s.numero AS numero_solicitud,
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
   JOIN factura f ON f.pago_cliente_id = pc.id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   JOIN moneda m ON s.moneda_id = m.id
  WHERE pc.modalidad = 'D'::bpchar;




    "
  end

  def down
  end
end
