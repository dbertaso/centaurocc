# encoding: utf-8

class AddNewItemsMensajesCorreoAndSmsMenu < ActiveRecord::Migration

  def change

    execute "

      insert into opcion (  nombre,
                                  tiene_acciones,
                                  ruta,
                                  opcion_grupo_id) 
                    values 
                            ('Mensajes de Correo Electrónico',
                            true,
                            'basico/mensajes_correo',
                            3);

            insert into menu    ( id, 
                                  nombre,
                                  parent_id,
                                  orden,
                                  opcion_id) 

                        values 
                                ( nextval('menu_id_seq'), 
                                  'Mensajes de Correo Electrónico',
                                  893,
                                  20,
                                  currval('opcion_id_seq'));


            insert into opcion (  nombre,
                                  tiene_acciones,
                                  ruta,
                                  opcion_grupo_id) 
                    values 
                            ('Mensajes de Texto (SMS)',
                            true,
                            'basico/mensajes_sms',
                            3);

            insert into menu    ( id, 
                                  nombre,
                                  parent_id,
                                  orden,
                                  opcion_id) 

                        values 
                                ( nextval('menu_id_seq'), 
                                  'Mensajes de Texto (SMS)',
                                  893,
                                  30,
                                  currval('opcion_id_seq'));
    "
      
    


  end


end
