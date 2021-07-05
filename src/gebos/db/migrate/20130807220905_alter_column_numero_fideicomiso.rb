# encoding: utf-8

class AlterColumnNumeroFideicomiso < ActiveRecord::Migration
  def up
    
    execute "
        alter table fideicomiso alter column numero_fideicomiso type numeric;
       " 
  end

  def down
  end
end
