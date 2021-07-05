# encoding: utf-8

class CreateViewConfiguracionAvance < ActiveRecord::Migration
  def change
    execute "

      DROP VIEW if exists view_configuracion_avance;
      
      CREATE VIEW view_configuracion_avance AS
      select
            ca.id,
            estatus_origen_id,
            eo.nombre as estatus_origen_nombre,
            estatus_destino_id,
            ed.nombre as estatus_destino_nombre,
            programa_id,
            programa.nombre as programa_nombre,
            ruta_primaria,
            condicionado
      from
            configuracion_avance ca
            inner join programa on (programa.id = ca.programa_id)
            inner join estatus eo on (eo.id = ca.estatus_origen_id)
            inner join estatus ed on (ed.id = ca.estatus_destino_id)
      where 
            estatus_origen_id > 9000
    "    
  end
end
