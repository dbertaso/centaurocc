-- Function: calcular_prestamo(integer, date, boolean)

-- DROP FUNCTION calcular_prestamo(integer, date, boolean);

CREATE OR REPLACE FUNCTION calcular_prestamo(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean)
  RETURNS boolean AS
$BODY$

declare

  _prestamo prestamo%rowtype;
  _parametro parametro_general%rowtype;
  _tasa_historico tasa_historico%rowtype;
  _plan_pago plan_pago%rowtype;
  _fecha_revision_tasa date;
  _cantidad_cuotas_mora integer = 0;
  _estatus char(1) = 'V';

begin

  /*
  -----------------------------
  Lectua de parametro general
  -----------------------------
  */

  select into
             _parametro *
  from
             parametro_general
  limit 1;

  /*
  ----------------------
  Lectura del Préstamo
  ----------------------
  */

  select into
             _prestamo *
  from
             prestamo
  where
             id = p_prestamo_id;

  raise notice 'ENTRA A CALCULAR EL PRESTAMO *********************************************';

  /*
  ----------------------
  Lectura de Plan Pago
  ----------------------
  */

  select into
              _plan_pago *
  from
              plan_pago
  where
              prestamo_id = p_prestamo_id and
              activo = not(p_proyeccion)  and
              proyeccion = p_proyeccion;


  if _prestamo.estatus <> 'L' then

	  perform actualizar_cuotas(p_prestamo_id, p_fecha_evento, p_proyeccion);

  end if;

  --perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, p_proyeccion);
  perform calcular_saldo_insoluto_dos(p_prestamo_id, p_fecha_evento, p_proyeccion);

  perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);

  perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);

  if _prestamo.estatus <> 'L' and _prestamo.estatus <> 'C' then

    perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, p_proyeccion);
  end if;

  perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, p_proyeccion);

  if _prestamo.estatus <> 'L' then

    select into
                _cantidad_cuotas_mora count(*)
    from
                plan_pago_cuota
    where
                plan_pago_id = _plan_pago.id and
                estatus_pago in ('N', 'P', 'H');

    _estatus = 'V';

    if _cantidad_cuotas_mora > 0 and
       _cantidad_cuotas_mora < _parametro.cuotas_pase_vencido then

      _estatus = 'H';
    end if;

    if _cantidad_cuotas_mora >= _parametro.cuotas_pase_vencido then

      _estatus = 'E';
    end if;

    update
           prestamo
    set
           estatus = _estatus
    where
           id = p_prestamo_id;

  end if;

  perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);

  if p_proyeccion = false then  

    -- Si el prestamo se paga en su totalidad lo actualiza a cancelado

    select into
                _prestamo *
    from
                prestamo
    where
                id = p_prestamo_id;

    select
    into
           _plan_pago *
    from
           plan_pago
    where
           plan_pago.prestamo_id = _prestamo.id;

    if found then

      if _prestamo.deuda <= 0 then

        raise notice 'Le Cambia el Estatus del Prestamo a Cancelado';

        update
              prestamo
        set
              estatus = 'C'
        where
              id = _prestamo.id;

      end if;

    end if;

  end if;

  return true;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_prestamo(integer, date, boolean) OWNER TO cartera;

