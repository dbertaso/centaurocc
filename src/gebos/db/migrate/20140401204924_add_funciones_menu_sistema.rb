# encoding: utf-8

class AddFuncionesMenuSistema < ActiveRecord::Migration
  def change

    execute "
            insert into menu    ( id, 
                                            nombre,
                                            parent_id,
                                            orden) 

                                  values 
                                          ( nextval('menu_id_seq'), 
                                            'Recuperaciones',
                                            59,
                                            110);
              insert into opcion (  nombre,
                                    tiene_acciones,
                                    ruta,
                                    opcion_grupo_id) 
                      values 
                              (
                              'Analista Cobranza',
                              true,
                              'basico/analista_cobranzas',
                              3);

              insert into menu    ( id, 
                                    nombre,
                                    parent_id,
                                    orden,
                                    opcion_id) 

                          values 
                                  ( nextval('menu_id_seq'), 
                                    'Analista Cobranza',
                                    (select id from menu where nombre = 'Recuperaciones' and parent_id = 59),
                                    10,
                                    currval('opcion_id_seq'));

              insert into opcion (  nombre,
                                    tiene_acciones,
                                    ruta,
                                    opcion_grupo_id) 
                      values 
                              (
                              'Cierre Financiero',
                              true,
                              'prestamos/cierre_financiero',
                              6);

              insert into menu    ( id, 
                                    nombre,
                                    parent_id,
                                    orden,
                                    opcion_id) 

                          values 
                                  ( nextval('menu_id_seq'), 
                                    'Cierre Financiero',
                                    (select id from menu where nombre = 'Cartera' and parent_id is null),
                                    20,
                                    currval('opcion_id_seq'));
    "
  end

end
