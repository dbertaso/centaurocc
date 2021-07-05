class CreateViewConsultaPrestamos < ActiveRecord::Migration
  def change
    execute "

      DROP VIEW if exists view_consulta_prestamos;


      CREATE OR REPLACE VIEW view_consulta_prestamos AS

      SELECT 
            prestamo.solicitud_id, 
            prestamo.id, 
            prestamo.numero, 
            solicitud.numero as numero_solicitud,
            solicitud.numero_origen as numero_origen,
            moneda.id as moneda_id,
            moneda.nombre as moneda_nombre,
            moneda.abreviatura as moneda_abreviatura,
            rubro.nombre as rubro_nombre, 
            CASE WHEN empresa.rif IS NULL
                  THEN cedula_nacionalidad || ' ' || cedula::character varying
                  ELSE empresa.rif
            END::character varying as identificacion,
            CASE WHEN empresa.nombre IS NULL
                  THEN (CASE WHEN primer_nombre IS NULL THEN '' ELSE primer_nombre END) || ' ' || (CASE WHEN primer_apellido IS NULL THEN '' ELSE primer_apellido END)
                  ELSE empresa.nombre 
             END as nombre_cliente, 
            prestamo.fecha_liquidacion as fecha,
            estado.nombre as estado_nombre,
            prestamo.saldo_insoluto,
            prestamo.deuda,
            prestamo.exigible,
            prestamo.estatus as estatus_p
      FROM 
          prestamo
          INNER JOIN cliente ON prestamo.cliente_id = cliente.id
          INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id
          INNER JOIN unidad_produccion up ON solicitud.unidad_produccion_id = up.id
          INNER JOIN municipio ON up.municipio_id = municipio.id
          INNER JOIN estado ON municipio.estado_id = estado.id
          INNER JOIN rubro ON  solicitud.rubro_id = rubro.id
          INNER JOIN moneda ON prestamo.moneda_id = moneda.id
          LEFT JOIN persona ON cliente.persona_id = persona.id
          LEFT JOIN empresa ON cliente.empresa_id = empresa.id
      where 
          prestamo.estatus <> 'S';
          
    "
  end
end
