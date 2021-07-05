class CreateViewResumenDesembolsosCierres < ActiveRecord::Migration
  def change

    execute "

      CREATE OR REPLACE VIEW view_resumen_desembolsos_cierre AS 
          SELECT  
                  desembolso.id, 
                  desembolso.fecha_valor AS fecha, 
                  CASE
                      WHEN empresa.rif IS NULL THEN ((persona.cedula_nacionalidad::text || ' '::text) || persona.cedula::character varying::text)::character varying
                      ELSE empresa.rif
                  END AS cedula_rif, 
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
                  END AS beneficiario,  
                  desembolso.monto, 
                  desembolso.referencia as numero_referencia, 
                  entidad_financiera.nombre AS entidad_financiera, 
                  prestamo.banco_origen
          FROM 
                desembolso
                    inner join prestamo on (desembolso.prestamo_id = prestamo.id)
                    inner join cliente on (prestamo.cliente_id = cliente.id)
                    left join persona on (cliente.persona_id = persona.id)
                    left join empresa on (cliente.empresa_id = empresa.id)
                    inner join entidad_financiera on (desembolso.entidad_financiera_id = entidad_financiera.id);

    "
  end
end
