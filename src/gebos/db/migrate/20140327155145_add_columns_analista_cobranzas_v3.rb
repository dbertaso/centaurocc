
# encoding: utf-8

class AddColumnsAnalistaCobranzasV3 < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE analista_cobranzas ADD COLUMN letra_cedula char(1);
      ALTER TABLE analista_cobranzas ADD COLUMN cedula integer;

      COMMENT ON COLUMN analista_cobranzas.letra_cedula IS 'Indica si el analista es (V)venezolano o (E)xtranjero';
      COMMENT ON COLUMN analista_cobranzas.segundo_nombre IS 'Numero de cedula del analista';
      
    "


  end


end
