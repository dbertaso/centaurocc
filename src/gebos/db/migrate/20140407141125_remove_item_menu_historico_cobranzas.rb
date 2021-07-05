class RemoveItemMenuHistoricoCobranzas < ActiveRecord::Migration

  def up

    execute "

    delete from menu where nombre = 'Historico de Cobranzas';


    insert into opcion (  nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                        ('Motivos de Atraso',
                          true,
                          'basico/motivos_atraso',
                          3);

            insert into menu    ( id, 
                                  nombre,
                                  parent_id,
                                  orden,
                                  opcion_id) 

                        values 
                                ( nextval('menu_id_seq'), 
                                  'Motivos de Atraso',
                                  893,
                                  40,
                                  currval('opcion_id_seq'));
  "
    
  end

end
