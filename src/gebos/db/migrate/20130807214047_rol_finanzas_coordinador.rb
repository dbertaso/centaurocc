# encoding: utf-8

class RolFinanzasCoordinador < ActiveRecord::Migration
  def up
    execute "   
        insert into rol(nombre,descripcion) values ('FINANZAS COORDINADOR','Revocatoria de trámites (solo usuario finanzas),etc');
    
        insert into opcion(nombre,descripcion,tiene_acciones,ruta,opcion_grupo_id) values ('Revocatoria de Trámite','Revoca un trámite que ya esta creado en cartera',false,'',(select id from opcion_grupo where nombre  like '%Solicitud%'));
    
        insert into rol_opcion(rol_id,opcion_id) values (currval('rol_id_seq'),currval('opcion_id_seq'));

    "
  end

  def down
  end
end
