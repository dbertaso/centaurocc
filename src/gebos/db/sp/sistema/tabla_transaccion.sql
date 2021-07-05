create or replace function tabla_transaccion(
  p_tablename varchar) returns bool as $$
declare
  _pg_type pg_type%rowtype;
  _sql_execute varchar;

begin

  select into _pg_type * from pg_type where typname = 'tr_' || p_tablename;

  if not found then
    
    _sql_execute = 'create table tr_' || p_tablename || ' as select * from ' 
      || p_tablename || ' where false; alter table tr_' || p_tablename 
      || ' add column tr_id serial primary key, add column tr_transaccion_accion_id integer, add column tr_momento char;';
    execute _sql_execute;
  end if;
  
  return false;
 
end;
$$ language 'plpgsql' volatile;