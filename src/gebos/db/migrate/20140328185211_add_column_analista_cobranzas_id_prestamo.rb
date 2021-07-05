# encoding: utf-8

class AddColumnAnalistaCobranzasIdPrestamo < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE prestamo ADD COLUMN analista_cobranzas_id integer;

      ALTER TABLE prestamo ADD CONSTRAINT prestamo_fk_analista_cobranzas FOREIGN KEY (analista_cobranzas_id)
          REFERENCES analista_cobranzas (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION;

      COMMENT ON COLUMN prestamo.analista_cobranzas_id IS 'Analista asignado para efectuar la labor de cobranza del crédito';
    "
  end

end
