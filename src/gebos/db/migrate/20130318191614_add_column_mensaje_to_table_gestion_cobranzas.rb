class AddColumnMensajeToTableGestionCobranzas < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE gestion_cobranzas ADD COLUMN mensaje text;

      COMMENT ON COLUMN gestion_cobranzas.mensaje IS 'Mensaje de correo o de sms si el tipo de gestion de cobranzas es 1 (Correo) o 2 (SMS)';
      "
  end
end
