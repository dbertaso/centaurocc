class AddMenuImputacionesMaquinaria < ActiveRecord::Migration
  def up 
  end

  def down
    execute "insert into opcion (nombre,
                          tiene_acciones,
                          ruta,
                          opcion_grupo_id) 
                    values 
                          ('Imputaciones de Maquinarias',
                            true,
                            'basico/imputaciones_maquinaria',
                            3);

            insert into menu (id, nombre,
                        parent_id,
                        orden,
                        opcion_id) 

                  values 
                        ( 862, 
                          'Imputaciones de Maquinarias',
                          59,
                          25,
                          currval('opcion_id_seq'));"
  end
end
