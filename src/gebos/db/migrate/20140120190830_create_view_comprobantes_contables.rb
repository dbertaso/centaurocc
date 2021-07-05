class CreateViewComprobantesContables < ActiveRecord::Migration
  def change
  
    execute "


          DROP VIEW if exists view_comprobantes_contables;
          CREATE OR REPLACE VIEW view_comprobantes_contables AS 
             SELECT comprobante_contable.id, tc.nombre AS tc_nombre, tc.id AS tc_id, 
                comprobante_contable.fecha_registro, comprobante_contable.fecha_comprobante, 
                comprobante_contable.enviado, comprobante_contable.reverso, comprobante_contable.reversado,
                prestamo.numero AS prestamo_numero, 
                solicitud.numero AS solicitud_numero, comprobante_contable.total_debe, 
                comprobante_contable.total_haber, moneda.nombre AS moneda_nombre, 
                moneda.abreviatura AS moneda_abreviatura, moneda.id AS moneda_id, 
                programa.id AS programa_id, programa.nombre AS programa_nombre, 
                    CASE
                        WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::character varying::text)::character varying
                        ELSE empresa.rif
                    END AS identificacion, 
                    CASE
                        WHEN empresa.nombre IS NULL THEN ((
                        CASE
                            WHEN persona.primer_nombre IS NULL THEN ''::character varying
                            ELSE persona.primer_nombre
                        END::text || ' '::text) || 
                        CASE
                            WHEN persona.primer_apellido IS NULL THEN ''::character varying
                            ELSE persona.primer_apellido
                        END::text)::character varying
                        ELSE empresa.nombre
                    END AS nombre_cliente
               FROM comprobante_contable
               JOIN transaccion_contable tc ON comprobante_contable.transaccion_contable_id = tc.id
               JOIN prestamo ON comprobante_contable.prestamo_id = prestamo.id
               JOIN solicitud ON prestamo.solicitud_id = solicitud.id
               JOIN programa ON solicitud.programa_id = programa.id
               JOIN moneda ON prestamo.moneda_id = moneda.id
               JOIN cliente ON prestamo.cliente_id = cliente.id
               LEFT JOIN persona ON cliente.persona_id = persona.id
               LEFT JOIN empresa ON cliente.empresa_id = empresa.id;

      "
  end
end
