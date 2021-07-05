class UpdateTablaBoletaArrimeAddIndex < ActiveRecord::Migration
  def up
    execute "
CREATE INDEX boleta_arrime_uq_guia_movilizacion
  ON boleta_arrime
  USING btree
  (guia_movilizacion); "
  end

  def down
  end
end
