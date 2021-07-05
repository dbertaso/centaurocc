class UpdateViewRechazoLiquidacion < ActiveRecord::Migration
  def up

    execute "
          DROP VIEW view_rechazo_liquidacion;

          CREATE OR REPLACE VIEW view_rechazo_liquidacion AS 
           SELECT 
                  rl.id, 
                  rl.fecha, 
                  rl.archivo, 
                  rl.prestamo_numero, 
                  rl.solicitud_numero, 
                  CASE 
                    WHEN
                         empresa.rif is null 
                    THEN 
                         CASE 
                            WHEN 
                                persona.cedula_nacionalidad IS NULL
                            THEN
                                ('V'::text || ' '::text) || (persona.cedula::text)
                            ELSE
                                (persona.cedula_nacionalidad::text || ' '::text) || (persona.cedula::text)
                            END
                    ELSE
                        empresa.rif
                    END as identificacion,
                  CASE
                    WHEN
                        empresa.nombre IS NULL
                    THEN
                        (CASE 
                            WHEN
                                persona.primer_nombre IS NULL
                            THEN
                                ('  '::text)
                         
                            ELSE
                                (persona.primer_nombre::text || ' '::text )
                            END) ||
                        (CASE
                            WHEN
                                persona.primer_apellido IS NULL
                            THEN
                                ('  '::text)
                            ELSE
                                (persona.primer_apellido::text)
                        END)
                        
                  ELSE
                      empresa.nombre
                  END as nombre, 
                  rl.monto_pago, 
                  rl.descripcion_error, 
                  rl.entidad_financiera_id, 
                  ef.nombre AS nombre_entidad, 
                  rl.procesado,
                  moneda.id as moneda_id,
                  moneda.nombre as moneda_nombre,
                  moneda.abreviatura
           FROM 
                  rechazo_liquidacion rl
                    INNER JOIN solicitud on (rl.solicitud_numero = solicitud.numero)
                    INNER JOIN moneda on (solicitud.moneda_id = moneda.id)
                    INNER JOIN cliente   on (solicitud.cliente_id = cliente.id)
                    LEFT JOIN  persona   on (cliente.persona_id = persona.id)
                    LEFT JOIN  empresa   on (cliente.empresa_id = empresa.id)
                    INNER JOIN entidad_financiera ef on (rl.entidad_financiera_id = ef.id);

    "
  end

  def down
  end
end
