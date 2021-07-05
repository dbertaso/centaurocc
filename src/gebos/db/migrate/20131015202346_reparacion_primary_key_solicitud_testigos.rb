class ReparacionPrimaryKeySolicitudTestigos < ActiveRecord::Migration
  def up
  #execute "ALTER TABLE solicitud_testigos DROP CONSTRAINT solicitud_testigos_pkey;
ALTER TABLE solicitud_testigos ADD CONSTRAINT solicitud_testigos_pkey PRIMARY KEY (id);"

  end

  def down
  end
end
