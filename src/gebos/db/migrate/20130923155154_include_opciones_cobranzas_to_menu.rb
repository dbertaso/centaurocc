# encoding: utf-8

#Migrate para incluir las opciones de cobranzas en el menu

class IncludeOpcionesCobranzasToMenu < ActiveRecord::Migration
  def up

    execute "

        update menu set orden = 6 where nombre = 'Contabilidad';
        update menu set orden = 7 where nombre = 'General';
        update menu set orden = 8 where nombre = 'Reportes';
        update menu set orden = 9 where nombre = 'Gestión';

        insert into menu (id,nombre,orden,parent_id) values (858,'Recuperaciones', 5,46);

        insert into opcion (nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                          ('Agregar Gestión de Cobranzas',
                            true,
                            'cobranzas/agregar_cobranzas',
                            5);

        insert into menu (nombre,
                        parent_id,
                        orden,
                        opcion_id) 

                  values 
                        ('Agregar Gestión de Cobranzas',
                          (select id from menu where nombre = 'Recuperaciones'),
                          1,
                          currval('opcion_id_seq'));   
 
        insert into opcion (nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                          ('Historico de Cobranzas',
                            true,
                            'cobranzas/historico_cobranzas',
                            5);

        insert into menu (nombre,
                        parent_id,
                        orden,
                        opcion_id) 

                  values 
                        ('Historico de Cobranzas',
                          (select id from menu where nombre = 'Recuperaciones'),
                          2,
                          currval('opcion_id_seq'));  

    "
  end

  def down
  end
end
