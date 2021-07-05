# encoding: utf-8

class RemoveMenuEstadisticas < ActiveRecord::Migration
  def up
    
    execute " 
      delete from menu where nombre = 'Estadísticas';
    "
  end

  def down
  end
end
