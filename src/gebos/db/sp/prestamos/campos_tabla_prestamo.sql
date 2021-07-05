create or replace function campos_tabla_prestamo(
  p_tabla varchar,
  p_excluir_id bool,
  p_actualizar_transaccion bool
) returns varchar as $$
declare
  _cur_attributes refcursor;
  _attribute varchar;
  _sql_fields varchar;
  _first_field bool;
begin

  open _cur_attributes for 
    select attname from pg_attribute join pg_class on attrelid = pg_class.oid where relname = p_tabla and attisdropped = false;

  _sql_fields = '';
  _first_field = true;

  loop
    fetch _cur_attributes INTO _attribute;
  exit when not found;
  if _attribute <> 'tableoid' and _attribute <> 'cmax' and _attribute <> 'xmax' 
    and _attribute <> 'cmin' and _attribute <> 'xmin' and _attribute <> 'ctid' and (_attribute <> 'id') then

      if _first_field = false then
      _sql_fields = _sql_fields || ', ';
    else
        _first_field = false;
    end if;

      if p_actualizar_transaccion = false then      
        _sql_fields = _sql_fields || _attribute;
      else
        _sql_fields = _sql_fields || _attribute || ' = tr_' || p_tabla || '.' || _attribute;
      end if;
        
    end if;
    
     
  end loop;

  return _sql_fields;
  raise notice 'sql_fields %', _sql_fields;
 end;
 $$ language 'plpgsql' volatile;