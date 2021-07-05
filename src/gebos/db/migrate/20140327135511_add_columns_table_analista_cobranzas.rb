class AddColumnsTableAnalistaCobranzas < ActiveRecord::Migration
  def change

    execute "

      ALTER TABLE analista_cobranzas ADD COLUMN sector_id integer;
      ALTER TABLE analista_cobranzas ADD COLUMN sub_sector_id integer;
      ALTER TABLE analista_cobranzas ADD COLUMN rubro_id integer;
      ALTER TABLE analista_cobranzas ADD COLUMN sub_rubro_id integer;
      ALTER TABLE analista_cobranzas ADD COLUMN actividad_id integer;

      ALTER TABLE analista_cobranzas ADD CONSTRAINT analista_cobranzas_fk_sector FOREIGN KEY (sector_id)
          REFERENCES sector (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION;
      ALTER TABLE analista_cobranzas ADD CONSTRAINT analista_cobranzas_fk_sub_sector FOREIGN KEY (sub_sector_id)
          REFERENCES sub_sector (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION;


      COMMENT ON COLUMN analista_cobranzas.sector_id IS 'Id del Sector productivo, clave foranea con tabla sector';
      COMMENT ON COLUMN analista_cobranzas.sub_sector_id IS 'Id del Sub Sector productivo, clave foranea con tabla sub_sector';
      COMMENT ON COLUMN analista_cobranzas.rubro_id IS 'Id del Rubro (Uso Futuro)';
      COMMENT ON COLUMN analista_cobranzas.sub_rubro_id IS 'Id del Sub Rubro (Uso Futuro)';
      COMMENT ON COLUMN analista_cobranzas.actividad_id IS 'Id de la Actividad Productiva (Uso Futuro)';

    "
  end

end
