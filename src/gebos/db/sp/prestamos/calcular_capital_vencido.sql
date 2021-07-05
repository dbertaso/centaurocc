create or replace function calcular_capital_vencido(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
  
  --- ..............................................................................................................
  --- DB...... Esta funci�n adem�s de calcular el capital vencido, calcula el capital pagado parcialmente ......DB
  --- ..............................................................................................................
  
declare  
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;
  _capital_vencido float = 0;
  _capital_pago_parcial float = 0;  
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

   _capital_vencido = _capital_vencido + ((_plan_pago_cuota.amortizado) - _plan_pago_cuota.pago_capital);
    
	-- ........................................................................................
	-- Codigo que chequea si alguna cuota tiene un capital parcialmente pagado para actualizar
	-- la columna capital_pago_parcial en la tabla prestamo     ...................DB
	-- ........................................................................................

  _capital_pago_parcial = 0;
  
	if _plan_pago_cuota.pago_capital > 0 then
		 
		if _plan_pago_cuota.pago_capital <> _plan_pago_cuota.amortizado then
		
			_capital_pago_parcial = _plan_pago_cuota.pago_capital;

		end if;
	end if;

    
end loop;

    -- ........................................................................................
    -- Se agrego la actualizaci�n de la colunna capital_pago_parcial la cual es calculada
    -- en el segmento de c�digo anterior .....................DB
    -- ........................................................................................

	if p_proyeccion = false then

		update prestamo set 
			capital_vencido 	= _capital_vencido,
			capital_pago_parcial 	= _capital_pago_parcial  
		where 
			id = p_prestamo_id;

	else

		update prestamo set 
			proyeccion_capital_vencido = _capital_vencido 
		where 
			id = p_prestamo_id;

	end if;


  
  return false;
 
end;
$$ language 'plpgsql' volatile;
