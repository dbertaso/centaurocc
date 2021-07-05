class AddColumnsAnalistaCobranzasV2 < ActiveRecord::Migration

  def change

    execute "

      ALTER TABLE analista_cobranzas ADD COLUMN primer_nombre character varying(30);
      ALTER TABLE analista_cobranzas ADD COLUMN segundo_nombre character varying(30);
      ALTER TABLE analista_cobranzas ADD COLUMN primer_apellido character varying(30);
      ALTER TABLE analista_cobranzas ADD COLUMN segundo_apellido character varying(30);

      COMMENT ON COLUMN analista_cobranzas.primer_nombre IS 'Primer nombre del analista de cobranzas';
      COMMENT ON COLUMN analista_cobranzas.segundo_nombre IS 'Segundo nombre del analista de cobranzas';
      COMMENT ON COLUMN analista_cobranzas.primer_apellido IS 'Primer apellido del analista de cobranzas';
      COMMENT ON COLUMN analista_cobranzas.segundo_apellido IS 'Segundo apellido del analista de cobranzas';
      
    "

  end


end
