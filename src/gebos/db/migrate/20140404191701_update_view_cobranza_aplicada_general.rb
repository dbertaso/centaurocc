# encoding: utf-8
class UpdateViewCobranzaAplicadaGeneral < ActiveRecord::Migration
  def up
    execute "
    
-- View: view_cobranza_aplicada_general

DROP VIEW IF EXISTS view_cobranza_aplicada_general;

CREATE OR REPLACE VIEW view_cobranza_aplicada_general AS 
SELECT
    pc.id AS pago_cliente_id, 
    pc.fecha, 
    pc.modalidad, 
    pc.monto, 
    pc.cliente_id, 
    pc.fecha_realizacion, 
    pc.numero_voucher, 
    pc.entidad_financiera_id, 
    p.numero AS numero_prestamo,
    pp.id,

    sum(case when pt.id is null
             then pp.remanente_por_aplicar
             else pt.remanente_por_aplicar
             end ) as remanente_por_aplicar,
    sum(pt.interes_corriente) as interes_corriente,
    sum(pt.interes_diferido) as interes_diferido,
    sum(pt.interes_mora) as interes_mora,
    sum(pt.capital) as capital,
    sum(pt.remanente_por_aplicar) as remanente_cuota,
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
from pago_cliente pc
inner join pago_prestamo pp on pc.id = pp.pago_cliente_id
left join pago_cuota  pt on pp.id = pt.pago_prestamo_id
JOIN factura f ON f.pago_cliente_id = pc.id
JOIN prestamo p ON f.prestamo_id = p.id
JOIN solicitud s ON p.solicitud_id = s.id
JOIN cliente c ON c.id = s.cliente_id
LEFT JOIN persona ON c.persona_id = persona.id
LEFT JOIN empresa ON c.empresa_id = empresa.id
LEFT JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
LEFT JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
LEFT JOIN moneda m ON m.id = s.moneda_id
group by pc.id, pp.id, p.id, s.id, ef.id, cb.id, empresa.id, persona.id, m.id;
    
    "
  end

  def down
  end
end
