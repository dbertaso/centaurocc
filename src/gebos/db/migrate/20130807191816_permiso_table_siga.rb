# encoding: utf-8

class PermisoTableSiga < ActiveRecord::Migration
  def up
execute "  

CREATE ROLE siga_gebos_group VALID UNTIL 'infinity';
CREATE ROLE siga_gebos LOGIN ENCRYPTED PASSWORD 'md57dfb69fcca2d688445b9fed0a81c056d' VALID UNTIL 'infinity';
GRANT siga_gebos_group TO siga_gebos;
GRANT SELECT, UPDATE ON TABLE siga_causado TO GROUP siga_gebos_group WITH GRANT OPTION;
GRANT SELECT, UPDATE ON TABLE siga_compromiso TO GROUP siga_gebos_group WITH GRANT OPTION;
GRANT SELECT, UPDATE ON TABLE siga_pagado TO GROUP siga_gebos_group WITH GRANT OPTION;
"
  end

  def down
	execute "
REVOKE ALL ON TABLE siga_causado FROM GROUP siga_gebos_group;
REVOKE ALL ON TABLE siga_compromiso FROM GROUP siga_gebos_group;
REVOKE ALL ON TABLE siga_pagado FROM GROUP siga_gebos_group;"
  end
end
