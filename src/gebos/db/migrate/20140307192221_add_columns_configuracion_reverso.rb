# encoding: utf-8
class AddColumnsConfiguracionReverso < ActiveRecord::Migration
  def change

    execute "

      ALTER TABLE configuracion_reverso ADD COLUMN programa_id integer not null default 0;
      ALTER TABLE configuracion_reverso ADD COLUMN ruta_primaria text;

      COMMENT ON COLUMN configuracion_reverso.programa_id IS 'Programa o Producto para el cual aplica el avance';
      COMMENT ON COLUMN configuracion_reverso.ruta_primaria IS 'Ruta del próximo paso';
    "

  end


end
