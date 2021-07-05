# encoding: utf-8
class AddMonedaToMenuTablasBasicas < ActiveRecord::Migration
  def change

    execute "


        insert 
        into 
              opcion (      id, 
                            nombre,
                            tiene_acciones,
                            ruta,
                            opcion_grupo_id) 
               values 
                            (nextval('opcion_id_seq'),
                            'Monedas',
                            true,
                            'basico/moneda',
                            3);

        INSERT
        INTO 
              menu (
                    id,
                    nombre, 
                    descripcion, 
                    parent_id, 
                    orden,
                    opcion_id) 
          VALUES 
                   (
                    nextval('menu_id_seq'),
                    'Monedas',
                    'Monedas', 
                    (select id from menu where nombre = 'Tablas Básicas'),
                    4,
                    currval('opcion_id_seq'));


    "
  end
end
