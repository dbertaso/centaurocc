create or replace function actualizar_cuotas(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;
  _vencido bool = false;
begin


  select
  into
        _plan_pago *
  from
        plan_pago
  where
        prestamo_id = p_prestamo_id and
        activo = not(p_proyeccion) and
        proyeccion = p_proyeccion;

  if p_proyeccion = false then
    update
            prestamo
    set
            estatus = 'V'
    where
            id = p_prestamo_id and
            estatus not in ('J','L','K');
  else

    update
           prestamo
    set
           proyeccion_estatus = 'V'
    where
           id = p_prestamo_id and
           estatus not in('J','L','K');

  end if;


  if p_proyeccion = false then

    open _cur_plan_pago_cuota
    for
        select
                 *
        from
                 plan_pago_cuota
        where
                 plan_pago_id = _plan_pago.id  and
                 (fecha - p_fecha_evento) <= 1  and
                 tipo_cuota in ('C', 'G')       and
                 estatus_pago in ('N','P','X')
        order by
                 fecha asc;
  else

    open _cur_plan_pago_cuota
    for
        select
                *
        from
                plan_pago_cuota
        where
                plan_pago_id = _plan_pago.id and
                fecha <= p_fecha_evento and
                tipo_cuota in ('C','G' ) and
                estatus_pago in ('N','P','X')
        order by
                fecha asc;
  end if;

  loop

    fetch
          _cur_plan_pago_cuota
    INTO
          _plan_pago_cuota;
	exit when not found;

	_vencido = true;

    update
           plan_pago_cuota
    set
           vencida = true,
           estatus_pago = 'N'
	where
	       id = _plan_pago_cuota.id;

  end loop;

  if _vencido = true then

  	if p_proyeccion = false then
    	update prestamo set estatus = 'P' where id = p_prestamo_id and estatus not in ('J', 'L','K');
    else
	    update prestamo set proyeccion_estatus = 'P' where id = p_prestamo_id and estatus not in ('J','L','K');
    end if;

  end if;

  return false;

end;

$$ language 'plpgsql' volatile;

