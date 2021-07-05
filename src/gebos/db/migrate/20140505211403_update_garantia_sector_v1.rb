class UpdateGarantiaSectorV1 < ActiveRecord::Migration
  def up
    execute "
    
    ALTER TABLE garantia_sector  DROP CONSTRAINT garantia_sector_tipo_garantia_id_fkey;
    
    
    "
  end

  def down
  end
end
