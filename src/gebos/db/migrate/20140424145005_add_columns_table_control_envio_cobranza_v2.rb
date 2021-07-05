# encoding: utf-8
class AddColumnsTableControlEnvioCobranzaV2 < ActiveRecord::Migration
  def change

    execute "

        ALTER TABLE control_envio_cobranza ADD COLUMN numero_cuenta character varying(20);
        ALTER TABLE control_envio_cobranza ADD COLUMN tipo_cuenta char(1);

        ALTER TABLE control_cobranza ADD COLUMN entidad_financiera_id integer;
        ALTER TABLE control_cobranza ADD COLUMN numero_cuenta character varying(20);
        ALTER TABLE control_cobranza ADD COLUMN tipo_cuenta char(1);

        COMMENT ON COLUMN control_envio_cobranza.entidad_financiera_id IS 'Código de la entidad financiera a la que se esta enviando el archivo de cobranza';
        COMMENT ON COLUMN control_envio_cobranza.numero_cuenta IS 'Número de cuenta de la institución a la cual se acreditara la cobranza';
        COMMENT ON COLUMN control_envio_cobranza.tipo_cuenta IS 'Tipo de cuenta';

        COMMENT ON COLUMN control_cobranza.entidad_financiera_id IS 'Código de la entidad financiera a la que se esta enviando el archivo de cobranza';
        COMMENT ON COLUMN control_cobranza.numero_cuenta IS 'Número de cuenta de la institución a la cual se acreditara la cobranza';
        COMMENT ON COLUMN control_cobranza.tipo_cuenta IS 'Tipo de cuenta';

    "
  end

  
end
