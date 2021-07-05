# encoding: utf-8
class AddNewIndexSolicitudTestigos < ActiveRecord::Migration
  def up
  execute " --ALTER TABLE solicitud_testigos DROP CONSTRAINT solicitud_testigos_pkey;
  ALTER TABLE solicitud_testigos ADD CONSTRAINT solicitud_testigos_id_pkey PRIMARY KEY (id);
  CREATE UNIQUE INDEX testigos_idx
   ON solicitud_testigos (solicitud_id ASC NULLS LAST, cedula_testigo ASC NULLS LAST);
  
  "
  
  end

  def down
  execute " "
  
  end
end
