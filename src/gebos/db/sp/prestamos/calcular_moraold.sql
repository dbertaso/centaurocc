create or replace function calcular_mora(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_fecha_auxiliar date,
  p_proyeccion bool) returns bool as $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _parametro_general parametro_general%rowtype;
  _tasa_valor tasa_valor%rowtype;
  _fecha_calculo date;
  _tasa_calculo float;
  _cur_plan_pago_cuota refcursor;
  _intereses_mora float = 0;
  _intereses_mora_total numeric(16,2) = 0;
  _dias_mora integer = 0;
  _dias_mora_total integer = 0;
  _primera_cuota bool = true;
  _pago_interes_mora numeric(16,2) = 0;
  _base_calculo_intereses integer = 0;
  _fecha_inicio_mora_intermediado date;
  _fecha_mora_intermediado_anterior date;
  _fecha_mora_intermediado date;
  _vencido bool = false;
begin
  
  select into _parametro_general * from parametro_general limit 1;
  
  select into _prestamo * from prestamo
    where id = p_prestamo_id;
  
  if _prestamo.numero = 40 then
  	raise notice 'entra a calcular la mora ++++++++++++++++ ';
  end if;
  if _prestamo.intermediado = true and p_proyeccion = false then   
    _fecha_inicio_mora_intermediado =  agregar_dias(_prestamo.fecha_cobranza_intermediario,+_parametro_general.dias_gracia_mora+1);    
    _fecha_mora_intermediado_anterior = agregar_meses(_prestamo.fecha_cobranza_intermediario,-_prestamo.frecuencia_pago_intermediario);        
    _fecha_mora_intermediado_anterior = agregar_dias(_fecha_mora_intermediado_anterior,+_parametro_general.dias_gracia_mora+1);        
    
    if _fecha_inicio_mora_intermediado >p_fecha_evento and not(_prestamo.estatus = 'E') then
      return true;
    end if;

    if _fecha_inicio_mora_intermediado > p_fecha_evento then
      _fecha_mora_intermediado = _fecha_mora_intermediado_anterior;
    else
      _fecha_mora_intermediado = _fecha_inicio_mora_intermediado;
    end if;
  end if;  
  
      if p_proyeccion = false then
	  	update prestamo set dias_mora = 0, monto_mora = 0 where id = p_prestamo_id;
	  else
	  	update prestamo set proyeccion_dias_mora = 0, proyeccion_monto_mora = 0 where id = p_prestamo_id;
	  end if;
	  _base_calculo_intereses = _prestamo.base_calculo_intereses;
	  
	  
	  select into _plan_pago * from plan_pago 
	    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
	    
	  select into _tasa_valor * from tasa_valor where 
	    tasa_id = _prestamo.tasa_mora_id 
	    order by fecha_actualizacion desc limit 1;
	  if p_fecha_auxiliar = p_fecha_evento then 
	    _fecha_calculo = agregar_dias(p_fecha_evento, -_parametro_general.dias_gracia_mora);
	  else
	    _fecha_calculo = agregar_dias(p_fecha_auxiliar, -_parametro_general.dias_gracia_mora);
	  end if; 
	   if _prestamo.numero = 40 then
		   raise notice '************************* fecha_calculo_en_calcular_mmora____________%',_fecha_calculo;
		   raise notice '************************* tasa_mora_mora____________%',_tasa_valor.valor;
	   end if;
	  -- Recupera las cuotas menores a la fecha actual y que no esten pagadas
	  if _prestamo.intermediado = false then
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	      where plan_pago_id = _plan_pago.id and fecha < _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;
	   -- Originalmente antes de cambiar a tasa_nominal_anual
	   --_tasa_calculo = _tasa_valor.valor + _prestamo.tasa_vigente;
      else        
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	      where plan_pago_id = _plan_pago.id and fecha <= _fecha_mora_intermediado and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;      
      end if;	
	  loop
	    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
		exit when not found;
		if _prestamo.numero = 40 then
		  raise notice '********************** cuota numero_%',_plan_pago_cuota.numero;
		end if;
		_vencido = true;
		if _plan_pago_cuota.tipo_cuota = 'C' then
		  _tasa_calculo = _tasa_valor.valor + _plan_pago_cuota.tasa_nominal_anual;
		  if _prestamo.numero = 40 then
		  	raise notice '********************** tasa_calculo_%',_tasa_calculo;
		  end if;
		  if _base_calculo_intereses = 360 then
	  	    _dias_mora = (calcular_dias_360(_plan_pago_cuota.fecha, p_fecha_evento))-1;
	  	  else
	  	    _dias_mora = (p_fecha_evento - _plan_pago_cuota.fecha)-1;
	  	  end if;	
	  	      
		  _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _plan_pago_cuota.amortizado ) * _dias_mora;	
		  _intereses_mora_total = _intereses_mora_total + _intereses_mora;
		  _pago_interes_mora = _pago_interes_mora + _plan_pago_cuota.pago_interes_mora; 
		  if _primera_cuota = true then
		    _dias_mora_total = _dias_mora;
		    _primera_cuota = false;
		  end if;		
		end if;
		if _dias_mora > 0 then
		  update plan_pago_cuota set vencida = true ,	
		    dias_mora = _dias_mora,	  
		    interes_mora = (_intereses_mora - mora_exonerada)
		    where id = _plan_pago_cuota.id;
	    else
    	  update plan_pago_cuota set vencida = false ,	
		    dias_mora = 0,	  
		    interes_mora = 0
		    where id = _plan_pago_cuota.id;
	    end if;
	  end loop;
--	  if _dias_mora > 0 then
      if _vencido = true then
      	if p_proyeccion = false then
	    	update prestamo set dias_mora = _dias_mora_total, monto_mora =  _intereses_mora_total - _pago_interes_mora, estatus = 'E' where id = p_prestamo_id;
	    else
	    	update prestamo set proyeccion_dias_mora = _dias_mora_total, proyeccion_monto_mora =  _intereses_mora_total - _pago_interes_mora, proyeccion_estatus = 'E' where id = p_prestamo_id;
	    end if;
	  end if;
	  
	  perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);
  
  return true;
 
end;
$$ language 'plpgsql' volatile;