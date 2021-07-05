# encoding: utf-8
class CreateReporteIndicadoresAnalista < ActiveRecord::Migration
  def up
  	execute "

              insert into opcion (  nombre,
                                    tiene_acciones,
                                    ruta,
                                    opcion_grupo_id) 
                      values 
                              (
                              'Indicadores de Gestión de Cobranza por Analista',
                              true,
                              'cobranzas/reporte_indicadores_analista',
                              6);

              insert into menu    ( id, 
                                    nombre,
                                    parent_id,
                                    orden,
                                    opcion_id) 

                          values 
                                  ( 901, 
                                    'Indicadores de Gestión de Cobranza por Analista',
                                    858,
                                    37,
                                    currval('opcion_id_seq'));

    "
  end

  def down
  end
end
