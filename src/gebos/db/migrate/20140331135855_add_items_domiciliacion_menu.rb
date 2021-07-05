# encoding: utf-8

class AddItemsDomiciliacionMenu < ActiveRecord::Migration
  def change

    execute "

        insert into menu (id, nombre,
                                parent_id,
                                orden,
                                opcion_id) 

                          values 
                                (nextval('menu_id_seq'), 'Reporte Comprobante Contable',
                                  53,
                                  7,
                                  67);

        insert into menu    ( id, 
                              nombre,
                              parent_id,
                              orden) 

                    values 
                            ( nextval('menu_id_seq'), 
                              'Domiciliación',
                              46,
                              6);

        update menu set parent_id = (select id from menu where nombre = 'Domiciliación'), orden = 1 where nombre = 'Envío Cobranza';
        update menu set parent_id = (select id from menu where nombre = 'Domiciliación'), orden = 2 where nombre = 'Aplicación Cobranza';

        insert into opcion (  nombre,
                              tiene_acciones,
                              ruta,
                              opcion_grupo_id) 
                    values 
                          (
                              'Cobranza Aplicada',
                              true,
                              'prestamos/cobranza_aplicada',
                              6);

          insert into menu    ( id, 
                              nombre,
                              parent_id,
                              orden,
                              opcion_id) 

                    values 
                            ( nextval('menu_id_seq'), 
                              'Cobranza Aplicada',
                              (select id from menu where nombre = 'Domiciliación'),
                              3,
                              currval('opcion_id_seq'));

        insert into opcion (  nombre,
                              tiene_acciones,
                              ruta,
                              opcion_grupo_id) 
                    values 
                          (
                              'Rechazos Domiciliación',
                              true,
                              'prestamos/rechazo_domiciliacion',
                              6);

          insert into menu    ( id, 
                              nombre,
                              parent_id,
                              orden,
                              opcion_id) 

                    values 
                            ( nextval('menu_id_seq'), 
                              'Rechazos Domiciliación',
                              (select id from menu where nombre = 'Domiciliación'),
                              3,
                              currval('opcion_id_seq'));
    
    "
  end

end
