class AddMenuReporteCobranzas < ActiveRecord::Migration
  def change

    execute "

              insert into opcion (  nombre,
                                    tiene_acciones,
                                    ruta,
                                    opcion_grupo_id) 
                      values 
                              (
                              'Reporte de Cobranza',
                              true,
                              'prestamos/reporte_cobranza',
                              6);

              insert into menu    ( id, 
                                    nombre,
                                    parent_id,
                                    orden,
                                    opcion_id) 

                          values 
                                  ( nextval('menu_id_seq'), 
                                    'Reporte de Cobranza',
                                    46,
                                    4,
                                    currval('opcion_id_seq'));

    "
  end


end
