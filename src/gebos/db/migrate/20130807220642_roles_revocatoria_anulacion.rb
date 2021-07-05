# encoding: utf-8

class RolesRevocatoriaAnulacion < ActiveRecord::Migration
  
  def up
    
    execute "   
    
    
        delete from rol_opcion where (rol_id = (select id from rol where trim(lower(nombre)) = lower('FINANZAS COORDINADOR')) and opcion_id = (select id from opcion where trim(lower(nombre)) = lower('Revocatoria de Trámite')));
        
        delete from opcion where trim(lower(nombre)) = lower('Revocatoria de Trámite');       
        
        delete from usuario_rol where rol_id = (select id from rol where trim(lower(nombre)) = lower('FINANZAS COORDINADOR'));  
        
        delete from rol where trim(lower(nombre)) = lower('FINANZAS COORDINADOR');  
        
        
        
        insert into rol(id,nombre,descripcion) values (2000,'REVOCATORIA DEL CRÉDITO','Permisología exclusiva para la revocatoria del crédito');
    
        insert into opcion(nombre,descripcion,tiene_acciones,ruta,opcion_grupo_id) values ('Revocatoria del Crédito','Revoca un crédito que ya esta creado en cartera',false,'',(select id from opcion_grupo where nombre  like '%Solicitud%'));
    
        insert into rol_opcion(rol_id,opcion_id) values (2000,currval('opcion_id_seq'));
        
        
        
        insert into rol(id,nombre,descripcion) values (2001,'ANULACIÓN DEL TRÁMITE','Permisología exclusiva para la anulación del trámite');
    
        insert into opcion(nombre,descripcion,tiene_acciones,ruta,opcion_grupo_id) values ('Anulación del Trámite','Anula un trámite que ya esta creado en cartera',false,'',(select id from opcion_grupo where nombre  like '%Solicitud%'));
    
        insert into rol_opcion(rol_id,opcion_id) values (2001,currval('opcion_id_seq'));
    
    

    "
  end

  def down
  end
end
