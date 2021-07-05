-- Function: calcular_mora(integer, date, date, boolean, double precision)

-- DROP FUNCTION calcular_mora(integer, date, date, boolean, double precision);

CREATE OR REPLACE FUNCTION calcular_mora(p_prestamo_id integer, p_fecha_evento date, p_fecha_auxiliar date, p_proyeccion boolean, p_valor double precision)
  RETURNS boolean AS
$BODY$
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
  
  _plan_pago_mora plan_pago_mora%rowtype;
  _plan_pago_mora_aux plan_pago_mora%rowtype;
  _monto_base numeric(16,2) = 0;
  _plan_pago_mora_id integer;
  _cantidad_cuotas_mora integer = 0;
  _contador int8;

begin
  
  select into _parametro_general * from parametro_general limit 1;
  
  select into _prestamo * from prestamo
    where id = p_prestamo_id;
  
 -- if _prestamo.numero =8000000764 then
  --	raise notice 'entra a calcular la mora ++++++++++++++++ ';
  --end if;
  
  if _prestamo.intermediado = true and p_proyeccion = false then   
    _fecha_inicio_mora_intermediado =  agregar_dias(_prestamo.fecha_cobranza_intermediario,+_parametro_general.dias_gracia_mora+1);    
    _fecha_mora_intermediado_anterior = agregar_meses(_prestamo.fecha_cobranza_intermediario,-_prestamo.frecuencia_pago_intermediario);        
    _fecha_mora_intermediado_anterior = agregar_dias(_fecha_mora_intermediado_anterior,+_parametro_general.dias_gracia_mora+1);        
    
    if _fecha_inicio_mora_intermediado > p_fecha_evento and not(_prestamo.estatus = 'E') then
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
	    
	   raise notice '************************* fecha_evento  (calcular_mora)______________%', p_fecha_evento;
	   raise notice '************************* fecha_calculo (calcular_mora)_____________%', _fecha_calculo;
	  if p_fecha_auxiliar = p_fecha_evento then 
	    _fecha_calculo = agregar_dias(p_fecha_evento, -(_parametro_general.dias_gracia_mora-1));
	  else
	    _fecha_calculo = agregar_dias(p_fecha_auxiliar, -(_parametro_general.dias_gracia_mora-1));
	  end if;
	  
	  -- if _prestamo.numero =  8000000764 then
	   --raise notice '************************* fecha_axiliar____________%',p_fecha_auxiliar;
	   raise notice '************************* fecha_calculo_en_calcular_mora (calcular_mora)_____________%',_fecha_calculo;
		 --  raise notice '************************* tasa_mora_mora____________%',_tasa_valor.valor;
	   --end if;
	  -- Recupera las cuotas menores a la fecha actual y que no esten pagadas
	  
	/*
	---------------------------------------------------------------------------------
	Se comento la verificacion del prestamo intermediado para el calculo de mora
	se calculara la mora de prestamos intermediados y no intermediados de la 
	misma manera
	---------------------------------------------------------------------------------
	
	if _prestamo.intermediado = false then
	  
	   --if _prestamo.numero =  8000000764 then
		--   raise notice '************************* VA HACER EL SELECT PARA BUSCAR LAS CUOTAS VENCIDAS____________';		   
	   --end if;
	   
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	      where plan_pago_id = _plan_pago.id and fecha <= _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;
	      
	   -- Originalmente antes de -467.88
cambiar a tasa_nominal_anual
	   --_tasa_calculo = _tasa_valor.valor + _prestamo.tasa_vigente;
	else        
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	      where plan_pago_id = _plan_pago.id and fecha <= _fecha_mora_intermediado and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) order by fecha asc;      
	end if;
	*/
	
	open _cur_plan_pago_cuota for 
		select 	* 
		from 
			plan_pago_cuota 
		where 
			plan_pago_id = _plan_pago.id and 
			fecha <= _fecha_calculo 
			and (tipo_cuota = 'C' or tipo_cuota = 'G')
			and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ) 
		order by
			fecha asc;
			      
	 -- Fin de la modificacion

	  _contador = 0;
	  loop

	    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
		exit when not found;
		--if _prestamo.numero =  8000000764 then
		--  raise notice '********************** cuota numero_%',_plan_pago_cuota.numero;
		--end if;
		_vencido = true;
		_contador = _contador + 1;
		if _plan_pago_cuota.tipo_cuota = 'C' then
                  -- se elimino la penalizacion se sumar la tasa a la tasa de mora para calcular esta.
		  -- 04/03/2008 Orden Ejecutiva de Miguel Torres

		  -- Se revirtio la modificacion arriba mencionada por orden ejecutiva de Miguel Torres
		  -- 07/04/2008

		  _tasa_calculo = _tasa_valor.valor + _plan_pago_cuota.tasa_nominal_anual;

		  --_tasa_calculo = _tasa_valor.valor;
		 -- if _prestamo.numero =  8000000764 then
		 -- 	raise notice '********************** tasa_calculo_%',_tasa_calculo;
		 -- end if;
		   
		  /* se comento la instruccion donde se resta el monto pagado de la mora ya que el
		     mismo se restara al momento del pago ( Diego Bertaso 15/04/2008)
		  */

		  -- _monto_base = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;

		  /* La mora se calculara de ahora en adelante utilizando el monto total del
		     capital de la cuota ya que se restara el monto pagado de la mora al momento del 
		     pago (Diego Bertaso 15/04/2008)

		     Diego Bertaso 15/05/2008

		     Si la mora pagada es cero y el pago de capital es mayor que cero se resta
		     al monto del capital de la cuota el monto pagado para el cálculo de la mora
		     de lo contrario se usa el monto del capital de la cuota
		  */

		
		  if _plan_pago_cuota.pago_capital > 0 then
		     
			 --raise notice '????????????????_paso_por_if__%', _plan_pago_cuota.pago_capital;
			_monto_base = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;
			 --raise notice '????????????????_MONTO_BASE__%', _monto_base;
		     
		  else
		  
			_monto_base = _plan_pago_cuota.amortizado;
			
		  end if;


		/* Se elimino la busqueda por monto base por no ser necesario */
		--select into _plan_pago_mora * from plan_pago_mora 
	        --where plan_pago_cuota_id = _plan_pago_cuota.id order by fecha_fin desc limit 1;
	    
	      select into _plan_pago_mora_aux * from plan_pago_mora 
	        where plan_pago_cuota_id = _plan_pago_cuota.id order by fecha_fin desc limit 1;

	      /*
	      if _plan_pago_mora.id is not null then
	        update plan_pago_mora set fecha_fin = p_fecha_evento where id = _plan_pago_mora.id;
	        _plan_pago_mora_id = _plan_pago_mora.id;
	      else*/
	      
		if _plan_pago_mora_aux.id is null then
			insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital, valor) values(_plan_pago_cuota.id, _tasa_calculo, _plan_pago_cuota.fecha, p_fecha_evento, _monto_base, p_valor);  
		else
		
			insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital, valor) values(_plan_pago_cuota.id, _tasa_calculo, agregar_dias(_plan_pago_mora_aux.fecha_fin, 1), p_fecha_evento, _monto_base, p_valor);  
		end if;
		
		_plan_pago_mora_id = currval('plan_pago_mora_id_seq'); 
	      		      	
	     -- end if;
		  
		select into _plan_pago_mora * from plan_pago_mora 
	        where plan_pago_cuota_id = _plan_pago_cuota.id and id = _plan_pago_mora_id;

	    	 --if _plan_pago_mora.fecha_inicio < _plan_pago_mora.fecha_fin then   
	    	    		  
			  if _base_calculo_intereses = 360 then
			    _dias_mora = (calcular_dias_360(_plan_pago_mora.fecha_inicio, _plan_pago_mora.fecha_fin))+1;

			    raise notice '????????????????_dias_mora__%', _dias_mora;

			  else
			    
			    /* Se modifico la funcion dias mora para base 365, se reemplazo la coma por el signo - Diego Bertaso */
			  
			    _dias_mora = (  _plan_pago_mora.fecha_fin - _plan_pago_mora.fecha_inicio)+1;
			  end if;
			  
		  --else
			  --_dias_mora = 0;
		  --end if;
		      
		  _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _plan_pago_mora.capital) * _dias_mora;	
		  _intereses_mora_total = _intereses_mora_total + _intereses_mora;
		  
		  raise notice '????????????????_interes_mora__%', _intereses_mora;
		  
		  update plan_pago_mora set monto = _intereses_mora, dias = _dias_mora where id = _plan_pago_mora_id;
		
		  
		  _pago_interes_mora = _pago_interes_mora + _plan_pago_cuota.pago_interes_mora;

		  if _primera_cuota = true then
		    _dias_mora_total = _dias_mora;
		    _primera_cuota = false;
		  end if;		
		end if;
		
		
	      delete from plan_pago_mora where plan_pago_cuota_id in (
	      select id from plan_pago_cuota where 
	      plan_pago_id = _plan_pago.id and fecha > _fecha_calculo and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ));
	   
	   
	   -- if _prestamo.numero =  8000000764 then
		--  	raise notice '********************** los_dias_mora_son_%',_dias_mora;
		  --end if;
	   
		if _dias_mora > 0 then
		  update plan_pago_cuota set vencida = true ,	
		    dias_mora = (select sum(dias) from plan_pago_mora where plan_pago_cuota_id = _plan_pago_cuota.id),	  
		    interes_mora = ((select sum(monto) from plan_pago_mora where plan_pago_cuota_id = _plan_pago_cuota.id ) - mora_exonerada)
		    where id = _plan_pago_cuota.id;
	    else
    	  update plan_pago_cuota set vencida = false ,	
		    dias_mora = 0,	  
		    interes_mora = 0
		    where id = _plan_pago_cuota.id;
	    end if;
	  end loop;
	  
	 if _contador = 0 then

	   delete from plan_pago_mora where plan_pago_cuota_id in (
	      select id from plan_pago_cuota where 
	      plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo  and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and ((estatus_pago = 'N' or estatus_pago = 'P') and vencida = true ));
	  
	   update  plan_pago_cuota set dias_mora = 0, interes_mora = 0 where 
	      plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo  and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and ((estatus_pago = 'N' or estatus_pago = 'P') and vencida = true );

	  else

		delete from plan_pago_mora where plan_pago_cuota_id in (
			select id from plan_pago_cuota where 
			plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
			--plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo  and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
			and ((estatus_pago = 'N' or estatus_pago = 'P') and vencida = true ));
	  
		update  plan_pago_cuota set dias_mora = 0, interes_mora = 0 where 
			plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
			--plan_pago_id = _plan_pago.id and fecha >= _fecha_calculo and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
			and ((estatus_pago = 'N' or estatus_pago = 'P') and vencida = true );

	  end if;
--	  if _dias_mora > 0 then
		--if _prestamo.numero =  8000000764 then
		--raise notice '????????????????_intereses_mora_total__%', _intereses_mora_total;
		--raise notice '????????????????_pago_interes_mora__%', _pago_interes_mora;
		--end if;
      if _vencido = true then
      	if p_proyeccion = false then
--	    	update prestamo set dias_mora = _dias_mora_total, monto_mora =  _intereses_mora_total - _pago_interes_mora, estatus = 'E' where id = p_prestamo_id;

			/* Actualiza los dias de mora tomando como base la primera cuota vencida del plan_pago_cuota 
			   Diego Bertaso 2008-02-20*/

			select 
				into _plan_pago * 
			from 
				plan_pago 
			where 
				plan_pago.prestamo_id = _prestamo.id and 
				activo = true;

		
			select 
				into _plan_pago_cuota * 
			from 
				plan_pago_cuota 
			where 
				estatus_pago in ('N', 'P') and 
				vencida = true and 
				plan_pago_id = _plan_pago.id
			limit 1;

			if found then
				update prestamo 
				set 
					dias_mora = _plan_pago_cuota.dias_mora
				where
					prestamo.id = _prestamo.id;
			end if;
			
			update prestamo set monto_mora =  
			(select sum(abs(interes_mora - pago_interes_mora)) from plan_pago_cuota where estatus_pago in ('N', 'P') and vencida = true and plan_pago_id in 
			(select id from plan_pago where prestamo_id = _prestamo.id and activo = true)) 
			, estatus = 'E' where id = p_prestamo_id;
	    else
	    	update prestamo set proyeccion_dias_mora = _dias_mora_total, proyeccion_monto_mora =  _intereses_mora_total - _pago_interes_mora, proyeccion_estatus = 'E' where id = p_prestamo_id;
	    end if;
	  end if;
	  
	  select into  _cantidad_cuotas_mora count(*) from plan_pago_cuota where plan_pago_id = _plan_pago.id and estatus_pago in ('N', 'P') and vencida = true and dias_mora > 0;
	  
	  if _cantidad_cuotas_mora > 0 then
	  	--if _prestamo.numero =  8000000764 then
		--raise notice '????????????????_va poner el prestamo en vencido cuotas__%', _cantidad_cuotas_mora;
		--end if;
	  	update prestamo set estatus = 'E' where id = p_prestamo_id;
	  end if;
	  
	  
	  perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);
  
  
  
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_mora(integer, date, date, boolean, double precision) OWNER TO cartera;
