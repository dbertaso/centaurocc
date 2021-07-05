# encoding: utf-8

class AddRecuperacionCarteraToMenu < ActiveRecord::Migration
  def change
    execute "
    
      update menu set opcion_id = null where nombre = 'Reportes con Parametros';   
      delete from opcion where nombre = 'Reportes con Parametros';
      INSERT INTO opcion (id, nombre, descripcion, tiene_acciones, ruta, opcion_grupo_id) VALUES (nextval('opcion_id_seq'), 'Proyeccion Recuperacion Cartera', NULL, false, 'prestamos/reporte_proyeccion_recuperacion', 8);
      INSERT INTO menu (id, nombre, descripcion, parent_id, orden, opcion_id) VALUES (nextval('menu_id_seq'), 'Proyeccion Recuperacion Cartera', NULL, (select id from menu where nombre = 'Reportes con Parametros') , 3, currval('opcion_id_seq'));

    
    "
    
  end
end
