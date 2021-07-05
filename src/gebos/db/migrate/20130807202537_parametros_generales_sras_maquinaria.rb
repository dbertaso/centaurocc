# encoding: utf-8

class ParametrosGeneralesSrasMaquinaria < ActiveRecord::Migration
  def up
    execute "ALTER TABLE parametro_general ADD COLUMN porcentaje_sras_maquinaria numeric(5,2);
             COMMENT ON COLUMN parametro_general.porcentaje_sras_maquinaria IS 'Porcentaje del sras para el sector de maquinaria'
            "
  end

  def down
  end
end
