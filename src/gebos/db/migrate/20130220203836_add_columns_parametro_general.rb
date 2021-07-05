# encoding: utf-8


class AddColumnsParametroGeneral < ActiveRecord::Migration
  def up

    execute "

      ALTER TABLE parametro_general ADD COLUMN rango_dias_compromiso_pago integer;

      COMMENT ON COLUMN parametro_general.rango_dias_compromiso_pago IS 'Rango de gracia para cumplir con el compromiso de pago';
      "
  end

  def down

    execute "

      ALTER TABLE parametro_general DROP COLUMN integer;
      "
  end
end
