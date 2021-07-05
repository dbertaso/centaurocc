# encoding: utf-8

class AddColumnTablaParametroGeneral < ActiveRecord::Migration
  def up
      execute "
                ALTER TABLE parametro_general ADD COLUMN dias_max_vencimiento_ultima_cuota integer DEFAULT 15;

                COMMENT ON COLUMN parametro_general.dias_max_vencimiento_ultima_cuota IS 'rango de dias maximos para calcular el vencimiento de un prestamo a traves de su ultima cuota (solamente utilizado para saber cuando un prestamo esta por vencerse, a traves de su ultima cuota)'; 
              "
  end

  def self.down
  
    execute " 
              ALTER TABLE parametro_general DROP COLUMN dias_max_vencimiento_ultima_cuota;
            "
  end
end
