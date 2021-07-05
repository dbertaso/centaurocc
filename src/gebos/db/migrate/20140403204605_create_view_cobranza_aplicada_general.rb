class CreateViewCobranzaAplicadaGeneral < ActiveRecord::Migration
  def up
    execute "
    -- View: view_cobranza_aplicada_general

DROP VIEW IF EXISTS view_cobranza_aplicada_general;

CREATE OR REPLACE VIEW view_cobranza_aplicada_general AS 
 SELECT pc.id AS pago_cliente_id,
    pc.fecha,
    pc.modalidad,
    pc.monto,
    pc.cliente_id,
    pc.fecha_realizacion,
    pc.numero_voucher,
    pc.entidad_financiera_id,
    p.numero AS numero_prestamo,
    pp.id AS pago_prestamo_id,
    ( SELECT sum(pago_cuota.interes_corriente) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS interes_corriente,
    ( SELECT sum(pago_cuota.interes_diferido) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS interes_diferido,
    ( SELECT sum(pago_cuota.interes_mora) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS interes_mora,
    ( SELECT sum(pago_cuota.capital) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS capital,
    ( SELECT sum(pago_cuota.remanente_por_aplicar) AS sum
           FROM pago_cuota
          WHERE pago_cuota.pago_prestamo_id = pp.id) AS remanente_por_aplicar,
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
   JOIN factura f ON f.pago_cliente_id = pc.id
   JOIN pago_prestamo pp ON pp.pago_cliente_id = pc.id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   LEFT JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   LEFT JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   JOIN moneda m ON s.moneda_id = m.id
  ORDER BY pc.modalidad;



    
    "
  end

  def down
  end
end
