CREATE OR REPLACE FUNCTION ejecutar_cierre_financiero(p_ano int, p_mes int)
  RETURNS boolean AS
$BODY$
declare
--  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _prestamo_historico prestamo_historico%rowtype;
  _mes_cierre int;
  _ano_cierre int;
  _sql_execute varchar;
  _sql_fields varchar;
--  _fecha_proceso_next date;

--   Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
--  _cur_programa refcursor;


begin

	  _mes_cierre = p_mes;
	  _ano_cierre = p_ano;

    /*
    ---------------------------------------------------------
    Se elimina el registro si existe para evitar duplicidad
    de datos en el histórico
    ---------------------------------------------------------
    */

    select into _prestamo_historico *
    from
          prestamo_historico
    where
		      mes = _mes_cierre and
		      ano = _ano_cierre
		limit 1;

		if found then
		  delete
		  from
		        prestamo_historico
		  where
		        mes = _mes_cierre and
		        ano = _ano_cierre;
		end if;

    /*
    ----------------------------------------------------------
    Se genera el histórico de préstamos del mes y año
    correspndiente al cierre financiero
    ----------------------------------------------------------
    */
    --perform tabla_transaccion_prestamo('prestamo');

    _sql_fields = campos_tabla_prestamo('prestamo',false,false);

    _sql_execute = 'insert into prestamo_historico ' || ' (id, mes, ano, ' || _sql_fields
     || ') select id, ' || cast(p_mes as character varying) || ', ' || cast(p_ano as character varying) || ', ' || _sql_fields || ' from ' || 'prestamo';

    delete from prestamo_historico where mes = _mes_cierre and ano = _ano_cierre;

    raise notice 'sql execute  ========> %', _sql_execute;
    raise notice 'sql_fields ==========> %', _sql_fields;

    execute _sql_execute;

    --raise notice 'se activa %', _ano_cierre;

    return true;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;

