class UpdateProgramaIdCondicionesFinanciamiento < ActiveRecord::Migration
  def up
    execute "
      update condiciones_financiamiento set programa_id = 62 where programa_id is null;
    "
  end

  def down
  end
end
