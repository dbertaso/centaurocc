create or replace function reversar_transaccion(p_transaccion_id integer) returns bool as $$
declare
  _cur_acciones refcursor;
  _transaccion_accion record;
  _sql_execute varchar;
  _sql_fields varchar;
  _first_field bool;
  _prestamo record;
  _cur_comprobantes refcursor;
  _comprobante_contable record;
  _comprobante_contable_id integer;
  _cur_asientos refcursor;
  _asiento_contable record;
  _asiento_tipo char;
  _asiento_contable_id integer;
begin

  open _cur_acciones for
    select * from transaccion_accion where transaccion_id = p_transaccion_id order by id desc;


  loop
    fetch _cur_acciones INTO _transaccion_accion;
	exit when not found;

    if _transaccion_accion.tipo = 'A' then
      _sql_execute = 'delete from ' || _transaccion_accion.tabla || ' where id = ' || _transaccion_accion.tabla_id;
      raise notice 'Agregó el registro %',_transaccion_accion.tabla;
      raise notice 'Agregó el registro %',_transaccion_accion.tabla_id;
      raise notice 'Agregó la acción %',_transaccion_accion.id;
      execute _sql_execute;
    else

      if _transaccion_accion.tipo = 'E' then
    	_sql_fields = campos_tabla(_transaccion_accion.tabla, false, false);

        _sql_execute = 'insert into ' || _transaccion_accion.tabla || ' (' || _sql_fields || ')  '
          || ' select ' || _sql_fields || ' from tr_' || _transaccion_accion.tabla
          || ' where tr_transaccion_accion_id = ' || _transaccion_accion.id;

        raise notice 'Eliminó el registro %',_transaccion_accion.tabla;
        raise notice 'Eliminó el registro %',_transaccion_accion.tabla_id;
        raise notice 'Eliminó la acción %',_transaccion_accion.id;

        execute _sql_execute;

      elsif _transaccion_accion.tipo = 'M' then
    	_sql_fields = campos_tabla(_transaccion_accion.tabla, false, true);

        _sql_execute = 'update ' || _transaccion_accion.tabla || ' set ' || _sql_fields
          || ' from tr_' || _transaccion_accion.tabla
          || ' where tr_' || _transaccion_accion.tabla || '.tr_transaccion_accion_id = ' || _transaccion_accion.id
          || ' and tr_' || _transaccion_accion.tabla || '.id = ' || _transaccion_accion.tabla || '.id and tr_'
          || _transaccion_accion.tabla || '.tr_momento = ' || quote_literal('A');

        raise notice 'Actualizó el registro %',_transaccion_accion.tabla;
        raise notice 'Actualizó el registro %',_transaccion_accion.tabla_id;
        raise notice 'Actualizó la acción %',_transaccion_accion.id;

        execute _sql_execute;

        if _transaccion_accion.tabla = 'prestamo' then
          select into _prestamo * from prestamo where id = _transaccion_accion.tabla_id;
          raise notice 'Préstamo %',_prestamo.remanente_por_aplicar;
        end if;
      end if;
    end if;
  end loop;

  open _cur_comprobantes for
    select * from comprobante_contable  where transaccion_id = p_transaccion_id order by id asc;

  loop
    fetch _cur_comprobantes INTO _comprobante_contable;
	exit when not found;

	insert into comprobante_contable
                      (
                        fecha_registro,
                        fecha_comprobante,
                        enviado,
                        prestamo_id,
	              factura_id,
                        anio,
                        reverso,
                        reversado,
                        comprobante_reversado_id,
                        total_debe,
                        total_haber,
                        codigo_transaccion,
                        referencia
                      )
	      values
                      (
                        current_date,
                        current_date,
                        false,
                        _comprobante_contable.prestamo_id,
	              _comprobante_contable.factura_id,
	              _comprobante_contable.anio,
	              true,
                        false,
                        _comprobante_contable_id,
	              _comprobante_contable.total_haber,
                        _comprobante_contable.total_debe,
                        _comprobante_contable.codigo_transaccion,
                        'Reverso de ' || _comprobante_contable.referencia
                      );

          _comprobante_contable_id = currval('comprobante_contable_id_seq');

    open _cur_asientos for
	    select * from asiento_contable where
	      comprobante_contable_id = _comprobante_contable.id order by id asc;

    loop
      fetch _cur_asientos INTO _asiento_contable;
	  exit when not found;

	  if _asiento_contable.tipo = 'D' then
	    _asiento_tipo = 'H';
	  else
	    _asiento_tipo = 'D';
	  end if;

      insert
      into
              asiento_contable
                      (
                        comprobante_contable_id,
                        codigo_contable,
                        --cuenta_contable_presupuesto_id,
                        monto,
                        tipo)
               values
                      (
                        _comprobante_contable_id,
                        _asiento_contable.codigo_contable,
                        --_asiento_contable.cuenta_contable_presupuesto_id,
                        _asiento_contable.monto,
                        _asiento_tipo);
    end loop;

	update comprobante_contable set reversado = true, comprobante_reverso_id = _comprobante_contable_id
	  where id = _comprobante_contable.id;

	close _cur_asientos;

  end loop;

  update transaccion set reversada = true where id = p_transaccion_id;

          select into _prestamo * from prestamo where id = _transaccion_accion.tabla_id;
          raise notice 'Préstamo %',_prestamo.remanente_por_aplicar;

  return true;

end;
$$ language 'plpgsql' volatile;

