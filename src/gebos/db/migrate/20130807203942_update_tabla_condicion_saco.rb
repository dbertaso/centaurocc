# encoding: utf-8

class UpdateTablaCondicionSaco < ActiveRecord::Migration
  def up
    execute "
              ALTER TABLE condicion_saco ADD COLUMN acta_silo_id integer;
              ALTER TABLE condicion_saco ADD COLUMN silo_id integer;
          
              ALTER TABLE condicion_saco ADD FOREIGN KEY (silo_id) REFERENCES silo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
              ALTER TABLE condicion_saco ADD FOREIGN KEY (acta_silo_id) REFERENCES acta_silo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
          
              DROP INDEX condicion_saco_uq_nombre;
          
              ALTER TABLE boleta_arrime ADD COLUMN acta_silo_id integer;
              ALTER TABLE boleta_arrime ADD FOREIGN KEY (acta_silo_id) REFERENCES acta_silo (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
          
              ALTER TABLE boleta_arrime ADD COLUMN humedos integer;
          
              ALTER TABLE boleta_arrime ADD COLUMN total_humedos numeric(16,2) DEFAULT 0.00;
          
              ALTER TABLE boleta_arrime ADD COLUMN porcentaje_aplicado_humedo numeric(16,2) DEFAULT 0.00;
          
              COMMENT ON COLUMN boleta_arrime.humedos IS 'Cantidad de Sacos Húmedos';
          
              COMMENT ON COLUMN boleta_arrime.total_humedos IS 'Total kilogramos de Sacos Húmedos';
              COMMENT ON COLUMN boleta_arrime.porcentaje_aplicado_humedo IS 'Porcentaje aplicado para el calculo de kilogramos a descontar por sacos húmedos';
            "
  end

  def down
  end
end
