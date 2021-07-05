# encoding: utf-8

class AlterCatalogoUltimosUsuarios < ActiveRecord::Migration
  def up
    
     execute "
     
              ALTER TABLE catalogo ADD COLUMN usuario_ultima_actualizacion_id integer;
             ALTER TABLE catalogo ADD COLUMN usuario_asignacion_id integer;
             
             ALTER TABLE catalogo ADD CONSTRAINT usuario_actualizacion_fk 
             FOREIGN KEY (usuario_ultima_actualizacion_id) 
             REFERENCES usuario (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
             
             ALTER TABLE catalogo ADD CONSTRAINT usuario_asignacion_fk 
             FOREIGN KEY (usuario_asignacion_id) 
             REFERENCES usuario (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
             "
  end

  def down
  end
end
