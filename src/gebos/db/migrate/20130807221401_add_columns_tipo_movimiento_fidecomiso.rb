# encoding: utf-8

class AddColumnsTipoMovimientoFidecomiso < ActiveRecord::Migration
  def up
    
        execute "
                  alter table tipo_movimiento_fideicomiso add column disponible boolean;
                  alter table tipo_movimiento_fideicomiso add column afecta_banco integer;
                  alter table tipo_movimiento_fideicomiso add column afecta_insumos integer;
                  alter table tipo_movimiento_fideicomiso add column afecta_gastos integer;
                  alter table tipo_movimiento_fideicomiso add column afecta_sras integer;
                "  

  end

  def down
  end
end
