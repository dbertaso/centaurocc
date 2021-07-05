# encoding: utf-8

class AlterTableRecepcionMaquinariaFechaHora < ActiveRecord::Migration
  def up
    execute "
              ALTER TABLE recepcion_maquinaria ADD COLUMN hora_llegada character varying(5);
              ALTER TABLE recepcion_maquinaria ADD COLUMN hora_llegada_ampm character varying(2);
             "
  end

  def down
  end
end
