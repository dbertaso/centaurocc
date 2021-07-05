class UpdateViewCobranzaAplicadaGeneralAndViewPagoEstadoCuentaV2 < ActiveRecord::Migration
  def up
    execute "
    
-- View: view_cobranza_aplicada_general

DROP VIEW if exists view_cobranza_aplicada_general;

CREATE OR REPLACE VIEW view_cobranza_aplicada_general AS 
 SELECT 
    pc.id AS pago_cliente_id,
    pc.modalidad,
    pc.cliente_id,
    pc.numero_voucher,
    pc.entidad_financiera_id,
    p.numero AS numero_prestamo,
    pp.id,
    f.fecha_realizacion AS fecha_valor,
    f.fecha AS fecha_contable,
    f.monto::double precision AS monto,
    f.remanente_por_aplicar::double precision AS saldo_favor,
    f.abono_capital::double precision AS abono_capital,
        CASE
            WHEN vpc.pago_interes = 0 and f.pago_interes <> 0 THEN f.pago_interes::double precision
            ELSE vpc.pago_interes::double precision
        END AS interes_corriente,
    vpc.pago_interes_diferido::double precision AS interes_diferido,
    vpc.pago_interes_mora::double precision AS interes_mora,
    vpc.pago_capital::double precision AS capital,
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
   JOIN factura f ON f.pago_cliente_id = pc.id
   JOIN view_pagos_cuota vpc ON vpc.prestamo_id = f.prestamo_id AND vpc.pago_cliente_id = f.pago_cliente_id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   LEFT JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   LEFT JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   JOIN moneda m ON m.id = s.moneda_id;


-- View: view_cobranza_aplicada_efectiva

DROP VIEW if exists view_cobranza_aplicada_efectiva;

CREATE OR REPLACE VIEW view_cobranza_aplicada_efectiva AS 
 SELECT 
    pc.id AS pago_cliente_id,
    --pc.fecha,
    pc.modalidad,
    --pc.monto,
    pc.cliente_id,
   -- pc.fecha_realizacion,
    pc.numero_voucher,
    pc.entidad_financiera_id,
    p.numero AS numero_prestamo,
    pp.id AS pago_prestamo_id,
    f.fecha_realizacion AS fecha_valor,
    f.fecha AS fecha_contable,
    f.monto::double precision AS monto,
    f.remanente_por_aplicar::double precision AS saldo_favor,
    f.abono_capital::double precision AS abono_capital,
    CASE
        WHEN vpc.pago_interes = 0 and f.pago_interes <> 0 THEN f.pago_interes::double precision
        ELSE vpc.pago_interes::double precision
    END AS interes_corriente,
    vpc.pago_interes_diferido::double precision AS interes_diferido,
    vpc.pago_interes_mora::double precision AS interes_mora,
    vpc.pago_capital::double precision AS capital,
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
   JOIN view_pagos_cuota vpc ON vpc.prestamo_id = f.prestamo_id AND vpc.pago_cliente_id = f.pago_cliente_id
   JOIN prestamo p ON f.prestamo_id = p.id
   JOIN solicitud s ON p.solicitud_id = s.id
   JOIN cliente c ON c.id = s.cliente_id
   LEFT JOIN persona ON c.persona_id = persona.id
   LEFT JOIN empresa ON c.empresa_id = empresa.id
   JOIN entidad_financiera ef ON pc.entidad_financiera_id = ef.id
   JOIN cuenta_bancaria cb ON cb.cliente_id = pc.cliente_id
   JOIN moneda m ON s.moneda_id = m.id
  WHERE pc.modalidad = 'D'::bpchar;



  -- View: view_pagos_estado_cuenta

DROP VIEW if exists view_pagos_estado_cuenta;

CREATE OR REPLACE VIEW view_pagos_estado_cuenta AS 
 SELECT factura.prestamo_id,
    factura.pago_cliente_id,
    factura.fecha_realizacion,
    factura.fecha,
    factura.tipo,
    factura.monto::double precision AS monto_pago,
    factura.remanente_por_aplicar::double precision AS remanente_por_aplicar,
    factura.abono_capital::double precision AS abono_capital,
        CASE
            WHEN vpc.pago_interes = 0::numeric AND factura.pago_interes <> 0::numeric THEN factura.pago_interes::double precision
            ELSE vpc.pago_interes::double precision
        END AS pago_interes,
    vpc.pago_interes_diferido::double precision AS pago_interes_diferido,
    vpc.pago_interes_mora::double precision AS pago_interes_mora,
    vpc.pago_capital::double precision AS pago_capital
   FROM factura
   LEFT JOIN view_pagos_cuota vpc ON vpc.prestamo_id = factura.prestamo_id AND vpc.pago_cliente_id = factura.pago_cliente_id
  WHERE factura.tipo = ANY (ARRAY['P'::bpchar, 'R'::bpchar])
  ORDER BY factura.prestamo_id, factura.pago_cliente_id, factura.fecha_realizacion DESC;
    
    
    "
  end

  def down
  end
end
