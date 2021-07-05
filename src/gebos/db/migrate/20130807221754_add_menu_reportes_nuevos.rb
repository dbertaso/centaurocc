# encoding: utf-8

class AddMenuReportesNuevos < ActiveRecord::Migration
  def up
    
    execute "
    
        /*
        -----------------------------------
        opcion ---> Listado del pidan
        -----------------------------------
        */
        
        insert 
        into 
              opcion (      id, 
                            nombre,
                            tiene_acciones,
                            ruta,
                            opcion_grupo_id) 
               values 
                            (nextval('opcion_id_seq'),
                            'Listado del Pidan',
                            true,
                            'prestamos/reporte_pidan',
                            8);

        INSERT
        INTO 
              menu (
                    id,
                    nombre, 
                    descripcion, 
                    parent_id, 
                    orden,
                    opcion_id) 
          VALUES 
                   (
                    nextval('menu_id_seq'),
                    'Listado del PIDAN',
                    'Listado del Presupuesto asignado al PIDAN', 
                    (select id from menu where nombre = 'Reportes con Parámetros'),
                    4,
                    currval('opcion_id_seq'));

        /*
        -----------------------------------------------
        opcion ---> Créditos Otorgados Por Trimestre
        -----------------------------------------------
        */
                    
        insert 
        into 
              opcion (      id, 
                            nombre,
                            tiene_acciones,
                            ruta,
                            opcion_grupo_id) 
               values 
                            (nextval('opcion_id_seq'),
                            'Créditos Otorgados Por Trimestre',
                            true,
                            'prestamos/reporte_otorgados_por_trimestre',
                            8);

        INSERT
        INTO 
              menu (
                    id,
                    nombre, 
                    descripcion, 
                    parent_id, 
                    orden,
                    opcion_id) 
          VALUES 
                   (
                    nextval('menu_id_seq'),
                    'Créditos Otorgados Por Trimestre',
                    'Reporte de créditos otorgados por trimeste (Formato Excel)', 
                    (select id from menu where nombre = 'Reportes con Parámetros'),
                    5,
                    currval('opcion_id_seq'));

        /*
        -----------------------------------------------
        opcion ---> Rendimientos por Trimestre
        -----------------------------------------------
        */

        insert 
        into 
              opcion (      id, 
                            nombre,
                            tiene_acciones,
                            ruta,
                            opcion_grupo_id) 
               values 
                            (nextval('opcion_id_seq'),
                            'Rendiciones por Trimestre',
                            true,
                            'prestamos/reporte_rendiciones_por_trimestre',
                            8);

        INSERT
        INTO 
              menu (
                    id,
                    nombre, 
                    descripcion, 
                    parent_id, 
                    orden,
                    opcion_id) 
          VALUES 
                   (
                    nextval('menu_id_seq'),
                    'Rendiciones Por Trimestre',
                    'Reporte de rendiciones por trimeste (Formato Excel)', 
                    (select id from menu where nombre = 'Reportes con Parámetros'),
                    6,
                    currval('opcion_id_seq'));

        /*
        -----------------------------------------------
        opcion ---> Analisis de Ejecución
        -----------------------------------------------
        */

        insert 
        into 
              opcion (      id, 
                            nombre,
                            tiene_acciones,
                            ruta,
                            opcion_grupo_id) 
               values 
                            (nextval('opcion_id_seq'),
                            'Análisis de Ejecución',
                            true,
                            'prestamos/reporte_analisis_ejecucion',
                            8);

        INSERT
        INTO 
              menu (
                    id,
                    nombre, 
                    descripcion, 
                    parent_id, 
                    orden,
                    opcion_id) 
          VALUES 
                   (
                    nextval('menu_id_seq'),
                    'Análisis de Ejecución',
                    'Analisis de Ejecución (Aprobado Versus Liquidado) (Formato Excel)', 
                    (select id from menu where nombre = 'Reportes con Parámetros'),
                    7,
                    currval('opcion_id_seq'));
    "
  end

  def down
  end
end
