class UpdateViewCobranzaAplicadaEfectivaV2 < ActiveRecord::Migration
  def up
    execute "
    
        -- View: view_cobranza_aplicada_efectiva

DROP VIEW if exists view_cobranza_aplicada_efectiva;

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
    pp.id as pago_prestamo_id,
    (select sum(interes_corriente)from pago_cuota where pago_prestamo_id = pp.id) as interes_corriente,
    (select sum(interes_diferido)from pago_cuota where pago_prestamo_id = pp.id) as interes_diferido,
    (select sum(interes_mora)from pago_cuota where pago_prestamo_id = pp.id) as interes_mora,
    (select sum(capital)from pago_cuota where pago_prestamo_id = pp.id) as capital,
    (select sum(remanente_por_aplicar)from pago_cuota where pago_prestamo_id = pp.id) as remanente_por_aplicar,
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

    "
  end

  def down
  end
end
