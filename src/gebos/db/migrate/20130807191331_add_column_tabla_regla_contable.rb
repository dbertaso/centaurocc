class AddColumnTablaReglaContable < ActiveRecord::Migration
  def up
  execute "
          --ALTER TABLE regla_contable ADD COLUMN plazos char(1);
          
          COMMENT ON COLUMN regla_contable.plazos IS 'Indica si la regla contable aplica para financiamientos de (C)orto Plazo o Largo Plazo';
    "
  end

  def down
  execute "
        ALTER TABLE regla_contable DROP COLUMN plazos;
    "
  end
end
