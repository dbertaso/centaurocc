# encoding: utf-8

class AlterTableCatalogoPorcentajeVariable < ActiveRecord::Migration
  def up
    execute "ALTER TABLE catalogo ALTER COLUMN por_seguro TYPE double precision;
             ALTER TABLE catalogo ALTER COLUMN por_seguro DROP DEFAULT;
             ALTER TABLE catalogo ALTER COLUMN por_flete TYPE double precision;
             ALTER TABLE catalogo ALTER COLUMN por_flete DROP DEFAULT;
             ALTER TABLE catalogo ALTER COLUMN por_gastos_administrativos TYPE double precision;
             ALTER TABLE catalogo ALTER COLUMN por_gastos_administrativos DROP DEFAULT;
             ALTER TABLE catalogo ALTER COLUMN por_nacionalizacion TYPE double precision;
             ALTER TABLE catalogo ALTER COLUMN por_nacionalizacion DROP DEFAULT;
             ALTER TABLE catalogo ALTER COLUMN por_almacenamiento TYPE double precision;
             ALTER TABLE catalogo ALTER COLUMN por_almacenamiento DROP DEFAULT;
            "
  end

  def down
  end
end
