# encoding: utf-8

class CreateViewsRutaTramitacionCredito < ActiveRecord::Migration
  def change

    execute "

        drop view if exists view_ruta_tramite CASCADE;
        drop view if exists view_menu_ruta_no_opcion CASCADE;
        drop view if exists view_menu_ruta CASCADE;
        create view view_menu_ruta as
          select id,
                 nombre 
          from 
                 menu 
          where 
                 nombre like '%Ruta%';

        COMMENT ON VIEW view_menu_ruta IS 'Obtiene la opción del menu de la ruta del crédito, la cual debe tener en el nombre la palabra (ruta)';     

        create view view_menu_ruta_no_opcion as 
            (select 
                  wmr.id,
                  wmr.nombre
            from
                  view_menu_ruta wmr
          union
            select 
                  menu.id,
                  menu.nombre
            from 
                  menu 
                      inner join view_menu_ruta wmr on (wmr.id = menu.parent_id)
            where 
                  menu.opcion_id is null)
          order by id;

          COMMENT ON VIEW view_menu_ruta_no_opcion is 'Obtiene las opciones del menu parientes del menu principal de la ruta del credito las cuales tienen nulo el campo opcion_id y le agrega la opción del menu principal de la ruta del crédito usando la (vista view_menu_ruta)';
          
          CREATE VIEW view_ruta_tramite as
          select 
                ruta 
          from 
                menu 
                  inner join view_menu_ruta_no_opcion wmrno on 
                    (wmrno.id = menu.parent_id and menu.opcion_id is not null)
                  inner join opcion on (opcion.id = menu.opcion_id);

          COMMENT ON VIEW view_ruta_tramite IS 'Usando la vista view_menu_ruta_no_opcion obtiene todas las rutas de los formularios de las opciones de la ruta del crédito';


    "
  end

end
