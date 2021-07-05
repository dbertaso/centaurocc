# encoding: utf-8

class AddViewFechasRetorno < ActiveRecord::Migration
  def up
    
    execute "
        DROP VIEW if exists view_fechas_retorno;
        DROP VIEW if exists view_creditos_liquidados;
        DROP VIEW if exists view_creditos_otorgados;
        DROP VIEW if exists cantidad_integrantes_empresa;

        CREATE OR REPLACE VIEW cantidad_integrantes_empresa AS 
         SELECT empresa_integrante.empresa_id, count(empresa_integrante.persona_id) AS cantidad_integrantes
           FROM empresa
           JOIN empresa_integrante ON empresa_integrante.empresa_id = empresa.id
          GROUP BY empresa_integrante.empresa_id
          ORDER BY empresa_integrante.empresa_id;
          

          CREATE OR REPLACE VIEW view_fechas_retorno AS 
           SELECT prestamo.id AS prestamo_id, prestamo.fecha_liquidacion, plan_pago.fecha_fin AS fecha_fin_retorno, plan_pago.fecha_inicio AS fecha_inicio_retorno, solicitud.sector_id, solicitud.sub_sector_id, solicitud.rubro_id, solicitud.sub_rubro_id, sub_rubro.nombre AS sub_rubro_nombre, 
                  CASE
                      WHEN empresa.rif IS NULL THEN 0::bigint
                      ELSE cantidad_integrantes_empresa.cantidad_integrantes
                  END AS cantidad_integrantes, solicitud.monto_aprobado::numeric(16,2) AS monto_aprobado
             FROM prestamo
             JOIN plan_pago ON prestamo.id = plan_pago.prestamo_id AND plan_pago.activo = true
             JOIN solicitud ON solicitud.id = prestamo.solicitud_id
             JOIN cliente ON solicitud.cliente_id = cliente.id
             LEFT JOIN persona ON cliente.persona_id = persona.id
             LEFT JOIN empresa ON cliente.empresa_id = empresa.id
             LEFT JOIN cantidad_integrantes_empresa ON empresa.id = cantidad_integrantes_empresa.empresa_id
             JOIN sector ON solicitud.sector_id = sector.id
             JOIN sub_sector ON solicitud.sub_sector_id = sub_sector.id
             JOIN rubro ON solicitud.rubro_id = rubro.id
             JOIN sub_rubro ON solicitud.sub_rubro_id = sub_rubro.id;    
    "
  end

  def down
  end
end
