# encoding: utf-8
class AddColumnProgramaIdCondicionesFinanciamiento < ActiveRecord::Migration
  def up

    execute "
      ALTER TABLE condiciones_financiamiento ADD COLUMN programa_id integer;

      COMMENT ON COLUMN condiciones_financiamiento.programa_id IS 'Código del programa con el cual estan relacionados las condiciones de financiamiento';
    "
  end

  def down
  end
end
