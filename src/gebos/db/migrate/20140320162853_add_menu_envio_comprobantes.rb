# encoding: utf-8

class AddMenuEnvioComprobantes < ActiveRecord::Migration

  def change

    execute "

      insert into opcion (nombre,
                                tiene_acciones,
                                ruta,
                                opcion_grupo_id) 
                          values 
                                ('Envío Comprobantes Contables',
                                  true,
                                  'contabilidad/envio_asiento_contable',
                                  7);

              insert into menu (nombre,
                              parent_id,
                              orden,
                              opcion_id) 

                        values 
                              ('Envío Comprobantes Contables',
                                (select id from menu where nombre = 'Contabilidad'),
                                6,
                                currval('opcion_id_seq')); 

    "
  end

end
