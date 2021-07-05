# encoding: utf-8

class CambioNombreItemsMenuCartera < ActiveRecord::Migration
  def up
    execute "
      update menu set nombre = 'Pagos por Déposito' where opcion_id = 61;
      update opcion set nombre = 'Pagos por Déposito' where id = 61;
      
      update menu set nombre = 'Registro de Boletas' where opcion_id = 919;
      update opcion set nombre = 'Registro de Boletas' where id = 919;
    "
  end

  def down
  end
end
