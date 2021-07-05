create or replace function log_transaccion() returns trigger as $$
declare
  _tipo char;
  _cur_attributes refcursor;
  _registro record;
  _registro_retorno record;
  _attribute varchar;
  _sql_execute varchar;
  _sql_fields varchar;
  _first_field bool;
  _transaccion_id integer;
  _table_name varchar;
  _transaccion_accion_id integer;
  _t_momento char;
begin

  _table_name = cast(TG_RELNAME as varchar);
  
  begin

	  if TG_OP = 'INSERT' then
	    _tipo = 'A';
	    _registro = NEW;
	    _registro_retorno = NEW;
	    _t_momento = 'D';
	    --raise notice 'SE AGREGO CON____%,', _registro.id;
	  elsif TG_OP = 'UPDATE' then
	    _tipo = 'M';
	    if TG_WHEN = 'BEFORE' then
	      _registro = OLD;
	      _registro_retorno = NEW;
	      _t_momento = 'A';
	    elsif TG_WHEN = 'AFTER' then
	      _registro = NEW;
	      _registro_retorno = NEW;
	      _t_momento = 'D';
	    end if;
	    --raise notice 'SE MODIFICO CON____%,', _registro.id;
	  elsif TG_OP = 'DELETE' then
	    _tipo = 'E';
	    _registro = OLD;
	    _registro_retorno = OLD;
	    _t_momento = 'A';
		--raise notice 'SE ELIMINO CON____%,', _registro.id;
	  end if;
  
    _transaccion_id = currval('transaccion_id_seq');    
    
  

  
  if not (TG_OP = 'UPDATE' and TG_WHEN = 'AFTER') then
    insert into transaccion_accion (transaccion_id, tipo, tabla, tabla_id) values(_transaccion_id, _tipo, _table_name, _registro.id);
  end if;
  
  _transaccion_accion_id = currval('transaccion_accion_id_seq');
  
  perform tabla_transaccion(_table_name);
  
  _sql_fields = campos_tabla(_table_name, false, false);
  
  _sql_execute = 'insert into tr_' || _table_name || ' (tr_transaccion_accion_id, tr_momento, ' || _sql_fields
    || ') select ' || _transaccion_accion_id || ', ' || quote_literal(_t_momento) || ', ' || _sql_fields || ' from ' || _table_name 
    ||' where id = ' || _registro.id;
  
  execute _sql_execute;
  
  return _registro_retorno;
 exception when others then
    return _registro_retorno;
  end;
end;
$$ language 'plpgsql' volatile;