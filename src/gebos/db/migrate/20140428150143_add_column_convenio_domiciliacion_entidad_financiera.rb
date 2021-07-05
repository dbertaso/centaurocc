# encoding: utf-8
class AddColumnConvenioDomiciliacionEntidadFinanciera < ActiveRecord::Migration


  def change
    execute "
      ALTER TABLE entidad_financiera ADD COLUMN convenio_domiciliacion boolean DEFAULT false;

      COMMENT ON COLUMN entidad_financiera.convenio_domiciliacion IS 'Indica si la entidad financiera tiene convenio de domiciliacion de pagos con la institución';

      "

  end

end
