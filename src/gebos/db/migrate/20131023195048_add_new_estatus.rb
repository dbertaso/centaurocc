class AddNewEstatus < ActiveRecord::Migration
  def up
    execute "
    INSERT INTO estatus (id,nombre, descripcion, const_id) VALUES (10006,'Confirmando Seriales','Confirmando Seriales por la Gerencia de Maquinaria','ST0006');"
  end

  def down
  end
end
