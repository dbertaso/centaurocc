class AddIndicadorImputacionesMaquinaria < ActiveRecord::Migration
  def up
    execute "ALTER TABLE imputaciones_maquinaria ADD COLUMN indicador character varying(1);"
  end

  def down
  end
end
