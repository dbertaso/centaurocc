# encoding: utf-8

class UpdateViewListOrdenDespachoRechazoArchivo < ActiveRecord::Migration
  def up
    
    execute "
    
      DROP VIEW IF EXISTS view_list_orden_despacho_rechazo_archivo;
      
      CREATE OR REPLACE VIEW view_list_orden_despacho_rechazo_archivo AS 
      SELECT histo.archivo AS archivo_historico, 'A'::character varying(1) as tipo,sol.numero, histo.numero_factura AS numero_historico, histo.casa_proveedora_id AS casa_historico, histo.fecha_liquidacion, histo.monto_liquidacion,  histo.numero_cuenta_casa_proveedora,'' as descripcion_error,casa.rif,
          CASE
              WHEN casa.entidad_financiera_id IS NULL THEN ('No posee banco asociado'::text)::character varying
              ELSE ent.nombre
          END AS nombre
             FROM historico_liquidacion_casa_proveedora histo
             inner join solicitud sol on histo.solicitud_id=sol.id
             JOIN casa_proveedora casa ON casa.id = histo.casa_proveedora_id
             LEFT JOIN entidad_financiera ent ON casa.entidad_financiera_id = ent.id
    UNION ALL
      SELECT recha.archivo AS archivo_historico,'R'::character varying(1) as tipo, recha.solicitud_numero AS solicitud_id, recha.numero_factura AS numero_historico, recha.casa_proveedora_id AS casa_historico, recha.fecha AS fecha_liquidacion, recha.monto_pago AS monto_liquidacion, recha.numero_cuenta AS numero_cuenta_casa_proveedora,recha.descripcion_error as descripcion_error,casa.rif,
          CASE
              WHEN casa.entidad_financiera_id IS NULL THEN ('No posee banco asociado'::text)::character varying
              ELSE ent.nombre
          END AS nombre
             FROM rechazo_liquidacion_casa_proveedora recha
             inner join solicitud sol on recha.solicitud_numero=sol.numero
             JOIN casa_proveedora casa ON casa.id = recha.casa_proveedora_id
           LEFT JOIN entidad_financiera ent ON casa.entidad_financiera_id = ent.id;

    "
  end

  def down
    execute "DROP VIEW view_list_orden_despacho_rechazo_archivo;"
  end
end
