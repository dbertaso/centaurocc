create or replace function reclasificar_cuota(
  p_prestamo_id integer,
  p_fecha date) returns bool as $$
declare  
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota record;
  _cur_plan_pago_cuota refcursor;  
  
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
    where vencida = true and estatus_pago <> 'T'
    and (p_fecha - fecha) = 6 
    and reclasificada = false
    and plan_pago_id = _plan_pago.id;
   
   
   
   loop
     fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
     exit when not found;   
       perform stc_reclasificacion_prestamo(
	     cast(_plan_pago_cuota.interes_corriente as float),
	     cast(_plan_pago_cuota.amortizado as float),
	     cast((_plan_pago_cuota.interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30) as float),
	     cast(_plan_pago_cuota.intereses_por_cobrar_al_30 as float), 
	     _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
		 _con_programa_origen_fondo.cuenta_contable_capital_id,
		 _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
	     p_fecha, p_fecha, p_prestamo_id, 0, 
	     cast(extract(year from _plan_pago_cuota.fecha) as integer));
	     
	   update plan_pago_cuota set reclasificada = true where id = _plan_pago_cuota.id;    
   end loop;   
    
   return false;

end;
$$ language 'plpgsql' volatile;
