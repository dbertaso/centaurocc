# encoding: utf-8

class SrasMaquinariaParametros < ActiveRecord::Migration
  def up
     execute "
              ALTER TABLE parametro_general ADD COLUMN porcentaje_sras_maquinaria_primer_anno numeric(5,2) DEFAULT 8;
              ALTER TABLE parametro_general ADD COLUMN porcentaje_sras_maquinaria_anno_subsiguientes numeric(5,2) DEFAULT 0.5;
             "
  end

  def down
  end
end
