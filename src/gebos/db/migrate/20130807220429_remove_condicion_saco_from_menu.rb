# encoding: utf-8

class RemoveCondicionSacoFromMenu < ActiveRecord::Migration
  def up
    execute "
              delete from menu where trim(lower(nombre)) = lower('Condición de Saco');
              delete from opcion where trim(lower(nombre)) = lower('Condición de Saco');
    "
  end

  def down
  end
end
