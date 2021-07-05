class CreateProductoFormulas < ActiveRecord::Migration
  def change
    create_table :producto_formulas do |t|

      t.timestamps
    end
  end
end
