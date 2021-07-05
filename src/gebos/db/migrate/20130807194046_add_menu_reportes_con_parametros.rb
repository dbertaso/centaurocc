# encoding: utf-8

class AddMenuReportesConParametros < ActiveRecord::Migration
  def up
    execute "
      INSERT INTO opcion (id, nombre, descripcion, tiene_acciones, ruta, opcion_grupo_id) VALUES (nextval('opcion_id_seq'), 'Reportes con Parametros', NULL, false, 'prestamos/reportes_con_parametros', 8);
      INSERT INTO menu (id, nombre, descripcion, parent_id, orden, opcion_id) VALUES (nextval('menu_id_seq'), 'Reportes con Parametros', NULL, 100, 3, currval('opcion_id_seq'));
          "
  end

  def down
  end
end
