class AddColumnControlEnvioCobranza < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE control_envio_cobranza ADD COLUMN fecha_proceso date DEFAULT '1900-01-01'::date;

    "
  end

end
