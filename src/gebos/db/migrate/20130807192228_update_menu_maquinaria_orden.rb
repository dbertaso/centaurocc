class UpdateMenuMaquinariaOrden < ActiveRecord::Migration
  def up
  execute "update menu set orden = 3 where id = 833;
             update menu set orden = 4 where id = 816;
             update menu set orden = 5 where id = 830;
             ALTER TABLE almacen_maquinaria ADD COLUMN contrato_maquinaria_equipo_id integer;
             ALTER TABLE almacen_maquinaria ADD CONSTRAINT contrato_maquinaria_equipo_fk FOREIGN KEY (contrato_maquinaria_equipo_id) REFERENCES contrato_maquinaria_equipo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;"
  end

  def down
  end
end
