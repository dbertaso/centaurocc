# encoding: utf-8
class AddColumnMonedaPlanInversion < ActiveRecord::Migration
  def up
    execute "
      ALTER TABLE plan_inversion ADD COLUMN moneda character varying(5);

      COMMENT ON COLUMN plan_inversion.moneda IS 'Abreviatura de la moneda del plan de inversión';
    "
  end

  def down
  end
end
