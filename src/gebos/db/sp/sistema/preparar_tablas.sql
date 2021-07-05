create or replace function preparar_tablas() returns bool as $$
declare
  _cur_tablas refcursor;
  _tabla varchar;
  _sql_execute varchar;
begin

  open _cur_tablas for 
    select relname from pg_class where relkind = 'r' and not relname~'pg_.*' and not relname~'tr_.*' and not relname~'sql_.*' and relname<>'comprobante_contable' and relname<>'asiento_contable' and relname<>'transaccion' and relname<>'transaccion_accion';

  loop
    fetch _cur_tablas INTO _tabla;
	exit when not found;
	
    _sql_execute = 'drop trigger log_trigger_' || _tabla || ' on ' || _tabla;
	begin
      execute _sql_execute;
    exception when others then
      raise notice 'No existe el trigger log_trigger_%', _tabla;
    end;
    
    _sql_execute = 'drop trigger log_e_trigger_' || _tabla || ' on ' || _tabla;
	begin
      execute _sql_execute;
    exception when others then
      raise notice 'No existe el trigger log_e_trigger_%', _tabla;
    end;
	
	_sql_execute = 'create trigger log_trigger_' || _tabla || ' after insert or update on ' 
	  || _tabla || ' for each row execute procedure log_transaccion()';
	execute _sql_execute;
	
    raise notice 'Creado el trigger log_trigger_%', _tabla;
	
	_sql_execute = 'create trigger log_e_trigger_' || _tabla || ' before delete or update on ' 
	  || _tabla || ' for each row execute procedure log_transaccion()';
	execute _sql_execute;
	
    raise notice 'Creado el trigger log_e_trigger_%', _tabla;

  end loop;
  
  raise notice 'El procedimiento se ejecutó con éxito';
  
  return true;
 
end;
$$ language 'plpgsql' volatile;