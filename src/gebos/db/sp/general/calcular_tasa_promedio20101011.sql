/*****************************************************************************************************

 Función que calcula la Tasa Promedio Ponderada, basada en los cambios de tasa ocurridos en el período
 dado.
 Params:
 @p_tasa_id		Identificador de la tasa de referencia
 @p_fecha_desde		Fecha inicio del período
 @p_fecha_hasta		Fecha fin del período

 Desarrollado por: Alexander Belisario
 Última Modificación: 11/10/2010
*****************************************************************************************************/
-- Function: calcular_tasa_promedio(integer, date, date)

-- DROP FUNCTION calcular_tasa_promedio(integer, date, date);

CREATE OR REPLACE FUNCTION calcular_tasa_promedio(p_tasa_id integer, p_fecha_desde date, p_fecha_hasta date)
  RETURNS numeric AS
$BODY$
declare


  _tasa_valor tasa_valor%rowtype;
  _cur_tasa_valor refcursor;

  _contador integer;
  _fecha_inicio date;
  _fecha_fin date;
  _tasa float;
  _tasa_promedio float;
  _tpp float;
  _dias integer;
  _diferencial_dias integer;

begin

    /*
    ---------------------
    Paso 1: Ubicar última tasa vigente
    ----------------------
    */
    select into _tasa_promedio valor
    from
      tasa_valor
    where tasa_id = p_tasa_id and fecha_resolucion_hasta is null;

    /*
    ---------------------
    Paso 2: Cambios de tasa ocurridos en el intervalo de fecha entre cuotas
    ----------------------
    */

        open _cur_tasa_valor for
          select *
          from tasa_valor
            where ((fecha_resolucion_desde between p_fecha_desde and p_fecha_hasta)
            or (fecha_resolucion_hasta between p_fecha_desde and p_fecha_hasta)) and tasa_id = p_tasa_id
          order by fecha_resolucion_desde asc;

	/*
    ----------------------
    Paso 3: Si existe cambios de tasa, comienza el calculo de la tpp
    ----------------------
    */
	--_tasa_promedio = prestamo.tasa_vigente;
	_tasa = 0.00;
	_contador = 0;
	_tpp = 0.00;
	_dias = 0;
	_fecha_inicio = p_fecha_desde;
	loop
	    fetch _cur_tasa_valor INTO _tasa_valor;
	    exit when not found;
	    _tasa = _tasa_valor.valor;
	    if _tasa_valor.fecha_resolucion_hasta is not null then
	     if p_fecha_hasta > _tasa_valor.fecha_resolucion_hasta then
              _fecha_fin = _tasa_valor.fecha_resolucion_hasta;
             else
              _fecha_fin = p_fecha_hasta;
             end if;
	    else
              _fecha_fin = p_fecha_hasta;
	    end if;

	    _diferencial_dias = _fecha_fin - _fecha_inicio;
	    _fecha_inicio = _fecha_fin;
	    _dias = _dias + _diferencial_dias;

            raise info '[GEBOS] calcular_tasa_promedio: dias_tasa_ %', _diferencial_dias;
            raise info '[GEBOS] calcular_tasa_promedio: tasa______ %', _tasa;

	    _tpp = _tpp + (_tasa * _diferencial_dias);
	    _contador = _contador + 1;
	end loop;
        raise info '[GEBOS] calcular_tasa_promedio: DIAS______ %', _dias;
	if _tpp > 0 and _dias > 0 then
          _tasa_promedio = _tpp / _dias;
	end if;
          raise info '[GEBOS] calcular_tasa_promedio: tasa______ %', _tasa_promedio;
  return _tasa_promedio;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;

