class ColumnMonedaParametroGeneral < ActiveRecord::Migration
  def up
  	execute "ALTER TABLE parametro_general ADD COLUMN moneda_id integer;
ALTER TABLE parametro_general ADD CONSTRAINT fk_moneda_id FOREIGN KEY (moneda_id) REFERENCES moneda (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
"
  end

  def down
  end
end
