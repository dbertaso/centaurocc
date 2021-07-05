# encoding: utf-8

class ViewCantidadIntegrantesEmpresa < ActiveRecord::Migration
  def up
    
    execute "
      CREATE OR REPLACE VIEW cantidad_integrantes_empresa AS

        select
              empresa_integrante.empresa_id as empresa_id,
              count(empresa_integrante.persona_id) as cantidad_integrantes
        from
              empresa
                join empresa_integrante on (empresa_integrante.empresa_id = empresa.id)
        group by
          empresa_integrante.empresa_id
        order by
          empresa_integrante.empresa_id;
    
    "
  end

  def down
  
    execute "
    
      DROP VIEW cantidad_integrantes_empresa;
    "
  end

end
