create or replace function interes_devengado_vencimiento_cuota(
  p_prestamo_id integer,
  p_fecha date) returns bool as $$
declare  
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota record;
  _cur_plan_pago_cuota refcursor;  
  _dias float = 0;
  _saldo_insoluto float = 0;
  _interes float = 0;
  
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;
  _con_prestamo prestamo%rowtype;
    
begin
   
   -- Inicio Contabilidad 
   select into _con_prestamo * from prestamo
    where id = p_prestamo_id;
     
   select into _con_solicitud * from solicitud
    where id = _con_prestamo.solicitud_id;
     
   select into _con_programa_origen_fondo * from programa_origen_fondo
    where programa_id = _con_solicitud.programa_id 
    and origen_fondo_id = _con_solicitud.origen_fondo_id;                        
   -- Fin Contabilidad
  
  select into _plan_pago * from plan_pago 
    where prestamo_id = p_prestamo_id and activo = true and proyeccion = false;
  
  open _cur_plan_pago_cuota for select *
    from plan_pago_cuota 
    where vencida = true 
    and estatus_pago in ('N', 'P')
    and fecha = p_fecha
    and pago_interes_corriente = 0 
    and plan_pago_id = _plan_pago.id
    order by fecha asc 
    limit 1;
   
   fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
   
   if found then   
    _interes = _plan_pago_cuota.interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30;
     if _interes > 0 then
         update plan_pago_cuota set intereses_por_cobrar_al_30 = intereses_por_cobrar_al_30 + _interes where id = _plan_pago_cuota.id;
                 
	     perform stc_interes_devengado_vencimiento_cuota(
		     _interes, 
		     _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
		     cast(_plan_pago_cuota.amortizado as float),
		     _con_programa_origen_fondo.cuenta_contable_capital_id,
		     _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
		     p_fecha, p_fecha, p_prestamo_id, 0, 
		     cast(extract(year from _plan_pago_cuota.fecha) as integer));
	 end if;
   end if;   
    
   return false;

end;
$$ language 'plpgsql' volatile;