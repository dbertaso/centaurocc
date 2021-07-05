# encoding: utf-8

class AddMenuRecuperacionesDomicializacionPagos < ActiveRecord::Migration
  def up

    execute "

        insert into opcion (nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                          ('Envío Cobranza',
                            true,
                            'prestamos/envio_cobranza',
                            5);

        insert into menu (nombre,
                        parent_id,
                        orden,
                        opcion_id) 

                  values 
                        ('Envío Cobranza',
                          (select id from menu where nombre = 'Recuperaciones'),
                          3,
                          currval('opcion_id_seq'));   
 
        insert into opcion (nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                          ('Aplicación Cobranza',
                            true,
                            'prestamos/control_cobranza',
                            5);

        insert into menu (nombre,
                        parent_id,
                        orden,
                        opcion_id) 

                  values 
                        ('Aplicación Cobranza',
                          (select id from menu where nombre = 'Recuperaciones'),
                          4,
                          currval('opcion_id_seq'));  


  "
  end

  def down
  end
end
