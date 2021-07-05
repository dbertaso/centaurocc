create or replace function calcular_interes_vencido(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;

    -- Cursor para calcular el resto de las cuotas que tienen interes diferido

  _cur_plan_pago_diferido refcursor;

  _interes_vencido float = 0;
  _interes_diferido_vencido float = 0;
  _interes_desembolso_vencido float = 0;
  _interes_diferido_por_vencer float = 0;
begin

  select into _plan_pago * from plan_pago
    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;

-- Recupera las cuotas menores a la fecha actual y que no esten pagadas
  open _cur_plan_pago_cuota for select * from plan_pago_cuota
    where plan_pago_id = _plan_pago.id and estatus_pago <> 'T'
    and vencida = true and fecha <= (p_fecha_evento + 1);

loop
    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
	exit when not found;

    _interes_vencido = _interes_vencido + ((_plan_pago_cuota.interes_corriente) - _plan_pago_cuota.pago_interes_corriente);
    _interes_desembolso_vencido = _interes_desembolso_vencido + ((_plan_pago_cuota.interes_desembolso) - _plan_pago_cuota.pago_interes_desembolso);
    if _plan_pago_cuota.tipo_cuota = 'C' then
        _interes_diferido_vencido = _interes_diferido_vencido + ((_plan_pago_cuota.interes_diferido) - _plan_pago_cuota.pago_interes_diferido);
    end if;

end loop;


 -- Recupera las cuotas exigibles y no exigibles para el total del interes diferido .............................................................DB

  open _cur_plan_pago_diferido for select * from plan_pago_cuota

    where plan_pago_id = _plan_pago.id and (estatus_pago = 'X'

    or estatus_pago = 'N' or estatus_pago = 'P');


 -- Totaliza las cuotas exigibles y no exigibles para el total del interes diferido por Vencer.....................................................DB

loop

    fetch _cur_plan_pago_diferido  INTO _plan_pago_cuota;

	exit when not found;


    _interes_diferido_por_vencer = _interes_diferido_por_vencer + ((_plan_pago_cuota.interes_diferido) - _plan_pago_cuota.pago_interes_diferido);



end loop;

  if p_proyeccion = false then
    update prestamo set interes_vencido = _interes_vencido,
        interes_diferido_vencido = _interes_diferido_vencido,
        interes_desembolso_vencido = _interes_desembolso_vencido
        where id = p_prestamo_id;
  else
    update prestamo set proyeccion_interes_vencido = _interes_vencido,
        proyeccion_interes_diferido_vencido = _interes_diferido_vencido,
        proyeccion_interes_desembolso_vencido = _interes_desembolso_vencido
        where id = p_prestamo_id;
  end if;
  return false;

end;
$$ language 'plpgsql' volatile;

