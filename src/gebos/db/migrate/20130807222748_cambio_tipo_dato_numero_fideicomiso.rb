# encoding: utf-8

class CambioTipoDatoNumeroFideicomiso < ActiveRecord::Migration
  def up
    
    execute "

            alter table fideicomiso drop column numero_fideicomiso;
            alter table fideicomiso add column numero_fideicomiso character varying(20);

          "
  end

  def down
  end
  
end
