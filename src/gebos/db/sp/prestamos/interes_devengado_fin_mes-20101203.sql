create or replace function interes_devengado_fin_mes(
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
  _con_fecha_primer_dia_mes date;
  
    
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
    where vencida = false 
    and estatus_pago = 'X'
    and fecha > p_fecha
    and plan_pago_id = _plan_pago.id
    order by fecha asc 
    limit 1;
   
   fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
   
   if found then   
    -- raise notice '*numero_cuota____________________%',_plan_pago_cuota.numero;
     --raise notice '*tipo_cuota____________________%',_plan_pago_cuota.tipo_cuota;
     --raise notice '*fecha_cuota____________________%',_plan_pago_cuota.fecha;
     --raise notice '*p_fecha____________________%',p_fecha;
     if extract(month from agregar_meses(_plan_pago_cuota.fecha, -_con_prestamo.frecuencia_pago))
        = extract(month from p_fecha) then  
       -- raise notice 'paso 1____________________';
        _dias = p_fecha - agregar_meses(_plan_pago_cuota.fecha, -_con_prestamo.frecuencia_pago);          
     else
        --raise notice 'paso 2____________________';
       -- _con_fecha_primer_dia_mes = agregar_meses(p_fecha, -1);
       -- raise notice '1_p_fecha_primer_dia_mes____________________%',_con_fecha_primer_dia_mes;
        _con_fecha_primer_dia_mes = agregar_dias(p_fecha, -(cast(extract(day from (p_fecha-1)) as integer)));
        --raise notice '2_p_fecha_primer_dia_mes____________________%',_con_fecha_primer_dia_mes;
        _dias = (p_fecha - _con_fecha_primer_dia_mes)+1; 
     end if;
     _saldo_insoluto = _plan_pago_cuota.saldo_insoluto + _plan_pago_cuota.amortizado;     
     _interes = ((_plan_pago_cuota.tasa_nominal_anual / 100) * (_dias / 365))  * _saldo_insoluto;    
     
     raise notice 'interes completo %', _interes;
     if _con_prestamo.intermediado = true then
        raise notice 'porcentaje_tasa_foncrei %',_con_prestamo.porcentaje_tasa_foncrei; 
     	_interes = _interes * (_con_prestamo.porcentaje_tasa_foncrei/100); 
     	raise notice 'interes_foncrei %',_interes; 
     end if;
    -- _interes = _dias / 365;
     --raise notice '*saldo_insoluto____________________%',_saldo_insoluto;
     --raise notice '*dias____________________%',_dias;
     --raise notice '*_plan_pago_cuota.tasa_nominal_anual____________________%',_plan_pago_cuota.tasa_nominal_anual;
     --raise notice '*interes___________________%',_interes;
    
     /*
     if _interes > 0 then
         update plan_pago_cuota set intereses_por_cobrar_al_30 = intereses_por_cobrar_al_30 + _interes where id = _plan_pago_cuota.id;
         
       --  raise notice '__________________________-cuenta_contable_id%',_con_programa_origen_fondo.cuenta_contable_ingreso_interes_id; 
	     perform stc_interes_devengado_fin_mes(
		     _interes, 
		     _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
		     p_fecha, p_fecha, p_prestamo_id, 0, 
		     cast(extract(year from _plan_pago_cuota.fecha) as integer));
	 end if;
	 */
   end if;   
   --raise exception 'se_termino_todo';
   return false;

end;
$$ language 'plpgsql' volatile;
