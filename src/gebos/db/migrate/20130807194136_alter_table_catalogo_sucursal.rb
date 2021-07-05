class AlterTableCatalogoSucursal < ActiveRecord::Migration
  def up
    execute "ALTER TABLE catalogo ADD COLUMN almacen_maquinaria_sucursal_id integer;
             ALTER TABLE catalogo ADD CONSTRAINT almacen_maquinaria_sucursal_id FOREIGN KEY (almacen_maquinaria_sucursal_id) REFERENCES almacen_maquinaria_sucursal (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
            "
  end

  def down
  end
end
