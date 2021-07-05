# encoding: utf-8

class ViewCreditosOtorgados < ActiveRecord::Migration
  def up
    
     execute "
      CREATE OR REPLACE VIEW view_creditos_otorgados AS
        select
                solicitud.id as solicitud_id,
                sub_rubro.nombre as sub_rubro_nombre,
                case when empresa.rif is null then 0 else cantidad_integrantes_empresa.cantidad_integrantes end as cantidad_integrantes,
                cast(solicitud.monto_aprobado as numeric(16,2)) as monto_aprobado
        from
          prestamo
            inner join solicitud on (solicitud.id = prestamo.solicitud_id)
            inner join cliente on (solicitud.cliente_id = cliente.id)
            left join persona on (cliente.persona_id = persona.id)
            left join empresa on (cliente.empresa_id = empresa.id)
            left join cantidad_integrantes_empresa on (empresa.id = cantidad_integrantes_empresa.empresa_id)
            inner join sector on (solicitud.sector_id = sector.id)
            inner join sub_sector on (solicitud.sub_sector_id = sub_sector.id)
            inner join rubro on (solicitud.rubro_id = rubro.id)
            inner join sub_rubro on (solicitud.sub_rubro_id = sub_rubro.id);
            
    "
  end

  def down
  
    execute "
        DROP VIEW view_creditos_otorgados;
    "
  end
end
