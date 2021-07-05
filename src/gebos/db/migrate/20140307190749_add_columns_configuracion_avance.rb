# encoding: utf-8
class AddColumnsConfiguracionAvance < ActiveRecord::Migration
  def change

    execute "

      ALTER TABLE configuracion_avance ADD COLUMN programa_id integer not null default 0;
      ALTER TABLE configuracion_avance ADD COLUMN ruta_primaria text;

      COMMENT ON COLUMN configuracion_avance.programa_id IS 'Programa o Producto para el cual aplica el avance';
      COMMENT ON COLUMN configuracion_avance.ruta_primaria IS 'Ruta del próximo paso';
    "

  end

end
