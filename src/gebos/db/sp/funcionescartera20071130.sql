SET search_path = public, pg_catalog;

--
-- Name: actualizar_cuotas(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION actualizar_cuotas(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;  
  _cur_plan_pago_cuota refcursor;  
  _vencido bool = false;
begin
    select into _prestamo * from prestamo where id = p_prestamo_id;
    
	--if _prestamo.numero = 8000000764 then
   	--  raise notice 'ENTRA '; 
    --end if;
   
  select into _plan_pago * from plan_pago 
    where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
  if p_proyeccion = false then
    update prestamo set estatus = 'V' where id = p_prestamo_id;
  else
    update prestamo set proyeccion_estatus = 'V' where id = p_prestamo_id;
  end if;  
  if p_proyeccion = false then

   -- if _prestamo.numero = 8000000764 then
   --	  raise notice 'ENTRA 2 FECHA %', p_fecha_evento; 
   --	  raise notice 'ENTRA 2 ID_PLAN_PAGO %', _plan_pago.id; 
   -- end if;
    
    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago.id and (fecha - p_fecha_evento) <= 1 and ( tipo_cuota = 'C' or tipo_cuota = 'G' )
      and (estatus_pago = 'N' or estatus_pago = 'P' or estatus_pago = 'X') order by fecha asc;
      
  else
    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago.id and fecha <= p_fecha_evento and ( tipo_cuota = 'C' or tipo_cuota = 'G' )
      and (estatus_pago = 'N' or estatus_pago = 'P' or estatus_pago = 'X') order by fecha asc;
  end if;
  loop
    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
	exit when not found;
  -- if _prestamo.numero = 8000000764 then
  -- raise notice '????????????????????????? cuota numero %',_plan_pago_cuota.numero; 
  -- raise notice '????????????????????????? cuota tipo %',_plan_pago_cuota.tipo_cuota; 
  -- raise notice '????????????????????????? cuota id %',_plan_pago_cuota.id; 
  -- end if;
	_vencido = true;
    update plan_pago_cuota set vencida = true, estatus_pago = 'N'
	  where id = _plan_pago_cuota.id;	
  end loop;
  if _vencido = true then

  	if p_proyeccion = false then
    	update prestamo set estatus = 'P' where id = p_prestamo_id;    
    else
	    update prestamo set proyeccion_estatus = 'P' where id = p_prestamo_id;    
    end if;
  end if;
  
  return false;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.actualizar_cuotas(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: actualizar_cuotas_intermediado(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION actualizar_cuotas_intermediado(p_prestamo_id integer, p_fecha_evento date) RETURNS boolean
    AS $$





 declare





   _prestamo prestamo%rowtype;





   _plan_pago plan_pago%rowtype;





   _plan_pago_cuota plan_pago_cuota%rowtype;  





   _cur_plan_pago_cuota refcursor;  





   _vencido bool = false;





 begin





 





   select into _prestamo * from prestamo where id = p_prestamo_id;





     





   if found then    





     





 	  select into _plan_pago * from plan_pago 





 	    where prestamo_id = p_prestamo_id and activo = true and proyeccion = false;





 	  





 	  --update prestamo set estatus = 'V' where id = p_prestamo_id;





 	    





 	  





 	  open _cur_plan_pago_cuota for select * from plan_pago_cuota 





 	    where plan_pago_id = _plan_pago.id and fecha <= p_fecha_evento and ( tipo_cuota = 'C' or tipo_cuota = 'G' )





 	    and (estatus_pago = 'N' or estatus_pago = 'P' or estatus_pago = 'X') order by fecha asc;





 	





 	  loop





 	    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;





 		exit when not found;





 		





 		_vencido = true;			





 	    update plan_pago_cuota set vencida = true, estatus_pago = 'N'





 		  where id = _plan_pago_cuota.id;	





 	  end loop;





 	  





 	  if _prestamo.fecha_cobranza_intermediario <= p_fecha_evento and _prestamo.estatus <> 'E' then





 	    if _vencido = true then





 	      update prestamo set estatus = 'P' where id = p_prestamo_id;    





 	    end if;





       end if;  	  





   end if;





   return false;





  





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.actualizar_cuotas_intermediado(p_prestamo_id integer, p_fecha_evento date) OWNER TO cartera;

--
-- Name: actualizar_deuda_exigible(integer, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION actualizar_deuda_exigible(p_prestamo_id integer, p_proyeccion boolean) RETURNS boolean
    AS $$





    -- ......................................................................................................


    -- Se incluyÃ³ en el calculo de la deuda las columnas interes_diferido_por_vencer y capital_pago_parcial


    -- Se eliminÃ³ la columna interes_diferido_vencido porque en la deuda se debe incluir el


    -- interes diferido por vencer


    -- ......................................................................................................





declare





  _prestamo prestamo%rowtype;





begin





	select into 


		_prestamo * 


	from 


		prestamo 


	where 


		id = p_prestamo_id;





	-- Verifica que el monto de mora no es null si la proyecciÃ³n es false





	if p_proyeccion = false then	





		if _prestamo.monto_mora is null then





			update prestamo set monto_mora = 0 where id = p_prestamo_id; 





		end if;








		update prestamo 





			set 	deuda = 	((saldo_insoluto +


						interes_vencido + 


						interes_desembolso_vencido + 


						interes_diferido_por_vencer + 


						monto_mora + 


						causado_no_devengado)-


						(remanente_por_aplicar +


						 capital_pago_parcial)), 





				exigible = 


						((monto_cuotas_vencidas + 


						  monto_mora)-


						  remanente_por_aplicar)





				where 


						id = p_prestamo_id;


			else





				update prestamo 





					set 


						proyeccion_deuda = 	((proyeccion_saldo_insoluto +


									proyeccion_interes_vencido + 


									proyeccion_interes_desembolso_vencido + 


									proyeccion_interes_diferido_vencido + 


									proyeccion_monto_mora + 


									proyeccion_causado_no_devengado)-


									proyeccion_remanente_por_aplicar),





						proyeccion_exigible = 





									((proyeccion_monto_cuotas_vencidas + 


									  proyeccion_monto_mora)-


									  proyeccion_remanente_por_aplicar)





					where 


						id = p_prestamo_id;  








	end if;





  return false;

















 

















end;

















$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.actualizar_deuda_exigible(p_prestamo_id integer, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: actualizar_fecha_cambio_tasa(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION actualizar_fecha_cambio_tasa(p_prestamo_id integer, p_fecha_evento date) RETURNS boolean
    AS $$





 declare





   _prestamo prestamo%rowtype;





   _plan_pago_cuota plan_pago_cuota%rowtype;





   _fecha_revision_tasa date;





 





 begin





 





   select into _prestamo * from prestamo where id = p_prestamo_id;





 





   select into _plan_pago_cuota * from plan_pago_cuota 





     where plan_pago_id in (select id from plan_pago 





     where prestamo_id = p_prestamo_id and activo = true 





     and proyeccion = false) and tipo_cuota = 'C' order by numero desc limit 1;





 





   _fecha_revision_tasa = agregar_meses(_prestamo.fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);





      





   if  _fecha_revision_tasa < _plan_pago_cuota.fecha then   		    





     update prestamo set  fecha_revision_tasa =  _fecha_revision_tasa where id = _prestamo.id;	





   end if;





   





   return false;





  





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.actualizar_fecha_cambio_tasa(p_prestamo_id integer, p_fecha_evento date) OWNER TO cartera;

--
-- Name: actualizar_fecha_cobranza_intermediado(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION actualizar_fecha_cobranza_intermediado(p_prestamo_id integer, p_fecha_evento date) RETURNS boolean
    AS $$





 declare





   _prestamo prestamo%rowtype;





   _proxima_fecha date;





   _parametro_general parametro_general%rowtype;





 begin





 





   select into _parametro_general * from parametro_general limit 1;





   select into _prestamo * from prestamo where id = p_prestamo_id;





  





   if _prestamo.fecha_cobranza_intermediario < p_fecha_evento then





     _proxima_fecha = agregar_meses(_prestamo.fecha_cobranza_intermediario, _prestamo.frecuencia_pago_intermediario);  





    





 	if _prestamo.estatus = 'V' then





 	   update prestamo set fecha_cobranza_intermediario = _proxima_fecha where id = _prestamo.id;   	 





 	end if; 	





 	if (_prestamo.estatus = 'E' or _prestamo.estatus = 'P') and _proxima_fecha =  p_fecha_evento then





 	   update prestamo set fecha_cobranza_intermediario = _proxima_fecha where id = _prestamo.id;   	 





 	end if;	





   end if;  	  





 





   return false;





  





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.actualizar_fecha_cobranza_intermediado(p_prestamo_id integer, p_fecha_evento date) OWNER TO cartera;

--
-- Name: agregar_dias(date, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION agregar_dias(p_fecha date, p_dias integer) RETURNS date
    AS $$

 declare

   _fecha_fin date;

   _intervalo interval;

   _interval_units varchar;

 

 begin

   _interval_units := 'day';

   _intervalo := ('\'\'' || p_dias || ' ' ||

   _interval_units || '\'\'')::interval;

   select p_fecha + _intervalo  into _fecha_fin;

   return _fecha_fin;

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.agregar_dias(p_fecha date, p_dias integer) OWNER TO cartera;

--
-- Name: agregar_meses(date, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION agregar_meses(p_fecha date, p_meses integer) RETURNS date
    AS $$

 declare

   _fecha_fin date;

   _intervalo interval;

   _interval_units varchar;

 

 begin

   _interval_units := 'month';

   _intervalo := ('\'\'' || p_meses || ' ' ||

   _interval_units || '\'\'')::interval;

   select p_fecha + _intervalo  into _fecha_fin;

   return _fecha_fin;

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.agregar_meses(p_fecha date, p_meses integer) OWNER TO cartera;

--
-- Name: calcular_capital_vencido(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_capital_vencido(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$
  
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
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_capital_vencido(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_cartera(date, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_cartera(p_fecha date, p_oficina_id integer) RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _prestamo_t prestamo%rowtype;
  _cuota plan_pago_cuota%rowtype;
  _plan plan_pago%rowtype;		---> db 20070816
  _cuota1 plan_pago_cuota%rowtype;	---> db 20070816
  _cur_prestamo refcursor;
 _tasa_historico tasa_historico%rowtype;
  _producto producto%rowtype;
  _fecha_revision_tasa date;
  _tiene_tasa bool = false;
  _valor_tasa float = 0;
  _cheques text[][];
  _fecha_fin_mes date;
  _cur_cuotas_por_cobrar refcursor;
  _row_cuotas_por_cobrar record;
  _tiene_historico bool;
  _tiene_abono bool = false;
  _abono_monto_cuotas float;
  _titulo varchar;
  _prestamo_id integer;
  _plan_pago_id integer;
begin
  -- Determina cual es la fecha de fin de mes

  raise notice 'ENTRA A CALCULAR LA CARTERA ++++++++++++++++++++ ';
  
  if extract(day from p_fecha) = 31 then
      _fecha_fin_mes = p_fecha;
  else
	  _fecha_fin_mes = agregar_meses(p_fecha, 1);	 
	  _fecha_fin_mes = agregar_dias(_fecha_fin_mes, -cast(extract(day from _fecha_fin_mes) as integer));
  end if;
  
  /*
  -----------------------------------------------------------------------------
   Primer cursor (se selecciona solamente los prestamos vigentes para actuali
   zar, cuotas vencidas, interes causado, capital vencido, actualizar cuotas,
   saldo. Si el prestamo es intermediado calcula adicionalemente la fecha de
   cobranza
  -----------------------------------------------------------------------------
  */
  open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

	if _prestamo.intermediado = false then
	 -- raise notice 'no es intermediado PRETAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;	
	   perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 
	   perform actualizar_fecha_cobranza_intermediado(_prestamo.id, p_fecha); 
	end if;
    
	perform calcular_saldo_insoluto(_prestamo.id, p_fecha, false); 	
	perform calcular_interes_vencido(_prestamo.id, p_fecha, false);	
	perform calcular_capital_vencido(_prestamo.id, p_fecha, false);	
	perform calcular_interes_causado(_prestamo.id, p_fecha, false);        
	perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);
	
    perform calcular_mora(_prestamo.id, p_fecha, p_fecha, false);
    perform actualizar_deuda_exigible(_prestamo.id, false);
  end loop;
  
  close _cur_prestamo;
  
  /*
  -----------------------------------------------------------------------------
   Segundo Cursor (se selecciona solamente los prestamos vencidos y durante la
   gracia de la mora para ejecutar los pagos de cuota siempre que haya un rema
   nente por aplicar
  -----------------------------------------------------------------------------
  */

  open _cur_prestamo for select * from 
    prestamo where estatus in ('E', 'P') and remanente_por_aplicar > 0 order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	perform iniciar_transaccion(
		_prestamo.id, 1,
		'p_pago_ordinario', 
		'L', 'Pago Ordinario (Cierre) para el prÃ©stamo NÃºmero '||_prestamo.numero);
	
	perform ejecutar_pago(
				_prestamo.cliente_id,
				_cheques,
				_prestamo.id,
				'O',
				0,
				p_oficina_id,
				p_fecha,
				p_fecha,
				null,
				0,
				null,
				true,false, false);
	
  end loop; 

  close _cur_prestamo;

   /*
  -----------------------------------------------------------------------------
   Tercer cursor (se selecciona solamente los prestamos vigentes solamente para
   actualizar cuotas intermediado
  -----------------------------------------------------------------------------
  */

  open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	if _prestamo.intermediado = false then
	  -- perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 	   
	end if;
	
  end loop;

  close _cur_prestamo;  
  
--  open _cur_prestamo for select * from 
--    prestamo where estatus in ('V') and remanente_por_aplicar > 0 
--       order by id;
--  loop
--    fetch _cur_prestamo INTO _prestamo;
--	exit when not found;
	
--	open _cur_cuotas_por_cobrar for select count(id) as cantidad from 
--        plan_pago_cuota where 
--        fecha > p_fecha and tipo_cuota = 'C'
--        and plan_pago_id in (select id from plan_pago 
--        where prestamo_id = _prestamo.id and activo = true and proyeccion = false);  
    
--    fetch _cur_cuotas_por_cobrar INTO _row_cuotas_por_cobrar;
--    if _row_cuotas_por_cobrar.cantidad >= 1  then
	
--		_valor_tasa = 0;
--		_tiene_tasa = false;
--		if (_prestamo.fecha_revision_tasa = p_fecha or _prestamo.dia_facturacion = extract(day from p_fecha)) then	    
--		    _fecha_revision_tasa = _prestamo.fecha_revision_tasa;	    
--		    select into _tasa_historico * from tasa_historico
--		      where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1;
--		    if (_tasa_historico.tasa_cliente <> _prestamo.tasa_vigente)  then    
--		      _valor_tasa = _tasa_historico.tasa_cliente; 	
--		      _tiene_tasa = true;   	     
--		      insert into prestamo_tasa_historico 
--		        (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
--		        values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
--		        _tasa_historico.tasa_cliente, _prestamo.id, _tasa_historico.id, p_fecha);
		        
--		        _fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
		    
--		        update prestamo set  fecha_revision_tasa =  _fecha_revision_tasa, 
--		          tasa_vigente = _valor_tasa
--		          where id = _prestamo.id;	   
		        		        
--		    end if;
--		  end if;
	
--          perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, _tiene_tasa, _valor_tasa, true, _prestamo.remanente_por_aplicar,0,0);
--		  update prestamo set remanente_por_aplicar = 0 where id = _prestamo.id;
		    
 --   end	if;    
 --   close _cur_cuotas_por_cobrar;
 -- end loop;
 -- close _cur_prestamo;  
  
  
   /*
  -----------------------------------------------------------------------------
   Cuarto cursor (se selecciona solamente los prestamos vigentes para actuali
   zar, cuotas vencidas, interes causado, capital vencido, actualizar cuotas,
   saldo. Si el prestamo es intermediado calcula adicionalemente la fecha de
   cobranza
  -----------------------------------------------------------------------------
  */
 
  
  
  open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	if _prestamo.intermediado = false then
	 -- raise notice 'no es intermediado PRETAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;	
	   perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 
	   perform actualizar_fecha_cobranza_intermediado(_prestamo.id, p_fecha); 
	end if;
    

  end loop;
  
  close _cur_prestamo;
  
  /*
  -------------------------------------------------------------------------------
  La rutina que viene a continuacion verifica si aplica una generacion de un nue
  vo plan pago producto de un abono extraordinario o un cambio de tasa o ambos
  inclusive
  
  Modificacion realizada por Diego Bertaso
  Fecha: 16/08/2007
  ------------------------------------------------------------------------------
  */

  
  open _cur_prestamo for select * from prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A')   	 
  	and dia_facturacion = cast(extract(day from p_fecha) as integer) 
  	order by id;
 

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;
	_tiene_abono = false;

	raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

	/*
        ------------------------------------------------------------------------------------------
        Diego Bertaso
        Se incluyo la validacion del mes y el ano de la cuota ya que en los prestamos trimestrales
        se generaba un plan pago antes de la fecha focal (cuando coincidia el dia de facturacion
        fecha: 20070816
	------------------------------------------------------------------------------------------
	*/

	select into _plan * from plan_pago  where prestamo_id = _prestamo.id and activo = true and proyeccion = false;

	raise notice 'plan pago del prestamo +++++++%', _plan.id;
	raise notice 'fecha proceso +++++++%', p_fecha;

	select into _cuota1 * from plan_pago_cuota 
			where fecha = p_fecha and 
			      plan_pago_id = _plan.id;
						 

	raise notice 'id de la cuota +++++++%', _cuota1.id;

        if _cuota1.id is not null then

		raise notice 'entro en el primer if +++++++%', _prestamo.numero;

		if cast(extract(day from _cuota1.fecha) as integer) = _prestamo.dia_facturacion then

		raise notice 'entro en el segundo if +++++++%', _prestamo.numero;

	---> fin del cambio

        
	raise notice 'estatus ++++++++++++++++++++ %', _prestamo.estatus;
	raise notice 'remanente por aplicar ++++++++++++++++++++ %', _prestamo.remanente_por_aplicar;
	
	if _prestamo.estatus = 'V' and _prestamo.remanente_por_aplicar > 0 then

                raise notice 'Entro a _prestamo.estatus = V and _prestamo.remanente_por_aplicar > 0 ++++++++++++++++++++ %', _prestamo.remanente_por_aplicar;

		open _cur_cuotas_por_cobrar 
				for select count(id) as cantidad from plan_pago_cuota 
					where
						fecha > p_fecha and tipo_cuota = 'C'
						and plan_pago_id in (select id from plan_pago 
						where prestamo_id = _prestamo.id and activo = true and proyeccion = false);

		fetch _cur_cuotas_por_cobrar INTO _row_cuotas_por_cobrar;

                raise notice 'leyo cuotas por cobrar ++++++++++++++++++++ %', _prestamo.numero;

		if _row_cuotas_por_cobrar.cantidad >= 1  then

			raise notice 'paso por cantidad de cuotas a cobrar mayor o igual que 1++++++++++++++++++++ %', _prestamo.numero;

			select into _producto * from producto where id = _prestamo.producto_id;

			if _producto.abono_cantidad_cuotas > 0 then
				select into _cuota * from plan_pago_cuota where estatus_pago = 'X' and plan_pago_id in (select id from plan_pago 
							where prestamo_id = _prestamo.id and activo = true and proyeccion = false); 

				raise notice 'parametro general exige 1 cuota minimo ++++++++++++++++++++ %', _prestamo.numero;

			       if _cuota.id is null then
					select into _cuota * from plan_pago_cuota where tipo_cuota  = 'G' and plan_pago_id in (select id from plan_pago 
					where prestamo_id = _prestamo.id and activo = true and proyeccion = false) order by numero asc; 
				end if;
	 
			       if _cuota.id is null then
				   select into _cuota * from plan_pago_cuota where tipo_cuota  = 'C' and plan_pago_id in (select id from plan_pago 
				       where prestamo_id = _prestamo.id and activo = true and proyeccion = false) order by numero asc; 
			       end if;

			       if (_cuota.valor_cuota*_producto.abono_cantidad_cuotas) <= _prestamo.remanente_por_aplicar then
				   _tiene_abono = true;
			       end if;    
			else
				raise notice 'Tiene abono = true ++++++++++++++++++++ %', _prestamo.numero;
				_tiene_abono = true;
			end if;	    	
		end if;
		/*
		--------------------------------------------------------------
		Diego Bertaso
		Se incluyo la instruccion cerrar el cursor ya que si existia
                mas de un prestamo con la condicion de abono se producia un 
                error y finalizaba abruptamente el cierre
                fecha: 20070816
		--------------------------------------------------------------
		*/
		close _cur_cuotas_por_cobrar;
	end if;

	_valor_tasa = 0;

    _tiene_tasa = false;   	 
    _tiene_historico = false;
    _fecha_revision_tasa = _prestamo.fecha_revision_tasa;	    
    
    select into _tasa_historico * from tasa_historico
      where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1;
    	if (_tasa_historico.tasa_cliente <> _prestamo.tasa_vigente)  and _prestamo.tasa_fija = false and ((_fecha_revision_tasa is null) or (_fecha_revision_tasa is not null and _fecha_revision_tasa = p_fecha) )  then            
      		_valor_tasa = _tasa_historico.tasa_cliente;  
			_tiene_historico = true;
			_tiene_tasa = true;
    	end if;
    
    	if _fecha_revision_tasa is not null and _fecha_revision_tasa = p_fecha then
        	_fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
          update prestamo set  fecha_revision_tasa =  _fecha_revision_tasa 
            where id = _prestamo.id;	           	
    	end if;	
    	
    	if _prestamo.tasa_forzada = true and _prestamo.tasa_forzada_fecha_vigencia < p_fecha then
          update prestamo set  tasa_forzada = false
            where id = _prestamo.id;	           	    		
    	end if;
    	
    	if _prestamo.tasa_forzada = true and _prestamo.tasa_vigente <> _prestamo.tasa_forzada_monto then
    	  _valor_tasa = _prestamo.tasa_forzada_monto;
          update prestamo set tasa_vigente = _valor_tasa
            where id = _prestamo.id;	       
           _tiene_tasa = true;   	        	
    	end if;
    	
    	if _prestamo.tasa_forzada = false and _tiene_tasa = true then
          update prestamo set tasa_vigente = _valor_tasa
            where id = _prestamo.id;	       
          _tiene_tasa = true;   	    
        end if;           
      
        if _tiene_abono = true and _tiene_tasa = false then

		raise notice 'Tiene abono = true y tiene tasa = false ++++++++++++++++++++ %', _prestamo.numero;
	        perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', 'Nuevo Plan Pago Abono Extraordinario (Cierre) para el prÃ©stamo NÃºmero '||_prestamo.numero);
        	perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, false, 0, true, _prestamo.remanente_por_aplicar,0,0);	      
        end if;
        
        if _tiene_tasa = true then
        	if _tiene_abono = true then
        		_titulo = 'Nuevo Plan Pago Cambio de Tasa/Abono Extraordinario (Cierre) para el prÃ©stamo NÃºmero ';
        	else
        		_titulo = 'Nuevo Plan Pago Cambio de Tasa (Cierre) para el prÃ©stamo NÃºmero ';
        	end if;
	        perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', _titulo||_prestamo.numero);          
	      perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, _tiene_tasa, _valor_tasa, _tiene_abono, _prestamo.remanente_por_aplicar,0,0);	      
	      if _tiene_historico = true and _prestamo.tasa_forzada = false then
		    insert into prestamo_tasa_historico 
	          (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
	          values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
	          _tasa_historico.tasa_cliente, _prestamo.id, _tasa_historico.id, p_fecha);	      
	      else    
		    insert into prestamo_tasa_historico 
	          (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
	          values(_valor_tasa, 0,
	          _valor_tasa, _prestamo.id, null, p_fecha);	      
          end if;  
        end if;
        if _tiene_abono = true then
		
		raise notice 'Actualizo remanente por aplicar = 0 ++++++++++++++++++++ %', _prestamo.numero;
        	update prestamo set remanente_por_aplicar = 0 where id = _prestamo.id;
        end if;
	end if;	--> if cast(extract(day from plan_pago_cuota.fecha) as integer) = _prestamo.dia_facturacion then
	
  end if; ---> _cuota1.id is not null then
  end loop;
  close _cur_prestamo;
  
  raise notice 'Finalizo loop de abono y cambio de tasa ++++++++++++++++++++ %', _prestamo.numero;

  open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;


  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;	
	if _prestamo.intermediado = false then
	   perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 	  
	end if;
  
	raise notice 'Ejecutando ultimo loop ++++++++++++++++++++ %', _prestamo.numero;

	
	perform calcular_saldo_insoluto(_prestamo.id, p_fecha, false); 
	perform calcular_interes_vencido(_prestamo.id, p_fecha, false);
	perform calcular_capital_vencido(_prestamo.id, p_fecha, false);
	perform calcular_interes_causado(_prestamo.id, p_fecha, false);
	perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);   
	perform calcular_mora(_prestamo.id, p_fecha, p_fecha, false); 
	perform actualizar_deuda_exigible(_prestamo.id, false);
    --NO VA perform reclasificar_cuota(_prestamo.id, p_fecha);       
    if _fecha_fin_mes = p_fecha  then        
      perform interes_devengado_fin_mes(_prestamo.id, p_fecha);   
    end if;
    if (extract (day from p_fecha) = extract(day from _prestamo.fecha_inicio)) then        
      perform eventos_vencimiento_cuota(_prestamo.id, p_fecha);   
    end if;
    if _prestamo.meses_fijos_sin_cambio_tasa > 0 and _prestamo.fecha_revision_tasa = p_fecha then
      perform actualizar_fecha_cambio_tasa(_prestamo.id, p_fecha);
    end if;
        
  end loop;
 
  close _cur_prestamo;

  raise notice 'se acabo esta vaina';
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_cartera(p_fecha date, p_oficina_id integer) OWNER TO cartera;

--
-- Name: calcular_cartera_programa(date, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_cartera_programa(p_fecha date, p_oficina_id integer, p_programa_id integer) RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _prestamo_t prestamo%rowtype;
  _cuota plan_pago_cuota%rowtype;
  _plan plan_pago%rowtype;		---> db 20070816
  _cuota1 plan_pago_cuota%rowtype;	---> db 20070816
  _programa programa%rowtype;		---> db 20071029
  _cur_prestamo refcursor;
 _tasa_historico tasa_historico%rowtype;
  _producto producto%rowtype;
  _fecha_revision_tasa date;
  _tiene_tasa bool = false;
  _valor_tasa float = 0;
  _cheques text[][];
  _fecha_fin_mes date;
  _cur_cuotas_por_cobrar refcursor;
  _row_cuotas_por_cobrar record;
  _tiene_historico bool;
  _tiene_abono bool = false;
  _abono_monto_cuotas float;
  _titulo varchar;
  _prestamo_id integer;
  _plan_pago_id integer;
  _nombre_programa varchar;
begin
  -- Determina cual es la fecha de fin de mes

  raise notice 'ENTRA A CALCULAR LA CARTERA ++++++++++++++++++++ ';
  --raise notice p_fecha;

  if extract(day from p_fecha) = 31 then
      _fecha_fin_mes = p_fecha;
  else
	  _fecha_fin_mes = agregar_meses(p_fecha, 1);	 
	  _fecha_fin_mes = agregar_dias(_fecha_fin_mes, -cast(extract(day from _fecha_fin_mes) as integer));
  end if;
  
  /*
  -----------------------------------------------------------------------------
   Primer cursor (se selecciona solamente los prestamos vigentes para actuali
   zar, cuotas vencidas, interes causado, capital vencido, actualizar cuotas,
   saldo. Si el prestamo es intermediado calcula adicionalemente la fecha de
   cobranza
  -----------------------------------------------------------------------------
  */
  open _cur_prestamo for select * from 
    prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id and
                                      solicitud.programa_id = p_programa_id)
                                      
    where prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by prestamo.numero;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	--raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

	if _prestamo.intermediado = false then
	 -- raise notice 'no es intermediado PRETAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;	
	   perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 
	   perform actualizar_fecha_cobranza_intermediado(_prestamo.id, p_fecha); 
	end if;
    
	perform calcular_saldo_insoluto(_prestamo.id, p_fecha, false); 	
	perform calcular_interes_vencido(_prestamo.id, p_fecha, false);	
	perform calcular_capital_vencido(_prestamo.id, p_fecha, false);	
	perform calcular_interes_causado(_prestamo.id, p_fecha, false);        
	perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);
	
	perform calcular_mora(_prestamo.id, p_fecha, p_fecha, false);
	perform actualizar_deuda_exigible(_prestamo.id, false);
  end loop;
  
  close _cur_prestamo;
  
   
  /*
  -----------------------------------------------------------------------------
   Segundo Cursor (se selecciona solamente los prestamos vencidos y durante la
   gracia de la mora para ejecutar los pagos de cuota siempre que haya un rema
   nente por aplicar
  -----------------------------------------------------------------------------
  */

  open _cur_prestamo for select * from 
    prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id and
                                      solicitud.programa_id = p_programa_id) 
   where 
	prestamo.estatus in ('E', 'P') and remanente_por_aplicar > 0
 
   order by prestamo.numero;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

        /*
        -------------------------------------------------------
        Actualización de señal de visita a true para los présta
        mos afectados por el pago
	-------------------------------------------------------
	*/

	update
		prestamo
	set
		senal_visita = true
	where
		prestamo.id = _prestamo.id;

	/*
	-----------------
	Proceso de Pago
	-----------------
	*/

	perform iniciar_transaccion(
		_prestamo.id, 1,
		'p_pago_ordinario', 
		'L', 'Pago Ordinario (Cierre) para el prÃ©stamo NÃºmero '||_prestamo.numero);
	
	perform ejecutar_pago(
				_prestamo.cliente_id,
				_cheques,
				_prestamo.id,
				'O',
				0,
				p_oficina_id,
				p_fecha,
				p_fecha,
				null,
				0,
				null,
				true,false, false);
	
  end loop; 

  close _cur_prestamo;

    
  /*
  -----------------------------------------------------------------------------
   Tercer cursor (se selecciona solamente los prestamos vigentes y con senal de
   visita = true, es decir que tuvieron un pago
  -----------------------------------------------------------------------------
  */

 
  open _cur_prestamo for select * from 
    prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id and
				      solicitud.programa_id = p_programa_id)
	where 
		prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') and
		prestamo.senal_visita = true
	order by 
		prestamo.numero;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	if _prestamo.intermediado = false then
	  perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 	   
	end if;
	
  end loop;

  close _cur_prestamo;  
  

  
  /*
  -------------------------------------------------------------------------------
  La rutina que viene a continuacion verifica si aplica una generacion de un nue
  vo plan pago producto de un abono extraordinario o un cambio de tasa o ambos
  inclusive
  
  Modificacion realizada por Diego Bertaso
  Fecha: 16/08/2007
  ------------------------------------------------------------------------------
  */

 
  open _cur_prestamo for select * from prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id and
									 solicitud.programa_id = p_programa_id)
	where 
		    prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A')   	 
		and dia_facturacion = cast(extract(day from p_fecha) as integer) 
  	order by prestamo.numero;
 

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;
	_tiene_abono = false;

	--raise notice 'PRESTAMO NUMERO ++++++++++++++++++++ %', _prestamo.numero;

	/*
       ------------------------------------------------------------------------------------------
        Diego Bertaso
        Se incluyo la validacion del mes y el ano de la cuota ya que en los prestamos trimestrales
        se generaba un plan pago antes de la fecha focal (cuando coincidia el dia de facturacion
        fecha: 20070816
	------------------------------------------------------------------------------------------
	*/

	
	select into _plan * from plan_pago  where prestamo_id = _prestamo.id and activo = true and proyeccion = false;

	--raise notice 'plan pago del prestamo +++++++%', _plan.id;
	--raise notice 'fecha proceso +++++++%', p_fecha;

	select into _cuota1 * from plan_pago_cuota 
			where fecha = p_fecha and 
			      plan_pago_id = _plan.id;
						 

	--raise notice 'id de la cuota +++++++%', _cuota1.id;

        if _cuota1.id is not null then

		--raise notice 'entro en el primer if +++++++%', _prestamo.numero;

		if cast(extract(day from _cuota1.fecha) as integer) = _prestamo.dia_facturacion then

		--raise notice 'entro en el segundo if +++++++%', _prestamo.numero;

	---> fin del cambio

        
	--raise notice 'estatus ++++++++++++++++++++ %', _prestamo.estatus;
	--raise notice 'remanente por aplicar ++++++++++++++++++++ %', _prestamo.remanente_por_aplicar;
	
	if _prestamo.estatus = 'V' and _prestamo.remanente_por_aplicar > 0 then

                --raise notice 'Entro a _prestamo.estatus = V and _prestamo.remanente_por_aplicar > 0 ++++++++++++++++++++ %', _prestamo.remanente_por_aplicar;

		open _cur_cuotas_por_cobrar 
				for select count(id) as cantidad from plan_pago_cuota 
					where
						fecha > p_fecha and tipo_cuota = 'C'
						and plan_pago_id in (select id from plan_pago 
						where prestamo_id = _prestamo.id and activo = true and proyeccion = false);

		fetch _cur_cuotas_por_cobrar INTO _row_cuotas_por_cobrar;

                --raise notice 'leyo cuotas por cobrar ++++++++++++++++++++ %', _prestamo.numero;

		if _row_cuotas_por_cobrar.cantidad >= 1  then

			--raise notice 'paso por cantidad de cuotas a cobrar mayor o igual que 1++++++++++++++++++++ %', _prestamo.numero;

			select into _producto * from producto where id = _prestamo.producto_id;

			if _producto.abono_cantidad_cuotas > 0 then
				select into _cuota * from plan_pago_cuota where estatus_pago = 'X' and plan_pago_id in (select id from plan_pago 
							where prestamo_id = _prestamo.id and activo = true and proyeccion = false); 

				--raise notice 'parametro general exige 1 cuota minimo ++++++++++++++++++++ %', _prestamo.numero;

			       if _cuota.id is null then
					select into _cuota * from plan_pago_cuota where tipo_cuota  = 'G' and plan_pago_id in (select id from plan_pago 
					where prestamo_id = _prestamo.id and activo = true and proyeccion = false) order by numero asc; 
				end if;
	 
			       if _cuota.id is null then
				   select into _cuota * from plan_pago_cuota where tipo_cuota  = 'C' and plan_pago_id in (select id from plan_pago 
				       where prestamo_id = _prestamo.id and activo = true and proyeccion = false) order by numero asc; 
			       end if;

			       if (_cuota.valor_cuota*_producto.abono_cantidad_cuotas) <= _prestamo.remanente_por_aplicar then
				   _tiene_abono = true;
			       end if;    
			else
				--raise notice 'Tiene abono = true ++++++++++++++++++++ %', _prestamo.numero;
				_tiene_abono = true;
			end if;	    	
		end if;
		/*
		--------------------------------------------------------------
		Diego Bertaso
		Se incluyo la instruccion cerrar el cursor ya que si existia
                mas de un prestamo con la condicion de abono se producia un 
                error y finalizaba abruptamente el cierre
                fecha: 20070816
		--------------------------------------------------------------
		*/
		
		close _cur_cuotas_por_cobrar;
	end if;

	_valor_tasa = 0;

    _tiene_tasa = false;   	 
    _tiene_historico = false;
    _fecha_revision_tasa = _prestamo.fecha_revision_tasa;	    
    
    select into _tasa_historico * from tasa_historico
      where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1;
    	if (_tasa_historico.tasa_cliente <> _prestamo.tasa_vigente)  and _prestamo.tasa_fija = false and ((_fecha_revision_tasa is null) or (_fecha_revision_tasa is not null and _fecha_revision_tasa = p_fecha) )  then            
      		_valor_tasa = _tasa_historico.tasa_cliente;  
			_tiene_historico = true;
			_tiene_tasa = true;
    	end if;
    
    	if _fecha_revision_tasa is not null and _fecha_revision_tasa = p_fecha then
        	_fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
          update prestamo set  fecha_revision_tasa =  _fecha_revision_tasa 
            where id = _prestamo.id;	           	
    	end if;	
    	
    	if _prestamo.tasa_forzada = true and _prestamo.tasa_forzada_fecha_vigencia < p_fecha then
          update prestamo set  tasa_forzada = false
            where id = _prestamo.id;	           	    		
    	end if;
    	
    	if _prestamo.tasa_forzada = true and _prestamo.tasa_vigente <> _prestamo.tasa_forzada_monto then
    	  _valor_tasa = _prestamo.tasa_forzada_monto;
          update prestamo set tasa_vigente = _valor_tasa
            where id = _prestamo.id;	       
           _tiene_tasa = true;   	        	
    	end if;
    	
    	if _prestamo.tasa_forzada = false and _tiene_tasa = true then
          update prestamo set tasa_vigente = _valor_tasa
            where id = _prestamo.id;	       
          _tiene_tasa = true;   	    
        end if;           
      
        if _tiene_abono = true and _tiene_tasa = false then

		--raise notice 'Tiene abono = true y tiene tasa = false ++++++++++++++++++++ %', _prestamo.numero;
	        perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', 'Nuevo Plan Pago Abono Extraordinario (Cierre) para el prÃ©stamo NÃºmero '||_prestamo.numero);
        	perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, false, 0, true, _prestamo.remanente_por_aplicar,0,0);	      
        end if;
        
        if _tiene_tasa = true then
        	if _tiene_abono = true then
        		_titulo = 'Nuevo Plan Pago Cambio de Tasa/Abono Extraordinario (Cierre) para el prÃ©stamo NÃºmero ';
        	else
        		_titulo = 'Nuevo Plan Pago Cambio de Tasa (Cierre) para el prÃ©stamo NÃºmero ';
        	end if;
	        perform iniciar_transaccion(_prestamo.id, 1, 'p_nuevo_plan_pago', 'L', _titulo||_prestamo.numero);          
	      perform generar_plan_pago_evento(false, _prestamo.id, p_fecha, false, 0, _tiene_tasa, _valor_tasa, _tiene_abono, _prestamo.remanente_por_aplicar,0,0);	      
	      if _tiene_historico = true and _prestamo.tasa_forzada = false then
		    insert into prestamo_tasa_historico 
	          (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
	          values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
	          _tasa_historico.tasa_cliente, _prestamo.id, _tasa_historico.id, p_fecha);	      
	      else    
		    insert into prestamo_tasa_historico 
	          (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
	          values(_valor_tasa, 0,
	          _valor_tasa, _prestamo.id, null, p_fecha);	      
          end if;  
        end if;
        if _tiene_abono = true then
		
		--raise notice 'Actualizo remanente por aplicar = 0 ++++++++++++++++++++ %', _prestamo.numero;
        	update prestamo set remanente_por_aplicar = 0 where id = _prestamo.id;
        end if;
	end if;	--> if cast(extract(day from plan_pago_cuota.fecha) as integer) = _prestamo.dia_facturacion then
	
  end if; ---> _cuota1.id is not null then

	  /*
	  -----------------------------------------------------------------------------------------------------------
	  Si la señal de tine tasa es true o la señal de tiene abono es true se actualiza la señal de visita a true
	  -----------------------------------------------------------------------------------------------------------
	  */

	  if _tiene_tasa = true or
	     _tiene_abono = true then

		update
			prestamo
		set
			senal_visita = true
		where
			prestamo.id = _prestamo.id;
	  end if;

  end loop;

  close _cur_prestamo;
  
  raise notice 'Finalizo loop de abono y cambio de tasa ++++++++++++++++++++ %', _prestamo.numero;

  open _cur_prestamo for select * from 
    prestamo inner join solicitud on (prestamo.solicitud_id = solicitud.id and
                                      solicitud.programa_id = p_programa_id)

	where prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') and
              prestamo.senal_visita = true
	order by prestamo.id;


  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;	
	if _prestamo.intermediado = false then
	   perform actualizar_cuotas(_prestamo.id, p_fecha, false); 
	else
	   perform actualizar_cuotas_intermediado(_prestamo.id, p_fecha); 	  
	end if;
  
	--raise notice 'Ejecutando ultimo loop ++++++++++++++++++++ %', _prestamo.numero;

	
	perform calcular_saldo_insoluto(_prestamo.id, p_fecha, false); 
	perform calcular_interes_vencido(_prestamo.id, p_fecha, false);
	perform calcular_capital_vencido(_prestamo.id, p_fecha, false);
	perform calcular_interes_causado(_prestamo.id, p_fecha, false);
	perform calcular_cuotas_vencidas(_prestamo.id, p_fecha, false);   
	perform calcular_mora(_prestamo.id, p_fecha, p_fecha, false); 
	perform actualizar_deuda_exigible(_prestamo.id, false);
    --NO VA perform reclasificar_cuota(_prestamo.id, p_fecha);       
    if _fecha_fin_mes = p_fecha  then        
      perform interes_devengado_fin_mes(_prestamo.id, p_fecha);   
    end if;
    if (extract (day from p_fecha) = extract(day from _prestamo.fecha_inicio)) then        
      perform eventos_vencimiento_cuota(_prestamo.id, p_fecha);   
    end if;
    if _prestamo.meses_fijos_sin_cambio_tasa > 0 and _prestamo.fecha_revision_tasa = p_fecha then
      perform actualizar_fecha_cambio_tasa(_prestamo.id, p_fecha);
    end if;
        
  end loop;
 
  close _cur_prestamo;

  /*
  -----------------------------------------------------------------------------------
  Se coloca senal de visita a false a todos aquellos prestamos que fueron visitados
  -----------------------------------------------------------------------------------
  */

	update
		prestamo
	set
		senal_visita = false
	where
		senal_visita = true;


  raise notice 'se acabo esta vaina________________________';
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_cartera_programa(p_fecha date, p_oficina_id integer, p_programa_id integer) OWNER TO cartera;

--
-- Name: calcular_cuotas_vencidas(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_cuotas_vencidas(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$





 declare  





   _plan_pago plan_pago%rowtype;





   _plan_pago_cuota record;





   _cur_plan_pago_cuota refcursor;  





 begin





 





  update prestamo set monto_cuotas_vencidas = 0 





         where id = p_prestamo_id;





         





   select into _plan_pago * from plan_pago 





     where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;





   





   open _cur_plan_pago_cuota for select 





     sum((valor_cuota + interes_diferido + interes_desembolso) -(pago_interes_corriente + pago_capital + pago_interes_diferido + pago_interes_desembolso)) as total_monto, count(id) as total_cantidad





     from plan_pago_cuota 





     where vencida = true and estatus_pago <> 'T' 





     and plan_pago_id = _plan_pago.id;





    





    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;





    





    if found then   





      if p_proyeccion = false then





      	update prestamo set monto_cuotas_vencidas = _plan_pago_cuota.total_monto,





         	cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad





         	where id = p_prestamo_id;





      else





      	update prestamo set proyeccion_monto_cuotas_vencidas = _plan_pago_cuota.total_monto,





         	proyeccion_cantidad_cuotas_vencidas = _plan_pago_cuota.total_cantidad





         	where id = p_prestamo_id;     





      end if;   





    end if;   





     





    return false;





 





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_cuotas_vencidas(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_dias_360(date, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_dias_360(p_fecha_inicial date, p_fecha_final date) RETURNS integer
    AS $$

 declare

   _fecha date;

   _meses integer = 0;

   _dias integer = 0;

   _dias_total integer = 0;

 begin

   if (p_fecha_inicial > p_fecha_final) or (p_fecha_inicial is null) 

       or (p_fecha_final is null) then

     return 0;

   end if;

 	loop

 	 _meses = _meses + 1;

 	 _fecha = agregar_meses(p_fecha_inicial, _meses );	 

 	 if _fecha > p_fecha_final then

 	  -- raise notice 'es_mayor';

 	   _meses = _meses - 1;

 	   _fecha = agregar_meses(p_fecha_inicial, _meses );

 	   --raise notice '_fecha___________%',_fecha;

 	   --raise notice '_fecha_final___________%',p_fecha_final;

 	   _dias = p_fecha_final - _fecha;

 	   --raise notice '_dias___________%',_dias;

 	   exit;

 	 end if;

 	end loop;

 	_dias_total = (_meses*30)+_dias;

   return _dias_total;

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_dias_360(p_fecha_inicial date, p_fecha_final date) OWNER TO cartera;

--
-- Name: calcular_interes_causado(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_interes_causado(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$





 declare  





   _prestamo prestamo%rowtype;





   _plan_pago plan_pago%rowtype;





   _plan_pago_cuota plan_pago_cuota%rowtype;





   _plan_pago_cuota_anterior plan_pago_cuota%rowtype;





   _monto_causado numeric = 0;   





   _dias_causados integer = 0;





   _fecha date;





   _base_calculo_intereses integer = 0;





   _saldo_insoluto numeric;





 begin





 





   select into _prestamo * from prestamo





     where id = p_prestamo_id;





 





  --raise notice 'NUMERO PRESTAMO_____________________________%',_prestamo.numero;





 





   _base_calculo_intereses = _prestamo.base_calculo_intereses;





   





   select into _plan_pago * from plan_pago 





     where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;





  





   update plan_pago_cuota set causado_no_devengado = 0 





     where causado_no_devengado <> 0 and plan_pago_id = _plan_pago.id; 





  





   if p_proyeccion = false then





   	update prestamo set causado_no_devengado = 0 where id = p_prestamo_id;





   else





   	update prestamo set proyeccion_causado_no_devengado = 0 where id = p_prestamo_id;





   end if;





 





 -- Recupera la ultima cuota anterior a la fecha de evaluaciÃƒÂ³n





   select into _plan_pago_cuota_anterior * from plan_pago_cuota 





     where plan_pago_id = _plan_pago.id 





     and fecha < p_fecha_evento order by fecha desc limit 1;





   if found then





     _saldo_insoluto = _plan_pago_cuota_anterior.saldo_insoluto+_plan_pago_cuota_anterior.monto_desembolso-_plan_pago_cuota_anterior.monto_abono;





   else





     -- Si no encuentra una cuota anterior busca el monto del prestamo





     _saldo_insoluto = _plan_pago.monto;





   end if;





   





 -- Recupera la ultima cuota posterior a la fecha de evaluaciÃƒÂ³n





   select into _plan_pago_cuota * from plan_pago_cuota 





     where plan_pago_id = _plan_pago.id and interes_corriente > pago_interes_corriente





     and vencida = false  and fecha > p_fecha_evento order by fecha asc limit 1;





   





   if found then





     --raise notice 'si_encontro***__________%',_plan_pago_cuota.numero;





     --raise notice 'si_encontro***__________%',_plan_pago_cuota.tipo_cuota;





     _fecha = agregar_meses(_plan_pago_cuota.fecha,-_prestamo.frecuencia_pago);





       --  raise notice '_fecha***__________%',_fecha;





     if _base_calculo_intereses = 360 then





       _dias_causados = calcular_dias_360(_fecha, p_fecha_evento)-1;





     else





       _dias_causados = (p_fecha_evento - _fecha)-1;





     end if;





     --raise notice 'dias_causados*****%',_dias_causados;





 	if _dias_causados > 0 then





 	--  raise notice 'SALDO INSOLUTO_____________________________%',_saldo_insoluto;





 	 -- raise notice 'TASA_VIGENTE_____________________________%',_prestamo.tasa_vigente;





 	  --raise notice 'BASE CALCULO INTERES_____________________________%',_base_calculo_intereses;





 	  --raise notice 'DIAS CAUSADOS_____________________________%',_dias_causados;





 	  _monto_causado = (((_prestamo.tasa_vigente/100)/_base_calculo_intereses)*





 	     (_saldo_insoluto))*_dias_causados;      





 	  --raise notice 'MONTO_CAUSADO_____________________________%',_monto_causado;





 	  update plan_pago_cuota set causado_no_devengado = _monto_causado where id = _plan_pago_cuota.id;	 





 	  if p_proyeccion = false then





 	  	update prestamo set causado_no_devengado = _monto_causado where id = p_prestamo_id;	 





 	  else





 	  	update prestamo set proyeccion_causado_no_devengado = _monto_causado where id = p_prestamo_id;	 





 	  end if;





 	end if;





   end if;





    return false;





 





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_interes_causado(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_interes_vencido(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_interes_vencido(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$
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
    _interes_diferido_vencido = _interes_diferido_vencido + ((_plan_pago_cuota.interes_diferido) - _plan_pago_cuota.pago_interes_diferido);
    
end loop;

close _cur_plan_pago_cuota;

 -- Recupera las cuotas exigibles y no exigibles para el total del interes diferido .............................................................DB

  open _cur_plan_pago_diferido for select * from plan_pago_cuota 

    where plan_pago_id = _plan_pago.id and (estatus_pago = 'X'

    or estatus_pago = 'N' or estatus_pago = 'P') and vencida = false and tipo_cuota = 'C';
 

 -- Totaliza las cuotas exigibles y no exigibles para el total del interes diferido por Vencer.....................................DB

loop

    fetch _cur_plan_pago_diferido  INTO _plan_pago_cuota;

	exit when not found;


    _interes_diferido_por_vencer = _interes_diferido_por_vencer + (_plan_pago_cuota.interes_diferido - _plan_pago_cuota.pago_interes_diferido);

    

end loop;

close _cur_plan_pago_diferido;

  if p_proyeccion = false then
    update prestamo set interes_vencido = _interes_vencido, 
        interes_diferido_vencido = _interes_diferido_vencido,
        interes_desembolso_vencido = _interes_desembolso_vencido,
	interes_diferido_por_vencer = _interes_diferido_por_vencer
        where id = p_prestamo_id;
  else
    update prestamo set proyeccion_interes_vencido = _interes_vencido, 
        proyeccion_interes_diferido_vencido = _interes_diferido_vencido,
        proyeccion_interes_desembolso_vencido = _interes_desembolso_vencido
        where id = p_prestamo_id;
  end if;  
  return false;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_interes_vencido(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_mora(integer, date, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_mora(p_prestamo_id integer, p_fecha_evento date, p_fecha_auxiliar date, p_proyeccion boolean) RETURNS boolean
    AS $$
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
	    _fecha_calculo = agregar_dias(p_fecha_evento, -(_parametro_general.dias_gracia_mora-1));
	  else
	    _fecha_calculo = agregar_dias(p_fecha_auxiliar, -(_parametro_general.dias_gracia_mora-1));
	  end if; 
	  -- if _prestamo.numero =  8000000764 then
	   --raise notice '************************* fecha_axiliar____________%',p_fecha_auxiliar;
		--   raise notice '************************* fecha_calculo_en_calcular_mmora____________%',_fecha_calculo;
		 --  raise notice '************************* tasa_mora_mora____________%',_tasa_valor.valor;
	   --end if;
	  -- Recupera las cuotas menores a la fecha actual y que no esten pagadas
	  if _prestamo.intermediado = false then
	   --if _prestamo.numero =  8000000764 then
		--   raise notice '************************* VA HACER EL SELECT PARA BUSCAR LAS CUOTAS VENCIDAS____________';		   
	   --end if;
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota 
	      where plan_pago_id = _plan_pago.id and fecha <= _fecha_calculo and (tipo_cuota = 'C' or tipo_cuota = 'G')
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
		--if _prestamo.numero =  8000000764 then
		--  raise notice '********************** cuota numero_%',_plan_pago_cuota.numero;
		--end if;
		_vencido = true;
		if _plan_pago_cuota.tipo_cuota = 'C' then
		  _tasa_calculo = _tasa_valor.valor + _plan_pago_cuota.tasa_nominal_anual;
		 -- if _prestamo.numero =  8000000764 then
		 -- 	raise notice '********************** tasa_calculo_%',_tasa_calculo;
		 -- end if;
		  
		  _monto_base = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;
		  
		  select into _plan_pago_mora * from plan_pago_mora 
	        where plan_pago_cuota_id = _plan_pago_cuota.id and capital = _monto_base;
	    
	      select into _plan_pago_mora_aux * from plan_pago_mora 
	        where plan_pago_cuota_id = _plan_pago_cuota.id order by fecha_fin desc limit 1;
	     
	      if _plan_pago_mora.id is not null then
	        update plan_pago_mora set fecha_fin = p_fecha_evento where id = _plan_pago_mora.id;
	        _plan_pago_mora_id = _plan_pago_mora.id;
	      else
	        if _plan_pago_mora_aux.id is null then
	      		insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital) values(_plan_pago_cuota.id, _tasa_calculo, _plan_pago_cuota.fecha, p_fecha_evento, _monto_base);  
	      	else
	      		insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital) values(_plan_pago_cuota.id, _tasa_calculo, agregar_dias(_plan_pago_mora_aux.fecha_fin, 1), p_fecha_evento, _monto_base);  
	      	end if;
	      	_plan_pago_mora_id = currval('plan_pago_mora_id_seq');  	      	
	      end if;
		  
		   select into _plan_pago_mora * from plan_pago_mora 
	        where plan_pago_cuota_id = _plan_pago_cuota.id and id = _plan_pago_mora_id;
	    	       		  
		  if _base_calculo_intereses = 360 then
	  	    _dias_mora = (calcular_dias_360(_plan_pago_mora.fecha_inicio, _plan_pago_mora.fecha_fin))+1;
	  	  else
	  	    
	  	    /* Se modifico la funcion dias mora para base 365, se reemplazo la coma por el signo - Diego Bertaso */
	  	  
	  	    _dias_mora = (  _plan_pago_mora.fecha_fin - _plan_pago_mora.fecha_inicio)+1;
	  	  end if;	

		      
		  _intereses_mora = ( ( ( _tasa_calculo / 100 ) / _base_calculo_intereses ) * _plan_pago_mora.capital) * _dias_mora;	
		  _intereses_mora_total = _intereses_mora_total + _intereses_mora;
		  
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
	  
	  delete from plan_pago_mora where plan_pago_cuota_id in (
	      select id from plan_pago_cuota where 
	      plan_pago_id = _plan_pago.id and fecha > _fecha_calculo and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true ));
	  
	   update  plan_pago_cuota set dias_mora = 0, interes_mora = 0 where 
	      plan_pago_id = _plan_pago.id and fecha > _fecha_calculo and fecha <= p_fecha_auxiliar and (tipo_cuota = 'C' or tipo_cuota = 'G')
	      and (estatus_pago = 'N' or estatus_pago = 'P' and vencida = true );
	   
--	  if _dias_mora > 0 then
		--if _prestamo.numero =  8000000764 then
		--raise notice '????????????????_intereses_mora_total__%', _intereses_mora_total;
		--raise notice '????????????????_pago_interes_mora__%', _pago_interes_mora;
		--end if;
      if _vencido = true then
      	if p_proyeccion = false then
--	    	update prestamo set dias_mora = _dias_mora_total, monto_mora =  _intereses_mora_total - _pago_interes_mora, estatus = 'E' where id = p_prestamo_id;
			update prestamo set dias_mora = _dias_mora_total, monto_mora =  
			(select sum(interes_mora) from plan_pago_cuota where estatus_pago in ('N', 'P') and vencida = true and plan_pago_id in 
			(select id from plan_pago where prestamo_id = _prestamo.id and activo = true)) 
			- _pago_interes_mora, estatus = 'E' where id = p_prestamo_id;
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
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_mora(p_prestamo_id integer, p_fecha_evento date, p_fecha_auxiliar date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_prestamo(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_prestamo(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _tasa_historico tasa_historico%rowtype;
  _plan_pago plan_pago%rowtype;
  _fecha_revision_tasa date;
  _cantidad_cuotas_mora integer = 0;
begin


  select into _plan_pago * from plan_pago 
	  where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;
	    
	    
	raise notice 'ENTRA A CALCULAR EL PRESTAMO *********************************************';
  select into _prestamo * from prestamo where id = p_prestamo_id;
  if _prestamo.estatus <> 'L' then
	  perform actualizar_cuotas(p_prestamo_id, p_fecha_evento, p_proyeccion);
  end if;
  perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, p_proyeccion);
  perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);
  perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, p_proyeccion);
  if _prestamo.estatus <> 'L' then
    perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, p_proyeccion);
  end if;
  perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, p_proyeccion);
  if _prestamo.estatus <> 'L' then
  	update prestamo set dias_mora = 
  		(select sum(dias_mora) from plan_pago_cuota where estatus_pago in ('N', 'P') and plan_pago_id in 
  		(select id from plan_pago where prestamo_id = _prestamo.id and activo = true )),
  		monto_mora = 
  		(select sum(interes_mora - pago_interes_mora) from plan_pago_cuota where estatus_pago in ('N', 'P') and vencida = true and plan_pago_id in 
  		(select id from plan_pago where prestamo_id = _prestamo.id and activo = true )) where id = p_prestamo_id;
   -- perform calcular_mora(p_prestamo_id, p_fecha_evento, p_fecha_evento, p_proyeccion);

	  select into  _cantidad_cuotas_mora count(*) from plan_pago_cuota where plan_pago_id = _plan_pago.id and estatus_pago in ('N', 'P') and vencida = true and dias_mora > 0;
	  
	  if _cantidad_cuotas_mora > 0 then
	  	if _prestamo.numero =  8000000764 then
		raise notice '????????????????_va poner el prestamo en vencido cuotas__%', _cantidad_cuotas_mora;
		end if;
	  	update prestamo set estatus = 'E' where id = p_prestamo_id;
	  end if;
	  
  end if;
  perform actualizar_deuda_exigible(p_prestamo_id, p_proyeccion);
  
  if p_proyeccion = false then  
	  -- Si el prestamo se pagÃƒÂ³ en su totalidad lo actualiza a cancelado 
	  select into _prestamo * from prestamo where id = p_prestamo_id;
	  if _prestamo.deuda <= 0 then
	    raise notice 'Le CambiÃƒÂ³ el Estatus del PrÃƒÂ©stamo a Cancelado';
	    update prestamo set estatus = 'C' where id = _prestamo.id;
	  end if;
  end if;
--  if (_prestamo.fecha_revision_tasa = p_fecha_evento) then
--  raise notice 'SI ES FECHA DE REVISION';
    
--    _fecha_revision_tasa = _prestamo.fecha_revision_tasa;
--    
--    select into _tasa_historico * from tasa_historico
--      where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1;
--    raise notice 'BUSCO LA ULTIMA TASA%',_tasa_historico.tasa_cliente;  
--    
--    if (_tasa_historico.tasa_cliente <> _prestamo.tasa_vigente)  then    
--    
--      raise notice 'LA ULTIMA TASA ES DIFERENTE A LA TASA ACTUAL DEL PRESTAMO';
--      perform generar_plan_pago_evento(false, p_prestamo_id, p_fecha_evento, false, 0, true, _tasa_historico.tasa_cliente, false,0);
--     raise notice 'GENERO EL NUEVO PLAN PAGO';
--      
--      insert into prestamo_tasa_historico 
--        (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
--        values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
--        _tasa_historico.tasa_cliente, p_prestamo_id, _tasa_historico.id, p_fecha_evento);
--        raise notice 'GRABO EL HISTORICO DEL PRESTAMO';
--        
--        
--        _fecha_revision_tasa = agregar_meses(_fecha_revision_tasa, _prestamo.meses_fijos_sin_cambio_tasa);
--        
--        
--        raise notice 'CALCULO LA NUEVA FECHA DE REVISION%',_fecha_revision_tasa;
--        update prestamo set  fecha_revision_tasa =  
--          _fecha_revision_tasa, tasa_vigente = _tasa_historico.tasa_cliente
--          where id = p_prestamo_id;
--        raise notice 'ACTUALIZO EL PRESTAMO';
--        
--   end if;
--  end if;
  --raise exception 'HUBO ERROR';
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_prestamo(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: calcular_prestamo_proyeccion(integer, date, double precision); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_prestamo_proyeccion(p_prestamo_id integer, p_fecha_evento date, p_monto_abono double precision) RETURNS boolean
    AS $$

 declare

   _prestamo prestamo%rowtype;

   _tasa_historico tasa_historico%rowtype;

   _fecha_revision_tasa date;

 begin

 

   update prestamo set proyeccion_remanente_por_aplicar = remanente_por_aplicar where id = p_prestamo_id;

   

   raise notice 'MONTO_ABONO***************************************************%',p_monto_abono;

   

   if p_monto_abono > 0 then

   	update prestamo set proyeccion_remanente_por_aplicar = proyeccion_remanente_por_aplicar + p_monto_abono where id = p_prestamo_id;

   	raise notice 'ENTRA 1 ***************************************************';

   end if;

   

   perform generar_plan_pago_evento(true, p_prestamo_id, p_fecha_evento, false, 0, false, 0, false, 0,0,0);

   	

   select into _prestamo * from prestamo where id = p_prestamo_id;

   

   perform actualizar_cuotas(p_prestamo_id, p_fecha_evento, true);

   perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, true);

   perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, true);

   perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, true);

   perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, true);

   perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, true);

   perform calcular_mora(p_prestamo_id, p_fecha_evento, true);

   perform actualizar_deuda_exigible(p_prestamo_id, true);

   

    raise notice 'REMANENTE POR APLICAR  ***************************************************%',_prestamo.proyeccion_remanente_por_aplicar;

     	

   if p_monto_abono > 0 then

     raise notice 'ENTRA 2 ***************************************************';

   	perform generar_plan_pago_evento(true, _prestamo.id, p_fecha_evento, false, 0, false, 0, true, _prestamo.proyeccion_remanente_por_aplicar,0, 0);

   	update prestamo set proyeccion_remanente_por_aplicar = 0 where id = p_prestamo_id;

   end if; 	

 		  

   perform calcular_saldo_insoluto(p_prestamo_id, p_fecha_evento, true);

   perform calcular_interes_vencido(p_prestamo_id, p_fecha_evento, true);

   perform calcular_capital_vencido(p_prestamo_id, p_fecha_evento, true);

   perform calcular_interes_causado(p_prestamo_id, p_fecha_evento, true);

   perform calcular_cuotas_vencidas(p_prestamo_id, p_fecha_evento, true);

   perform calcular_mora(p_prestamo_id, p_fecha_evento, true);

   perform actualizar_deuda_exigible(p_prestamo_id, true);

   

   --raise exception 'HUBO ERROR';

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_prestamo_proyeccion(p_prestamo_id integer, p_fecha_evento date, p_monto_abono double precision) OWNER TO cartera;

--
-- Name: calcular_saldo_insoluto(integer, date, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION calcular_saldo_insoluto(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) RETURNS boolean
    AS $$





 declare  





   _prestamo prestamo%rowtype;





   _rec_plan_pago_cuota record;





   _cur_plan_pago_cuota refcursor;





   _plan_pago plan_pago%rowtype;





   _plan_pago_cuota plan_pago_cuota%rowtype;





   _saldo_insoluto numeric(16,2) = 0;   





 begin





 





   select into _prestamo * from prestamo





     where id = p_prestamo_id;





 





    





     





   select into _plan_pago * from plan_pago 





     where prestamo_id = p_prestamo_id and activo = not(p_proyeccion) and proyeccion = p_proyeccion;





  





     





   -- Recupera la ultima cuota pagada





   select into _plan_pago_cuota * from plan_pago_cuota 





     where plan_pago_id = _plan_pago.id and (estatus_pago = 'T' or estatus_pago = 'P')





     order by fecha desc limit 1;





 





   if not found then    





     _saldo_insoluto = _prestamo.monto_liquidado;





     open _cur_plan_pago_cuota for select 0.0 as monto_desembolso, 0.0 as monto_abono





        from plan_pago_cuota    





 	  where plan_pago_id = _plan_pago.id;





 	  





   else





     _saldo_insoluto = _plan_pago_cuota.saldo_insoluto;





     open _cur_plan_pago_cuota for select sum(monto_desembolso)  as monto_desembolso, sum(monto_abono) as monto_abono





         from plan_pago_cuota    





 	   where id >= _plan_pago_cuota.id





 	   and plan_pago_id = _plan_pago.id;





 	





 --	 open _cur_plan_pago_cuota for select sum(monto_desembolso)  as monto_desembolso, sum(monto_abono) as monto_abono





 --	    from plan_pago_cuota    





 --	    where id >= _plan_pago_cuota.id





 --	    and plan_pago_id = _plan_pago.id;





 --	  fetch _cur_plan_pago_cuota INTO _rec_plan_pago_cuota;	





 --	  _saldo_insoluto = _saldo_insoluto + _rec_plan_pago_cuota.monto_desembolso - _rec_plan_pago_cuota.monto_abono;





   end if;





 





 	fetch _cur_plan_pago_cuota INTO _rec_plan_pago_cuota;





 	if found then





 	_saldo_insoluto = _saldo_insoluto + _rec_plan_pago_cuota.monto_desembolso - _rec_plan_pago_cuota.monto_abono;    





     end if;





  





   if p_proyeccion = false then  





   	update prestamo set saldo_insoluto = _saldo_insoluto where id = p_prestamo_id;





   else





   	update prestamo set proyeccion_saldo_insoluto = _saldo_insoluto where id = p_prestamo_id;





   end if;





   return false;





  





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.calcular_saldo_insoluto(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean) OWNER TO cartera;

--
-- Name: campos_tabla(character varying, boolean, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION campos_tabla(p_tabla character varying, p_excluir_id boolean, p_actualizar_transaccion boolean) RETURNS character varying
    AS $$

 declare

   _cur_attributes refcursor;

   _attribute varchar;

   _sql_fields varchar;

   _first_field bool;

 begin

 

   open _cur_attributes for 

     select attname from pg_attribute join pg_class on attrelid = pg_class.oid where relname = p_tabla and attisdropped = false;

 

   _sql_fields = '';

   _first_field = true;

 

   loop

     fetch _cur_attributes INTO _attribute;

 	exit when not found;

 	if _attribute <> 'tableoid' and _attribute <> 'cmax' and _attribute <> 'xmax' 

 	  and _attribute <> 'cmin' and _attribute <> 'xmin' and _attribute <> 'ctid' and (_attribute <> 'id' or p_excluir_id = false) then

 

       if _first_field = false then

 	    _sql_fields = _sql_fields || ', ';

 	  else

         _first_field = false;

 	  end if;

 

       if p_actualizar_transaccion = false then      

         _sql_fields = _sql_fields || _attribute;

       else

         _sql_fields = _sql_fields || _attribute || ' = tr_' || p_tabla || '.' || _attribute;

       end if;

         

     end if;

 

   end loop;

   

   return _sql_fields;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.campos_tabla(p_tabla character varying, p_excluir_id boolean, p_actualizar_transaccion boolean) OWNER TO cartera;

--
-- Name: cancelar_prestamo(integer, integer, character varying[], character, double precision, integer, date, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION cancelar_prestamo(p_cliente_id integer, p_prestamo_id integer, p_cheques character varying[], p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_contabilizacion date, p_fecha_realizacion date) RETURNS boolean
    AS $$





 declare    





     _prestamo prestamo%rowtype;
     _factura_id integer;
     _deuda_total NUMERIC(14, 2) = 0;
     _cur_plan_pago_cuota refcursor;
     _plan_pago_cuota plan_pago_cuota%rowtype;
     _factura factura%rowtype;
     _pago_prestamo pago_prestamo%rowtype;
     _prestamo_id integer;
     _pago_interes_diferido NUMERIC(14, 2);
     _pago_causado_no_devengado NUMERIC(14, 2);
     _pago_acumulado_interes_diferido NUMERIC(14, 2);
     _pago_cuota pago_cuota%rowtype;
     _con_intereses_mora NUMERIC(14, 2) = 0;
     _con_capital NUMERIC(14, 2) = 0;
     _con_capital_vencido NUMERIC(14, 2) = 0;
     _con_intereses_por_cobrar NUMERIC(14, 2) = 0;
     _con_intereses_por_cobrar_vencido NUMERIC(14, 2) = 0;
     _con_ingreso_intereses NUMERIC(14, 2) = 0;
     _con_diferencia NUMERIC(14, 2) = 0;
     _con_cur_pago_cuota refcursor;
     _con_pago_cuota record;
     _con_programa_origen_fondo programa_origen_fondo%rowtype;
     _con_solicitud solicitud%rowtype;
     _con_entidad_financiera entidad_financiera%rowtype;
     _con_cuenta_contable_banco cuenta_contable%rowtype;    
     _con_codigo_cuenta_contable_banco integer;
     _remanente_por_aplicar numeric(16,2) = 0;

 begin
    -- perform iniciar_transaccion(p_prestamo_id, 1, 'p_pre-cancelar', 'L', 'pre-cancelacion sobre el prestamo'||p_prestamo_id);
     _prestamo_id = p_prestamo_id;

     select into _prestamo * from prestamo where id = _prestamo_id;
     _deuda_total = _deuda_total + _prestamo.deuda;
     _remanente_por_aplicar = _prestamo.remanente_por_aplicar;





   





   if cast(_deuda_total as float) = cast(p_monto as float) then





  





     _factura_id = ejecutar_pago(





       p_cliente_id,





       p_cheques,





 	  _prestamo_id,





 	  p_modalidad,	





 	  p_monto+100,





 	  p_oficina_id,





 	  p_fecha_contabilizacion,





 	  p_fecha_realizacion,null,0, null,false, true, true, false);





 





 	    





 	 update factura set tipo = 'C' , monto = monto - 100 where id =  _factura_id;





 	   





 	select into _factura * from factura where id = _factura_id;





  





 	--for i in array_lower(_prestamos,1) .. array_upper(_prestamos,1) loop





     --  _prestamo_id = cast(_prestamos[i][1] as integer);





       _pago_acumulado_interes_diferido = 0;





       _pago_causado_no_devengado = 0;



       -- Paga las cuotas, recorre las cuotas que tienen intereses diferidos impagos



       open _cur_plan_pago_cuota for select * from plan_pago_cuota inner join plan_pago
         on plan_pago_cuota.plan_pago_id = plan_pago.id 
         where prestamo_id = _prestamo_id
         and estatus_pago <> 'T'
         and interes_diferido > 0
         and plan_pago.activo = true
         and plan_pago.proyeccion = false
         and tipo_cuota = 'C' order by numero;

       select into _pago_prestamo * from pago_prestamo where pago_cliente_id = _factura.pago_cliente_id
         and prestamo_id = _prestamo_id;

       loop

         fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
 	    exit when not found;
 	    _pago_interes_diferido = 0;	   

         -- Actualiza la cuota

         update plan_pago_cuota set 

           pago_interes_diferido = interes_diferido,

           estatus_pago = 'P'

           where id = _plan_pago_cuota.id;


         select into _pago_interes_diferido pago_interes_diferido from plan_pago_cuota
           where id = _plan_pago_cuota.id;
         _pago_acumulado_interes_diferido = _pago_acumulado_interes_diferido + _pago_interes_diferido;

         insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id, 

 	      monto, interes_diferido)

 	      values(_plan_pago_cuota.id, _pago_prestamo.id, _pago_interes_diferido, _pago_interes_diferido);

        end loop;


	raise notice '------------------SALIENDO DEL PRIMER LOOP';



 	   -- Se paga el causado no devengado


        select into _plan_pago_cuota * from plan_pago_cuota inner join plan_pago





          on plan_pago_cuota.plan_pago_id = plan_pago.id 





          where prestamo_id = _prestamo_id





          and plan_pago.activo = true





          and plan_pago.proyeccion = false





          and plan_pago_cuota.causado_no_devengado > 0;





 





        _pago_causado_no_devengado = _plan_pago_cuota.causado_no_devengado;





        





        if _pago_causado_no_devengado > 0 then





        





          select into _pago_cuota * from pago_cuota where plan_pago_cuota_id = _plan_pago_cuota.id;





        





          if found then





            update pago_cuota set monto = monto + _pago_causado_no_devengado,





              interes_corriente = _pago_causado_no_devengado where





              plan_pago_cuota_id = _plan_pago_cuota.id;





          else





 	       insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id, 





 	         monto, interes_corriente)





 	         values(_plan_pago_cuota.id, _pago_prestamo.id, _pago_causado_no_devengado, 





 	         _plan_pago_cuota.causado_no_devengado);





          end if;



	raise notice '------------------SALIENDO DEL CAUSADO NO DEVENGADO';


          -- Actualiza la cuota





          update plan_pago_cuota set 





            pago_interes_corriente = pago_interes_corriente + _pago_causado_no_devengado,





            estatus_pago = 'P'





            where id = _plan_pago_cuota.id;





 





          -- Actualiza el pago del prestamo





         





 	       





 	   end if;





 	   





 	    update pago_prestamo set 





 	       interes_diferido = interes_diferido + _pago_acumulado_interes_diferido,





     	   monto = monto + interes_diferido + _pago_causado_no_devengado,





     	   interes_causado = _pago_causado_no_devengado,





     	   saldo_insoluto = _prestamo.saldo_insoluto    	   





 	       where id = _pago_prestamo.id;





 	       





 	   close _cur_plan_pago_cuota;





 	   open _cur_plan_pago_cuota for select * from plan_pago_cuota inner join plan_pago





 	      on plan_pago_cuota.plan_pago_id = plan_pago.id 





 	      where prestamo_id = _prestamo_id





 	      and estatus_pago in('T', 'P')





 	      and plan_pago.activo = true





 	      and plan_pago.proyeccion = false





 	      order by plan_pago_cuota.id desc limit 1;





 	      





 	    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;





 	      





 	    if found then





 	      update plan_pago_cuota set cancelacion_prestamo = true where id = _plan_pago_cuota.id;





 	    else





 	      update plan_pago_cuota set cancelacion_prestamo = true where numero = 1;





 	    end if;  





 	     





 	    --Inicio  Contabilidad 





 	    





 	     select into _prestamo * from prestamo





             where id = _prestamo_id;





       





         select into _con_solicitud * from solicitud





             where id = _prestamo.solicitud_id;





      





         select into _con_programa_origen_fondo * from programa_origen_fondo





             where programa_id = _con_solicitud.programa_id 





             and origen_fondo_id = _con_solicitud.origen_fondo_id;





             





 	    open _con_cur_pago_cuota for select 





 	       plan_pago_cuota.numero as numero,





 	       plan_pago_cuota.dias_mora as dias_mora,





 	       pago_cuota.interes_mora as pago_interes_mora,





 	       pago_cuota.capital as pago_capital,





 	       plan_pago_cuota.intereses_por_cobrar_al_30 as intereses_por_cobrar_al_30,





 	       pago_cuota.interes_corriente as pago_interes_corriente





 	       from pago_cuota inner join plan_pago_cuota





             on plan_pago_cuota.id = pago_cuota.plan_pago_cuota_id 





             where pago_cuota.pago_prestamo_id = _pago_prestamo.id;





             





         loop





 	        fetch _con_cur_pago_cuota INTO _con_pago_cuota;





 		    exit when not found;





 		    if _con_pago_cuota.dias_mora=0 then





 		       raise notice 'entra por vigente %',_con_pago_cuota.numero;





 	           _con_capital =  _con_capital + _con_pago_cuota.pago_capital;                	           





 	           _con_intereses_por_cobrar = _con_intereses_por_cobrar + _con_pago_cuota.intereses_por_cobrar_al_30;





 			   _con_ingreso_intereses = _con_ingreso_intereses + (_con_pago_cuota.pago_interes_corriente - _con_pago_cuota.intereses_por_cobrar_al_30);			





 	       else





 	           _con_intereses_mora =  _con_intereses_mora + _con_pago_cuota.pago_interes_mora;  





 	           _con_capital_vencido =  _con_capital_vencido + _con_pago_cuota.pago_capital;  





 	           _con_intereses_por_cobrar_vencido = _con_intereses_por_cobrar_vencido + _con_pago_cuota.intereses_por_cobrar_al_30;





 	           _con_ingreso_intereses = _con_ingreso_intereses + (_con_pago_cuota.pago_interes_corriente - _con_pago_cuota.intereses_por_cobrar_al_30);			





 	       end if;





 	    





 	    end loop;    


		raise notice '------------------SALIENDO DEL SEGUNDO LOOP';



 	    





 	    raise notice 'monto..%',p_monto;





 	    raise notice 'capital_vigente..%',_con_capital;





 	    raise notice 'capital_vencido..%',_con_capital_vencido;





 	    raise notice ' saldo_insoluto..%',_prestamo.saldo_insoluto;





 	    raise notice '_con_intereses_por_cobrar..%',_con_intereses_por_cobrar;





 	    raise notice '_con_ingreso_intereses..%',_con_ingreso_intereses;





 	    raise notice '_con_capital_vencido..%',_con_capital_vencido;





 	    raise notice '_con_intereses_por_cobrar_vencido..%',_con_intereses_por_cobrar_vencido;





 	    raise notice '_con_intereses_mora..%',_con_intereses_mora;





 	    --raise exception 'se acabo';





 	    





 	    _con_diferencia = 





 	       p_monto - ((_prestamo.saldo_insoluto + _con_capital)+_con_intereses_por_cobrar





 	       +_con_ingreso_intereses+_con_capital_vencido+_con_intereses_por_cobrar_vencido+_con_intereses_mora);





 	    if _con_diferencia > 0 then





 	       if _con_capital > 0 then





 	           _con_capital = _con_capital + _con_diferencia;





 	       else





 	           _con_capital_vencido = _con_capital_vencido + _con_diferencia;





 	       end if;





 	    elsif _con_diferencia < 0 then





 	       if _con_capital > 0 then





 	           _con_capital = _con_capital - abs(_con_diferencia);





 	       else





 	           _con_capital_vencido = _con_capital_vencido - abs(_con_diferencia);





 	       end if;





 	    end if;    





 	    perform stc_cancelacion_prestamo( 





             cast(p_monto as float),





             0,





             cast(_prestamo.saldo_insoluto + _con_capital as float),





             cast(_con_intereses_por_cobrar as float),





             cast(_con_ingreso_intereses as float),





             cast(_con_capital_vencido as float),





           --  cast(_con_intereses_por_cobrar_vencido as float),





             cast(_con_intereses_mora as float),





             _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,





 		    _con_programa_origen_fondo.cuenta_contable_capital_id,





 		    _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,                        	               	           





 		   -- cast(_remanente_por_aplicar as float),





 	        p_fecha_realizacion,





 			p_fecha_realizacion,





 			_prestamo.id,





 			_factura_id,





 			cast(extract(year from p_fecha_realizacion) as integer));





 			





         -- Fin Contabilidad





          





          





          





          	raise notice '------------------SALIENDO DE CONTABILIDAD';






 	   -- Actualiza el prestamo





 	   update prestamo set





 	     estatus = 'C',





 	     saldo_insoluto = 0,





 	     interes_vencido = 0,





 	     dias_mora = 0,





 	     monto_mora = 0,





 	     causado_no_devengado = 0,





 	     interes_diferido_vencido = 0,





 	     remanente_por_aplicar = 0,





 	     cantidad_cuotas_vencidas = 0,





 	     monto_cuotas_vencidas = 0,





 	     deuda = 0,





 	     exigible = 0,





 	     capital_vencido = 0,

	     interes_diferido_por_vencer = 0





 	     where id = _prestamo_id;



		raise notice '------------------SALIENDO DE ACTUALIZAR PRESTAMO';


 	--end loop;





 	return true;





   else





     raise exception 'el monto de la deuda es diferente al monto que se desea pagar';    





   end if;





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.cancelar_prestamo(p_cliente_id integer, p_prestamo_id integer, p_cheques character varying[], p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_contabilizacion date, p_fecha_realizacion date) OWNER TO cartera;

--
-- Name: conversion_bolivar_fuerte(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION conversion_bolivar_fuerte() RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;
  _cur_prestamo refcursor;
  _fecha_focal date;
  _plan_pago_id integer;
  _plan_pago_cuota_id integer;
  _monto_insoluto float;
  _meses_muertos integer = 0;
  _meses_gracia integer = 0;
  _plazo integer = 0;
  _motivo_evento char;
  _valor_tasa float = 0;
  _factura_id integer;
  
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;
  
begin

    open _cur_prestamo for select * from 
    prestamo where estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') order by id;

  loop
    fetch _cur_prestamo INTO _prestamo;
	exit when not found;

	--Selecciono el plan pago asociado al prestamo
    
    select into _plan_pago * from plan_pago 
      where plan_pago.prestamo_id = _prestamo.id and plan_pago.activo = true;
    	
	--Busca la fecha de la ultima cuota pagada
  
    select 
          into _plan_pago_cuota * from plan_pago_cuota
    
          where plan_pago_cuota.estatus_pago = 'T' and 
                plan_pago_cuota.plan_pago_id = _plan_pago.id
            
          order by fecha desc limit 1;
          
    if _plan_pago_cuota.fecha is null then
        _fecha_focal = _prestamo.fecha_liquidacion;
    else
	    _fecha_focal = _plan_pago_cuota.fecha;
    end if;
	
	
	perform generar_plan_pago_evento(false,
	                                 _prestamo.id,
	                                 _fecha_focal,
	                                 false,
	                                 0,
	                                 false,
	                                 0,
	                                 true,
	                                 0,
	                                 0,
	                                 0);

	-- A continuacion se actualizan los campos del prestamo
	
  end loop;
    
  
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.conversion_bolivar_fuerte() OWNER TO cartera;

--
-- Name: conversion_bolivar_fuerte_manual(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION conversion_bolivar_fuerte_manual() RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _solicitud solicitud%rowtype;
  _solicitud_anticipo_societario solicitud_anticipo_societario%rowtype;
  _desembolso desembolso%rowtype;
  _desembolso_pago desembolso_pago%rowtype;
  _factura factura%rowtype;
  _pago_cuota pago_cuota%rowtype;
  _pago_prestamo pago_prestamo%rowtype;
  _pago_cliente pago_cliente%rowtype;
  _pago_forma pago_forma%rowtype;
  _garantia garantia%rowtype;
  _empresa empresa%rowtype;
  _producto producto%rowtype;
  _programa programa%rowtype;
  _prestamo_modificacion prestamo_modificacion%rowtype;
  _prestamo_modificacion_rubro prestamo_modificacion_rubro%rowtype;
  _prestamo_modificacion_rubro_atributo prestamo_modificacion_rubro_atributo%rowtype;
  _prestamo_rubro prestamo_rubro%rowtype;
  _prestamo_rubro_atributo prestamo_rubro_atributo%rowtype;
  _plan_pago_mora plan_pago_mora%rowtype;
  _cur_plan_pago_cuota refcursor;
  _cur_prestamo refcursor;
  _cur_solicitud refcursor;
  _cur_solicitud_anticipo_societario refcursor;
  _cur_desembolso refcursor;
  _cur_desembolso_pago refcursor;
  _cur_factura refcursor;
  _cur_pago refcursor;
  _cur_pago_cliente refcursor;
  _cur_pago_forma refcursor;
  _cur_pago_cuota refcursor;
  _cur_pago_prestamo refcursor;
  _cur_garantia refcursor;
  _cur_empresa refcursor;
  _cur_producto refcursor;
  _cur_programa refcursor;
  _cur_prestamo_modificacion refcursor;
  _cur_prestamo_modificacion_rubro refcursor;
  _cur_prestamo_modificacion_rubro_atributo refcursor;
  _cur_prestamo_rubro refcursor;
  _cur_prestamo_rubro_atributo refcursor;
  _cur_plan_pago_mora refcursor;
  _cur_plan_pago refcursor;
  _fecha_focal date;
  _plan_pago_id integer;
  _plan_pago_cuota_id integer;
  _monto_insoluto float;
  _meses_muertos integer = 0;
  _meses_gracia integer = 0;
  _plazo integer = 0;
  _motivo_evento char;
  _valor_tasa float = 0;
  _factura_id integer;
  _monto_cuota numeric(16,2);
  _monto_cuota_gracia numeric(16,2);
  _monto_cuota_aux numeric(16,2);
  _saldo_insoluto numeric(16,2);
  _saldo_insoluto_original numeric(16,2);
  _bf bool;
  _saldo_ult_cuota_pagada numeric(16,2);
  _amortizado_aux numeric(16,2);
  _interes_acumulado_ult_cuota_pagada numeric(16,2);
  _amortizacion_acumulada_ult_cuota_pagada numeric(16,2);
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;

  _interes_corriente_aux numeric(16,2);
  _interes_diferido_aux numeric(16,2);
  _interes_mora_aux numeric(16,2);
  _interes_causado_aux numeric(16,2);
  _capital_aux numeric(16,2);

  _monto_aux_redondeo numeric(18,3);

  _saldo_insoluto_aux numeric(16,2);
  _monto_liquidado_aux float;
  _monto_solicitado_aux float;
  _monto_aprobado_aux float;
  _remanente_por_aplicar_aux numeric(16,2);
  _abono_monto_minimo_aux float;
  _saldo_deudor_aux float;
  _saldo_capital_aux float;
  _saldo_cuota_anterior numeric(16,2);

  _aumento_capital_aux float;
  _monto_cliente_aux float;
  _monto_aux float;
  _aporte_mensual_aux float;
  _interes_desembolso_aux numeric(16,2);
  _efectivo_aux numeric(16,2);
  _monto_garantia_aux float;
  _monto_avaluo_inicial_aux float;
  _monto_avaluo_foncrei_aux float;
  _capital_suscrito_aux float;
  _capital_pagado_aux float;
  _monto_maximo_aux float;
  _monto_minimo_aux float;
  _relacion_garantia_aux float;
  _monto_propuesta_social_aux float;
  _volumen_facturacion_aux float;
  _monto_desembolso_aux float;
  _monto_abono_aux float;
  _aporte_propio_aux float;
  _aporte_foncrei_aux float;
  _otras_fuentes_aux float;
  _valor_total_aux float;
  _total_deuda_aux float;
  _valor_f_aux float;
  _capital_aux_f float;
  _valor_aux float;
 
begin

	-- ojo quitar  el join

	open _cur_prestamo for 

		select * 
		from 
			prestamo

		where 
			prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A') 
 
		order by prestamo.id;

	loop

		fetch _cur_prestamo INTO _prestamo;
		exit when not found;

		  -- redondeo de campos tipo numeric

		  _saldo_insoluto_aux = round((_prestamo.saldo_insoluto / 1000),2);
		  _remanente_por_aplicar_aux = round((_prestamo.remanente_por_aplicar / 1000),2);


		  -- redondeo de campos tipo float

		  _monto_aux_redondeo = _prestamo.monto_liquidado;
		  _monto_liquidado_aux = round((_monto_aux_redondeo / 1000),2);
		
		  _monto_aux_redondeo = _prestamo.monto_solicitado;
		  _monto_solicitado_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.monto_aprobado;
		  _monto_aprobado_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.abono_monto_minimo;
		  _abono_monto_minimo_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.saldo_deudor;
		  _saldo_deudor_aux = round((_monto_aux_redondeo / 1000),2);

		  _monto_aux_redondeo = _prestamo.saldo_capital;
		  _saldo_capital_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion del prestamo

		update prestamo set 
				saldo_insoluto = _saldo_insoluto_aux,
				monto_liquidado = _monto_liquidado_aux,
				monto_solicitado = _monto_solicitado_aux,
				monto_aprobado =  _monto_aprobado_aux,
				remanente_por_aplicar = _remanente_por_aplicar_aux,
				abono_monto_minimo = _abono_monto_minimo_aux,
				saldo_deudor = _saldo_deudor_aux,
				saldo_capital = _saldo_capital_aux,
				deuda	      = round((deuda/1000),2)

		where 
				prestamo.id = _prestamo.id;

	--Selecciono el plan pago asociado al prestamo

	select into _plan_pago * from plan_pago 

		where plan_pago.prestamo_id = _prestamo.id and plan_pago.activo = true;


	  /*
	  -----------------------------------------------------------
	  Apertura del cursor para actualizacion de plan_pago_cuota
	  -----------------------------------------------------------
	  */

	  open _cur_plan_pago_cuota for
		
		select * 
		from 
			plan_pago_cuota
		where 
			
			plan_pago_cuota.plan_pago_id = _plan_pago.id
            
		order by tipo_cuota desc,
                         numero asc;

		/*
		--------------------------------------------
		Inicio recorrido de cursor plan_pago_cuota
		--------------------------------------------
		*/

		loop
			fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
			exit when not found; 

			if _plan_pago_cuota.tipo_cuota = 'G' then

				_monto_cuota_gracia = round((_plan_pago_cuota.valor_cuota/1000),2);
			else
				_monto_cuota = round((_plan_pago_cuota.valor_cuota/1000),2);
			end if;

			
			if _plan_pago_cuota.tipo_cuota = 'M' or
                           _plan_pago_cuota.tipo_cuota = 'G' or 
			   _plan_pago_cuota.tipo_cuota = 'C' then
			
				_saldo_insoluto = round((_plan_pago_cuota.saldo_insoluto/1000),2);
			end if; 
			

			if _plan_pago_cuota.tipo_cuota <> 'M' then

				if _plan_pago_cuota.tipo_cuota = 'C' then
	
					_monto_cuota_aux = _monto_cuota;
				else
					_monto_cuota_aux = _monto_cuota_gracia;
				end if;

				_interes_corriente_aux = round((_plan_pago_cuota.interes_corriente/1000),2);

				if _plan_pago_cuota.tipo_cuota = 'G' then

					_amortizado_aux = 0;
				else
				    
					_amortizado_aux = _monto_cuota_aux - _interes_corriente_aux;
				end if;


				/*
				---------------------------
				Actualizacion de la cuota
				---------------------------
				*/

				update plan_pago_cuota set
						valor_cuota = _monto_cuota_aux,
						interes_corriente = _interes_corriente_aux,
						amortizado = _amortizado_aux,
						amortizado_acumulado = round((amortizado_acumulado / 1000),2),
						interes_corriente_acumulado = round((interes_corriente_acumulado / 1000),2),
						saldo_insoluto = _saldo_insoluto,
						interes_diferido = round((_plan_pago_cuota.interes_diferido / 1000),2),
						interes_mora = round((_plan_pago_cuota.interes_mora / 1000),2),
						pago_interes_mora = round((_plan_pago_cuota.pago_interes_mora / 1000),2),
						pago_interes_corriente = round((_plan_pago_cuota.pago_interes_corriente / 1000),2),
						pago_interes_diferido = round((_plan_pago_cuota.pago_interes_diferido / 1000),2),
						pago_capital = round((_plan_pago_cuota.pago_capital / 1000),2),
						remanente_por_aplicar = round((_plan_pago_cuota.remanente_por_aplicar / 1000),2),
						causado_no_devengado = round((_plan_pago_cuota.causado_no_devengado / 1000),2),
						monto_desembolso = round((_plan_pago_cuota.monto_desembolso / 1000),2),
						monto_abono = round((_plan_pago_cuota.monto_abono / 1000),2),
						interes_desembolso = round((_plan_pago_cuota.interes_desembolso / 1000),2),
						pago_interes_desembolso = round((_plan_pago_cuota.pago_interes_desembolso / 1000),2),
						interes_foncrei = round((_plan_pago_cuota.interes_foncrei / 1000),2),
						interes_intermediario = round((_plan_pago_cuota.interes_intermediario / 1000),2),
						mora_exonerada = round((_plan_pago_cuota.mora_exonerada / 1000),2),
						intereses_por_cobrar_al_30 = round((_plan_pago_cuota.intereses_por_cobrar_al_30 / 1000),2),
						pago_interes_corriente_acumulado = _saldo_insoluto_original
				where
					plan_pago_cuota.id = _plan_pago_cuota.id;


			end if;

		end loop;

		close _cur_plan_pago_cuota;

	-- A continuacion se actualizan los campos del prestamo
	
  end loop;
  
  close _cur_prestamo;
  /*
  -------------------------------------------------
  Después de convertir todas las cuotas a Bolivar
  Fuerte, se actualizan de las últimas cuotas de 
  cada prestamo para actualizar el saldo en cero
  -------------------------------------------------
  */
  

  /*
  --------------------------------------------------
  Se crea un cursor de plan pago para determinar
  la ultima cuota del plan_pago_cuota
  --------------------------------------------------
  */

  open _cur_plan_pago for

	select *
	from
		plan_pago
	where
		plan_pago.activo = true;

  loop
	fetch _cur_plan_pago INTO _plan_pago;
	exit when not found;

	/*
	-----------------------------------------
	Se selecciona la última cuota de amorti-
	zación
	-----------------------------------------
	*/

	select into 
		_plan_pago_cuota *
	from
		plan_pago_cuota
	where
		plan_pago_cuota.plan_pago_id 	= _plan_pago.id and
                plan_pago_cuota.tipo_cuota 	= 'C'

	order by 
		fecha desc
	limit 1;

	if _plan_pago_cuota.id is not null then
	
		update
			plan_pago_cuota 
		set
			saldo_insoluto = 0 
		where
			plan_pago_cuota.id = _plan_pago_cuota.id;
	end if;

  end loop;

  close _cur_plan_pago;

  raise notice 'Termino conversion de prestamo y plan pago_________________________';

	/*
	---------------------------------------------------
	Comienza la actualizacion del resto de las tablas
	---------------------------------------------------
	*/

	/*
	--------------------------------------------------------------
	Actualizacion de la tabla de prestamo_modificacion a Bolivar
	fuerte
	--------------------------------------------------------------
	*/

	open _cur_prestamo_modificacion
	for select * from prestamo_modificacion
	order by id;

	loop
		fetch _cur_prestamo_modificacion INTO _prestamo_modificacion;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 		= _prestamo_modificacion.monto;
		_monto_aux 			= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.aumento_capital;
		_aumento_capital_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.saldo_insoluto;
		_saldo_insoluto_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_diferido;
		_interes_diferido_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_desembolso;
		_interes_desembolso_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_mora;
		_interes_mora_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_ordinario;
		_interes_corriente_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.interes_causado;
		_interes_causado_aux		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.remanente_por_aplicar;
		_remanente_por_aplicar_aux	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _prestamo_modificacion.total_deuda;
		_total_deuda_aux		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro modificacion del prestamo (prestamo_modificacion)

		update prestamo_modificacion set

			monto 			= _monto_aux,
			aumento_capital		= _aumento_capital_aux,
			saldo_insoluto		= _saldo_insoluto_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_desembolso	= _interes_desembolso_aux,
			interes_mora		= _interes_mora_aux,
			interes_ordinario	= _interes_corriente_aux,
			interes_causado		= _interes_causado_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			total_deuda		= _total_deuda_aux
		where
			prestamo_modificacion.id = _prestamo_modificacion.id;

	end loop;

	close _cur_prestamo_modificacion;

	raise notice 'Termino conversion de modificación del préstamo (prestamo_modificacion)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_rubro
	for select * from prestamo_rubro
	order by id;

	loop
		fetch _cur_prestamo_rubro INTO _prestamo_rubro;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_propio;
		_aporte_propio_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_foncrei;
		_aporte_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.otras_fuentes;
		_otras_fuentes_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.valor_total;
		_valor_total_aux 	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro rubros del prestamo (prestamo_rubro)

		update prestamo_rubro set

			aporte_propio 		= _aporte_propio_aux,
			aporte_foncrei		= _aporte_foncrei_aux,
			otras_fuentes		= _otras_fuentes_aux,
			valor_total		= _valor_total_aux
		where
			prestamo_rubro.id = _prestamo_rubro.id;

	end loop;

	close _cur_prestamo_rubro;

	raise notice 'Termino conversion de rubros del prestamo (prestamo_rubro)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_rubro_atributo
	for select * from prestamo_rubro_atributo
	order by id;

	loop
		fetch _cur_prestamo_rubro_atributo INTO _prestamo_rubro_atributo;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro_atributo.valor_f;
		_valor_f_aux 		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro atributo del rubro del prestamo (prestamo_rubro_atributo)

		update prestamo_rubro_atributo set

			valor_f 		= _valor_f_aux
		where
			prestamo_rubro_atributo.id = _prestamo_rubro_atributo.id;

	end loop;

	close _cur_prestamo_rubro_atributo;

	raise notice 'Termino conversion de atributos del rubro del prestamo (prestamo_rubro_atributo)___________________';

	/*
	-------------------------------------------------------------------
	Actualizacion de la tabla de prestamo_modifcacion_rubro a Bolivar
	fuerte
	-------------------------------------------------------------------
	*/

	open _cur_prestamo_modificacion_rubro
	for select * from prestamo_modificacion_rubro
	order by id;

	loop
		fetch _cur_prestamo_modificacion_rubro INTO _prestamo_modificacion_rubro;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_propio;
		_aporte_propio_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.aporte_foncrei;
		_aporte_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.otras_fuentes;
		_otras_fuentes_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _prestamo_rubro.valor_total;
		_valor_total_aux 	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro rubros del prestamo (prestamo_rubro)

		update prestamo_modificacion_rubro set

			aporte_propio 		= _aporte_propio_aux,
			aporte_foncrei		= _aporte_foncrei_aux,
			otras_fuentes		= _otras_fuentes_aux,
			valor_total		= _valor_total_aux
		where
			prestamo_modificacion_rubro.id = _prestamo_modificacion_rubro.id;

	end loop;

	close _cur_prestamo_modificacion_rubro;

	raise notice 'Termino conversion de rubros del prestamo modificación rubro (prestamo_modificaion_rubro)___________________';

	/*
	-------------------------------------------------------
	Actualizacion de la tabla de prestamo_rubro a Bolivar
	fuerte
	-------------------------------------------------------
	*/

	open _cur_prestamo_modificacion_rubro_atributo
	for select * from prestamo_modificacion_rubro_atributo
	order by id;

	loop
		fetch _cur_prestamo_modificacion_rubro_atributo INTO _prestamo_modificacion_rubro_atributo;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo 	= _prestamo_modificacion_rubro_atributo.valor_f;
		_valor_f_aux 		= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro atributo del rubro del prestamo (prestamo_rubro_atributo)

		update prestamo_modificacion_rubro_atributo set

			valor_f 		= _valor_f_aux
		where
			prestamo_modificacion_rubro_atributo.id = _prestamo_modificacion_rubro_atributo.id;

	end loop;

	close _cur_prestamo_modificacion_rubro_atributo;

	raise notice 'Termino conversion de atributos del rubro del prestamo (prestamo_modificacion_rubro_atributo)___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de solicitudes a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_solicitud 
	for select * from solicitud
	order by id;

	loop
		fetch _cur_solicitud INTO _solicitud;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _solicitud.monto_solicitado;
		_monto_solicitado_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_aprobado;
		_monto_aprobado_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.aumento_capital;
		_aumento_capital_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_cliente;
		_monto_cliente_aux = round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo = _solicitud.monto_propuesta_social;
		_monto_propuesta_social_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de solicitud

		update solicitud set

			monto_solicitado 	= _monto_solicitado_aux,
			monto_aprobado		= _monto_aprobado_aux,
			aumento_capital		= _aumento_capital_aux,
			monto_cliente		= _monto_cliente_aux,
			monto_propuesta_social	= _monto_propuesta_social_aux
		where
			solicitud.id = _solicitud.id;

	end loop;

	close _cur_solicitud;

	raise notice 'Termino conversion de solicitud___________________';

	/*
	-------------------------------------------------------------------------
	Actualizacion de la tabla de solicitud de anticipo societario a Bolivar
	fuerte
	-------------------------------------------------------------------------
	*/

	open _cur_solicitud_anticipo_societario 
	for select * from solicitud_anticipo_societario
	order by id;

	loop
		fetch _cur_solicitud_anticipo_societario INTO _solicitud_anticipo_societario;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux = _solicitud_anticipo_societario.aporte_mensual;
		_aporte_mensual_aux = round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de solicitud_anticipo_societario

		update solicitud_anticipo_societario set

			aporte_mensual 	= _aporte_mensual_aux
		where
			solicitud_anticipo_societario.id = _solicitud_anticipo_societario.id;

	end loop;

	close _cur_solicitud_anticipo_societario;

	raise notice 'Termino conversion de solicitud_anticipo_societario___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de desembolso a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_desembolso 
	for select * from desembolso
	order by id;

	loop
		fetch _cur_desembolso INTO _desembolso;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _desembolso.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		_interes_desembolso_aux = round((_desembolso.interes_desembolso / 1000),2);

		-- Actualizacion de registro de desembolso

		update desembolso set

			monto 			= _monto_aux,
			interes_desembolso	= _interes_desembolso_aux
		where
			desembolso.id = _desembolso.id;

	end loop;

	close _cur_desembolso;

	raise notice 'Termino conversion de desembolso___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de desembolso_pago a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_desembolso_pago 
	for select * from desembolso_pago
	order by id;

	loop
		fetch _cur_desembolso_pago INTO _desembolso_pago;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _desembolso_pago.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de desembolso_pago

		update desembolso_pago set

			monto 			= _monto_aux
		where
			desembolso_pago.id = _desembolso_pago.id;

	end loop;

	close _cur_desembolso_pago;

	raise notice 'Termino conversion de desembolso_pago___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de pago_forma a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_pago_forma 
	for select * from pago_forma
	order by id;

	loop
		fetch _cur_pago_forma INTO _pago_forma;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _pago_forma.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de pago_forma
		update pago_forma set

			monto 			= _monto_aux
		where
			pago_forma.id = _pago_forma.id;

	end loop;

	close _cur_pago_forma;

	raise notice 'Termino conversion de pago_forma___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_cliente a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_cliente 
	for select * from pago_cliente
	order by id;

	loop
		fetch _cur_pago_cliente INTO _pago_cliente;
		exit when not found;

		-- Redondeo de campos numericos tipo float

		_monto_aux_redondeo = _pago_cliente.monto;
		_monto_aux = round((_monto_aux_redondeo / 1000),2);

		_efectivo_aux = round((_pago_cliente.efectivo / 1000),2);

		-- Actualizacion de registro de desembolso

		update pago_cliente set

			monto 		= _monto_aux,
			efectivo	= _efectivo_aux
		where
			pago_cliente.id = _pago_cliente.id;

	end loop;

	close _cur_pago_cliente;

	raise notice 'Termino conversion de pago_cliente___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_cuota a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_cuota
	for select * from pago_cuota
	order by id;

	loop
		fetch _cur_pago_cuota INTO _pago_cuota;
		exit when not found;

		_monto_aux = round((_pago_cuota.monto / 1000),2);
		_interes_corriente_aux = round((_pago_cuota.interes_corriente / 1000),2);
		_interes_diferido_aux = round((_pago_cuota.interes_diferido / 1000),2);
		_interes_mora_aux = round((_pago_cuota.interes_mora / 1000),2);
		_capital_aux = round((_pago_cuota.capital / 1000),2);
		_remanente_por_aplicar_aux = round((_pago_cuota.remanente_por_aplicar / 1000),2);
		_interes_desembolso_aux = round((_pago_cuota.interes_desembolso / 1000),2);

		-- Actualizacion de registro de pago_cuota

		update pago_cuota set

			monto 			= _monto_aux,
			interes_corriente	= _interes_corriente_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_mora		= _interes_mora_aux,
			capital			= _capital_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			interes_desembolso	= _interes_desembolso_aux
		where
			pago_cuota.id = _pago_cuota.id;

	end loop;

	close _cur_pago_cuota;
	raise notice 'Termino conversion de pago_cuota___________________';

	/*
	----------------------------------------------------
	Actualizacion de la tabla de pago_prestamo a Bolivar
	fuerte
	----------------------------------------------------
	*/

	open _cur_pago_prestamo
	for select * from pago_prestamo
	order by id;

	loop
		fetch _cur_pago_prestamo INTO _pago_prestamo;
		exit when not found;

		_monto_aux = round((_pago_prestamo.monto / 1000),2);
		_interes_corriente_aux = round((_pago_prestamo.interes_corriente / 1000),2);
		_interes_diferido_aux = round((_pago_prestamo.interes_diferido / 1000),2);
		_interes_mora_aux = round((_pago_prestamo.interes_mora / 1000),2);
		_capital_aux = round((_pago_prestamo.capital / 1000),2);
		_remanente_por_aplicar_aux = round((_pago_prestamo.remanente_por_aplicar / 1000),2);
		_interes_desembolso_aux = round((_pago_prestamo.interes_desembolso / 1000),2);
		_interes_causado_aux = round((_pago_prestamo.interes_causado / 1000),2);
		_saldo_insoluto_aux = round((_pago_prestamo.saldo_insoluto / 1000),2);

		-- Actualizacion de registro de pago_prestamo

		update pago_prestamo set

			monto 			= _monto_aux,
			interes_corriente	= _interes_corriente_aux,
			interes_diferido	= _interes_diferido_aux,
			interes_mora		= _interes_mora_aux,
			capital			= _capital_aux,
			remanente_por_aplicar	= _remanente_por_aplicar_aux,
			interes_desembolso	= _interes_desembolso_aux,
			interes_causado		= _interes_causado_aux,
			saldo_insoluto		= _saldo_insoluto_aux
		where
			pago_prestamo.id = _pago_prestamo.id;

	end loop;

	close _cur_pago_prestamo;
	raise notice 'Termino conversion de pago_prestamo___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de factura a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_factura 
	for select * from factura
	order by id;

	loop
		fetch _cur_factura INTO _factura;
		exit when not found;


		_monto_aux 	= round((_factura.monto / 1000),2);

		-- Actualizacion de registro de factura

		update factura set

			monto 			= _monto_aux
		where
			factura.id = _factura.id;

	end loop;

	close _cur_factura;

	raise notice 'Termino conversion de factura___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de Garantia a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_garantia 
	for select * from garantia
	order by id;

	loop
		fetch _cur_garantia INTO _garantia;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 		= _garantia.monto_garantia;
		_monto_garantia_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _garantia.monto_avaluo_inicial;
		_monto_avaluo_inicial_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _garantia.monto_avaluo_foncrei;
		_monto_avaluo_foncrei_aux 	= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de garantia

		update garantia set

			monto_garantia		= _monto_garantia_aux,
			monto_avaluo_inicial	= _monto_avaluo_inicial_aux,
			monto_avaluo_foncrei	= _monto_avaluo_foncrei_aux
		where
			garantia.id = _garantia.id;

	end loop;

	close _cur_garantia;

	raise notice 'Termino conversion de garantia___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de empresa a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_empresa 
	for select * from empresa
	order by id;

	loop
		fetch _cur_empresa INTO _empresa;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 	= _empresa.capital_suscrito;
		_capital_suscrito_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _empresa.capital_pagado;
		_capital_pagado_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 		= _empresa.volumen_facturacion;
		_volumen_facturacion_aux 	= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de empresa
		update empresa set

			capital_suscrito	= _capital_suscrito_aux,
			capital_pagado		= _capital_pagado_aux,
			volumen_facturacion	= _volumen_facturacion_aux
		where
			empresa.id = _empresa.id;

	end loop;

	raise notice 'Termino conversion de empresa___________________';

	/*
	--------------------------------------------------------
	Actualizacion de la tabla de producto a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_producto 
	for select * from producto
	order by id;

	loop
		fetch _cur_producto INTO _producto;
		exit when not found;


		_monto_aux_redondeo 	= _producto.monto_maximo;
		_monto_maximo_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _producto.monto_minimo;
		_monto_minimo_aux 	= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _producto.abono_monto_minimo;
		_abono_monto_minimo_aux	= round((_monto_aux_redondeo / 1000),2);

		-- Actualizacion de registro de garantia

		update producto set

			monto_maximo		= _monto_maximo_aux,
			monto_minimo		= _monto_minimo_aux,
			abono_monto_minimo	= _abono_monto_minimo_aux
		where
			producto.id = _producto.id;

	end loop;


	close _cur_producto;

	raise notice 'Termino conversion de producto___________________';


	/*
	--------------------------------------------------------
	Actualizacion de la tabla de Plan Pago Mora a Bolivar
	fuerte
	--------------------------------------------------------
	*/

	open _cur_plan_pago_mora 
	for select * from plan_pago_mora
	order by id;

	loop
		fetch _cur_plan_pago_mora INTO _plan_pago_mora;
		exit when not found;

		-- Redondeo de valores float

		_monto_aux_redondeo 	= _plan_pago_mora.monto;
		_monto_aux 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _plan_pago_mora.capital;
		_capital_aux_f 		= round((_monto_aux_redondeo / 1000),2);

		_monto_aux_redondeo 	= _plan_pago_mora.valor;
		_valor_aux 		= round((_monto_aux_redondeo / 1000),2);


		-- Actualizacion de registro de Plan Pago Mora

		update plan_pago_mora set

			monto		= _monto_aux,
			capital		= _capital_aux_f,
			valor		= _valor_aux
		where
			plan_pago_mora.id = _plan_pago_mora.id;

	end loop;

	close _cur_plan_pago_mora;

	raise notice 'Termino conversion de plan pago mora___________________';



  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.conversion_bolivar_fuerte_manual() OWNER TO cartera;

--
-- Name: ejecutar_abono_extraordinario(integer, integer, character varying[], character, double precision, integer, date, double precision, character varying, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION ejecutar_abono_extraordinario(p_cliente_id integer, p_prestamo_id integer, p_cheques character varying[], p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha date, p_efectivo double precision, p_numero_voucher character varying, p_entidad_financiera_id integer) RETURNS integer
    AS $$

 declare

     _pago_cliente_id integer;   

     _pago_monto_prestamo float;

     _prestamo_id integer;

     _pago_prestamo_id integer;    

     _remanente_por_aplicar NUMERIC(14, 2);

     _factura_id integer;  

     _prestamo prestamo%rowtype;

     _entidad_financiera entidad_financiera%rowtype;

     _cuenta_contable_banco cuenta_contable%rowtype;    

     _codigo_cuenta_contable_banco integer = 0;

     

 begin

 

 

   raise notice 'monto%',p_monto;

   -- Inserta el pago_cliente

   insert into pago_cliente (fecha, modalidad, monto, cliente_id, oficina_id, fecha_realizacion, numero_voucher, entidad_financiera_id, efectivo)

     values (p_fecha, p_modalidad, p_monto, p_cliente_id, p_oficina_id, p_fecha, p_numero_voucher, p_entidad_financiera_id, p_efectivo);

   

   _pago_cliente_id = currval('pago_cliente_id_seq');

   

   if p_modalidad = 'R' then

     select into _entidad_financiera * from entidad_financiera where id = p_entidad_financiera_id;

     select into _cuenta_contable_banco * from cuenta_contable where id = _entidad_financiera.cuenta_contable_id;

     _codigo_cuenta_contable_banco = _cuenta_contable_banco.id;

   end if;

   

   -- Inserta las pago_forma

   for i in array_lower(p_cheques,1) .. array_upper(p_cheques,1) loop

     insert into pago_forma (forma, entidad_financiera_id, referencia, monto, pago_cliente_id)

         values ( p_cheques[i][1], cast(p_cheques[i][2] as integer), p_cheques[i][3], 

         cast(p_cheques[i][4] as float), _pago_cliente_id );

   end loop;

 

   -- Paga los prestamos, recorre primero los prestamos que quiere pagar

  -- for i in array_lower(p_prestamos,1) .. array_upper(p_prestamos,1) loop  

       

    -- _pago_monto_prestamo = cast(p_prestamos[i][2] as float);

     _pago_monto_prestamo = p_monto;

     _prestamo_id = p_prestamo_id;

     

     select into _prestamo * from prestamo

       where id = _prestamo_id;

     

     _remanente_por_aplicar = _pago_monto_prestamo + _prestamo.remanente_por_aplicar ;

     

     raise notice 'remanente_por_aplicar antes de iniciar___________________%',_remanente_por_aplicar;     

     

     insert into pago_prestamo (monto, prestamo_id, pago_cliente_id)

         values(_pago_monto_prestamo, _prestamo_id, _pago_cliente_id);

 

     _pago_prestamo_id = currval('pago_prestamo_id_seq');

 

     

     update pago_prestamo set 

 	  interes_diferido = 0,

 	  interes_mora = 0,

 	  interes_desembolso = 0,

 	  interes_corriente = 0,

 	  capital = 0,

 	  remanente_por_aplicar = _remanente_por_aplicar,

 	  monto = _pago_monto_prestamo

 	  where id = _pago_prestamo_id;

     

     update prestamo set remanente_por_aplicar = _remanente_por_aplicar 

       where id = _prestamo_id;

       

     perform calcular_prestamo(_prestamo_id, p_fecha, false);  

     

     

   --end loop;

   

   insert into factura (numero, monto, fecha, fecha_realizacion, pago_cliente_id, tipo, proceso_nocturno, prestamo_id)

     values ((select numero from factura order by numero desc limit 1) + 1, p_monto, p_fecha,

     p_fecha, _pago_cliente_id, 'A', false, _prestamo_id);

 

   _factura_id = currval('factura_id_seq');

   

  update parametro_general set ultima_factura = ultima_factura + 1;

  

  raise notice 'modalidad________________%',  p_modalidad;

  raise notice '_codigo_cuenta_contable_banco________________%',  _codigo_cuenta_contable_banco;

   perform stc_abono_extraordinario_online(p_modalidad, _codigo_cuenta_contable_banco, p_monto, p_fecha, p_fecha, _prestamo_id, _factura_id, cast( extract(year from p_fecha) as integer));

     

  --raise exception 'error';

   return _factura_id;

   

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ejecutar_abono_extraordinario(p_cliente_id integer, p_prestamo_id integer, p_cheques character varying[], p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha date, p_efectivo double precision, p_numero_voucher character varying, p_entidad_financiera_id integer) OWNER TO cartera;

--
-- Name: ejecutar_cierre_batch(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION ejecutar_cierre_batch() RETURNS boolean
    AS $$
declare  
  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Se verifica que el cierre no se encuentre ejecutandose o que ya fue ejecutado.
	-------------------------------------------------------------------------------
	*/

	select into 
			_control_cierre * 
	from 
			control_cierre  
	where
			control_cierre.senal_enproceso 	= false and
			control_cierre.senal_cerrado	= false and
                        control_cierre.senal_shell	= false;

	if _control_cierre.fecha_proceso is not null then
	
		/*
		------------------------------------------------------------------
		Actualizacion de la senal en proceso para la tabla control_cierre
		-------------------------------------------------------------------
		*/

		update control_cierre set
					senal_enproceso = true
		where
					control_cierre.id = _control_cierre.id;

		/*
		------------------------------------------------------------------
		Construccion del cursor de programas
		------------------------------------------------------------------
		*/

		select  into _programa *
 
				from 
					programa
				where 
					programa.fecha_cierre < _control_cierre.fecha_proceso
				order by 
					programa.id
                                limit 1;


		/*
		----------------------------------------------------
		Inicio del loop del cierre de cartera por programa
		----------------------------------------------------
		*/

		if _programa.id is not null then

			raise notice 'Cerrando el programa__________________________________ % ', _programa.nombre;

			perform calcular_cartera_programa(_control_cierre.fecha_proceso,1,_programa.id);
			
			raise notice 'Fin del cierre del programa___________________________ % ', _programa.nombre;
                        
			/*
			-------------------------------------------
			Actualiza la fecha de cierre del programa
			-------------------------------------------
			*/

			update programa set
					fecha_cierre = _control_cierre.fecha_proceso
			where
					programa.id = _programa.id;

			/*
			------------------------------------------------------------------
			Actualizacion de la senal en proceso para la tabla control_cierre
			-------------------------------------------------------------------
			*/

			update control_cierre set
						senal_enproceso = false
			where
						control_cierre.id = _control_cierre.id;

			/*
			-------------------------------------------------------
			Se retorna el valor false para continuar con el cierre
			de los siguientes programas desde el shell
			-------------------------------------------------------
			*/

			return false;

		else

			/*
			----------------------------------------------------------------
			Actualizacion de la senal cerrado para la tabla control_cierre
			----------------------------------------------------------------
			*/

			update control_cierre set
						senal_cerrado = true,
						fecha_ejecucion = current_date
			where
						control_cierre.id = _control_cierre.id;

			/*
			-----------------------------------------------------------------
			Generacion de nuevo registro en la tabla control_cierre para la
			proxima ejecucion del cierre de cartera
			-----------------------------------------------------------------
			*/

			_fecha_proceso_next = _control_cierre.fecha_proceso + 1;

			insert into control_cierre
						(
							fecha_proceso
						)
					values
						(	
							_fecha_proceso_next
						);

		end if;			--> if _programa.id not is null then

	end if;				--> if _control_cierre.fecha_proceso is not null then
    
  raise notice 'Finalizo el proceso de Cierre de Cartera_________________________';
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ejecutar_cierre_batch() OWNER TO cartera;

--
-- Name: ejecutar_cierre_shell(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION ejecutar_cierre_shell() RETURNS boolean
    AS $$
declare  
  _programa programa%rowtype;
  _control_cierre control_cierre%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_programa refcursor;
  
  
begin

	/*
	-------------------------------------------------------------------------------
	Se verifica que el cierre no se encuentre ejecutandose o que ya fue ejecutado.
	-------------------------------------------------------------------------------
	*/

	select into 
			_control_cierre * 
	from 
			control_cierre  
	where
			control_cierre.senal_enproceso 	= false and
			control_cierre.senal_cerrado	= false and
                        control_cierre.senal_shell	= true;

	if _control_cierre.fecha_proceso is not null then
	
		/*
		------------------------------------------------------------------
		Actualizacion de la senal de shell para la tabla control_cierre
		-------------------------------------------------------------------
		*/

		update control_cierre set
					senal_shell = false
		where
					control_cierre.id = _control_cierre.id;


	end if;				--> if _control_cierre.fecha_proceso is not null then
    
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ejecutar_cierre_shell() OWNER TO cartera;

--
-- Name: ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_hay_cheques boolean, p_exonerar_mora boolean) RETURNS integer
    AS $$





 declare





     _factura_id integer;





  





 begin





  _factura_id = ejecutar_pago(





 	  p_cliente_id,





 	  p_cheques,





 	  p_prestamo_id,





 	  p_modalidad,





 	  p_monto,





 	  p_oficina_id,





 	  p_fecha_realizacion,





 	  p_fecha,





 	  p_numero_voucher,





 	  p_monto_efectivo,





 	  p_entidad_financiera_id,





 	  p_proceso_nocturno, false, p_hay_cheques, p_exonerar_mora);





   





   return _factura_id;





 





   





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_hay_cheques boolean, p_exonerar_mora boolean) OWNER TO cartera;

--
-- Name: ejecutar_pago(integer, character varying[], integer, character, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_cancelacion_prestamo boolean, p_hay_cheques boolean, p_exonerar_mora boolean) RETURNS integer
    AS $$
declare
    _factura factura%rowtype;
    _pago_cliente_id integer;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _cur_plan_pago_cuota refcursor;
    _deuda_cuota float;
    _pago_monto_prestamo float;
    _prestamo_id integer;
    _pago_prestamo_id integer;
    _deuda_interes_corriente NUMERIC(14, 2);
    _deuda_interes_mora NUMERIC(14, 2);
    _deuda_interes_diferido NUMERIC(14, 2);
    _deuda_interes_desembolso NUMERIC(14, 2);
    _deuda_capital NUMERIC(14, 2);
    _pago_interes_corriente NUMERIC(14, 2);
    _pago_acumulado_interes_corriente float;
    _pago_interes_mora NUMERIC(14, 2);
    _pago_acumulado_interes_mora NUMERIC(14, 2);
    _pago_interes_diferido NUMERIC(14, 2);
    _pago_acumulado_interes_diferido NUMERIC(14, 2);
    _pago_interes_desembolso NUMERIC(14, 2);
    _pago_acumulado_interes_desembolso NUMERIC(14, 2);    
    _pago_capital NUMERIC(14, 2);
    _pago_acumulado_capital NUMERIC(14, 2);
    _pago_cuota_total NUMERIC(14, 2);
    _remanente_por_aplicar NUMERIC(14, 2);
    _remanente_por_aplicar_inicial NUMERIC(14, 2) = 0;
    _remanente_por_aplicar_cuota float;
    _pago_incompleto bool = false;
    _factura_id integer;
    _estatus_pago char;
    _prepago bool;
    _prestamo prestamo%rowtype;
    _pago_cuota_id integer;
    _pago_cuota pago_cuota%rowtype;
    _pago_interes_mora_aux float = 0;
    _p_exonerar_mora bool = false;			---> Diego Bertaso
    
    _pago_real_interes_corriente NUMERIC(14, 2);
    _pago_real_interes_diferido NUMERIC(14, 2);
    _pago_real_interes_mora NUMERIC(14, 2);
    _pago_real_interes_desembolso NUMERIC(14, 2);
    _pago_real_capital NUMERIC(14, 2);
    _monto_factura NUMERIC(14, 2);
    _mora_exonerada NUMERIC(14, 2);
    
    -- INICIO CONTABILIDAD
    _con_entidad_financiera entidad_financiera%rowtype;
    _con_cuenta_contable_banco cuenta_contable%rowtype;    
    _con_codigo_cuenta_contable_banco integer;
    _con_remanente_por_aplicar_inicial NUMERIC(14,2) = 0;
    
    _con_programa_origen_fondo programa_origen_fondo%rowtype;
    _con_solicitud solicitud%rowtype;
    
    
    -- cuando la cuota esta vigente
    _con_monto_intereses_por_cobrar NUMERIC(14,2) = 0;
    _con_monto_intereses_por_cobrar_anio_2 NUMERIC(14,2) = 0; 
    _con_monto_ingreso_intereses NUMERIC(14,2) = 0;
    _con_monto_capital_cuota NUMERIC(14,2) = 0;
    _con_monto_capital_cuota_anio_2 NUMERIC(14,2) = 0;
    
    --cuando la cuota esta vencido
    _con_monto_intereses_por_cobrar_vencido NUMERIC(14,2) = 0;
    _con_monto_intereses_por_cobrar_vencido_anio_2 NUMERIC(14,2) = 0;
    -----este es el capital
    _con_monto_credito_cuota_vencido NUMERIC(14,2) = 0;
    _con_monto_credito_cuota_vencido_anio_2 NUMERIC(14,2) = 0;
    
    
    _anio_1 integer = 0;
    _anio_2 integer = 0;
    _monto_anio_1 numeric(14,2) = 0;
    _monto_anio_2 numeric(14,2) = 0; 
    _monto_mora_anio_1 numeric(14,2) = 0;
    _monto_mora_anio_2 numeric(14,2) = 0;
    
    _con_monto_comision_intermediario numeric(14,2) = 0;
    
    -- FIN CONTABILIDAD    
      _parametro_general parametro_general%rowtype;
      _fecha_calculo date;
begin
 -- raise notice 'monto%',p_monto;
  -- Inserta el pago_cliente
   _p_exonerar_mora = p_exonerar_mora;		---> Diego Bertaso	

   select into _prestamo * from prestamo
      where id = p_prestamo_id;
      
 -- if p_proceso_nocturno = true then
 -- 	perform iniciar_transaccion(_prestamo_id, 'p_pago_ordinario', 'L', 'Pago Ordinario (Cierre) para el préstamo Número '+_prestamo.numero, 1);
 -- end if;
  insert into pago_cliente (fecha, modalidad, monto, cliente_id, oficina_id, fecha_realizacion, numero_voucher, entidad_financiera_id, efectivo)
    values (p_fecha, p_modalidad, p_monto, p_cliente_id, p_oficina_id, p_fecha_realizacion, p_numero_voucher, p_entidad_financiera_id, p_monto_efectivo);
  
  _pago_cliente_id = currval('pago_cliente_id_seq');
  
  --INICIO CONTABILIDAD
  if p_modalidad = 'R' or p_modalidad = 'B' then
    select into _con_entidad_financiera * from entidad_financiera where id = p_entidad_financiera_id;
    select into _con_cuenta_contable_banco * from cuenta_contable where id = _con_entidad_financiera.cuenta_contable_id;
    _con_codigo_cuenta_contable_banco = _con_cuenta_contable_banco.id;
  end if;
  --FIN CONTABILIDAD
  
  
  -- Inserta las pago_forma
  if p_proceso_nocturno = false then
      if p_hay_cheques = true then
	  for i in array_lower(p_cheques,1) .. array_upper(p_cheques,1) loop
	    insert into pago_forma (forma, entidad_financiera_id, referencia, monto, pago_cliente_id)
	        values ( p_cheques[i][1], cast(p_cheques[i][2] as integer), p_cheques[i][3], 
	        cast(p_cheques[i][4] as float), _pago_cliente_id );
	  end loop;
	  end if;
  end if;
  -- Paga los prestamos, recorre primero los prestamos que quiere pagar
  --for i in array_lower(p_prestamos,1) .. array_upper(p_prestamos,1) loop  
  
    _pago_acumulado_interes_desembolso = 0;
    _pago_acumulado_interes_corriente = 0;
    _pago_acumulado_interes_diferido = 0;
    _pago_acumulado_interes_mora = 0;
    _pago_acumulado_capital = 0;
    
    --_pago_monto_prestamo = cast(p_prestamos[i][2] as float);
    _pago_monto_prestamo = p_monto;
    _prestamo_id = p_prestamo_id;
    
    raise notice '________________prestamo_id_%',_prestamo_id;
    
    _prepago = false;
   
     -- Inicio Contabilidad 
     
        select into _con_solicitud * from solicitud
            where id = _prestamo.solicitud_id;
     
        select into _con_programa_origen_fondo * from programa_origen_fondo
            where programa_id = _con_solicitud.programa_id 
            and origen_fondo_id = _con_solicitud.origen_fondo_id;
            
            
     -- Fin Contabilidad
     
     _con_remanente_por_aplicar_inicial = _prestamo.remanente_por_aplicar;
    _remanente_por_aplicar = _pago_monto_prestamo + _prestamo.remanente_por_aplicar ;
    _remanente_por_aplicar_inicial =  _remanente_por_aplicar;
    raise notice 'remanente_por_aplicar antes de iniciar___________________%',_remanente_por_aplicar; 
    if _prestamo.estatus = 'V' then
      _prepago = true;
    end if;

    /*
    --------------------------------------------------------------------------
    Diego Bertaso
    Se exonera la mora si el monto del pago es mayor o igual que el exigible
    fecha: 20/08/2007
    --------------------------------------------------------------------------
    */

    if _p_exonerar_mora = true and
	_pago_monto_prestamo  < _prestamo.exigible then
			_p_exonerar_mora = false;
    end if;

    ---> fin modificacion

    insert into pago_prestamo (monto, prestamo_id, pago_cliente_id)
        values(_pago_monto_prestamo, _prestamo_id, _pago_cliente_id);

    _pago_prestamo_id = currval('pago_prestamo_id_seq');

    if p_fecha_realizacion < p_fecha and _prestamo.estatus <> 'L' then
	   select into _parametro_general * from parametro_general limit 1;
	   _fecha_calculo = p_fecha_realizacion;
	  -- _fecha_calculo = agregar_dias(p_fecha_realizacion, +(_parametro_general.dias_gracia_mora+1));
	   raise notice 'fecha_calculo______________%',_fecha_calculo;
	   perform calcular_mora(_prestamo_id, p_fecha_realizacion, _fecha_calculo, false);
	end if;
    -- Paga las cuotas, recorre las cuotas del prestamo actual que quiere pagar  
    -- Si es prepago solo busca una cuota
    --if _prepago = false then
      --  raise notice 'NO es prepago';
	    open _cur_plan_pago_cuota for select * from plan_pago_cuota inner join plan_pago
	        on plan_pago_cuota.plan_pago_id = plan_pago.id 
	        where prestamo_id = _prestamo_id
	        and estatus_pago in ('N', 'P')	        
	        and plan_pago.activo = true
	        and plan_pago.proyeccion = false
	        and tipo_cuota in ('C', 'G') order by plan_pago_cuota.id;
    --else
    --raise notice 'es prepago';
    --    open _cur_plan_pago_cuota for select * from plan_pago_cuota inner join plan_pago
	--        on plan_pago_cuota.plan_pago_id = plan_pago.id 
	--        where prestamo_id = _prestamo_id
	--        and estatus_pago <> 'T'
	--        and plan_pago.activo = true
	--        and plan_pago.proyeccion = false
	--        and tipo_cuota in ('C', 'G') order by plan_pago_cuota.id limit 1;
    --end if;
    
    loop
      fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
	  exit when not found or _pago_incompleto = true;    
	  
	  raise notice 'cuota_numero_____________%',_plan_pago_cuota.numero;
	  raise notice 'tipo_____________%',_plan_pago_cuota.tipo_cuota;
	  raise notice 'estatus_pago_____________%',_plan_pago_cuota.estatus_pago;
	    
	  -- Si la fecha de realización es menor a la fecha de real
	  -- recalcula la mora de las cuotas impagas anteriores a la fecha de realización
	   
	  _pago_real_interes_desembolso = 0;
      _pago_real_interes_corriente = 0;
      _pago_real_interes_diferido = 0;
      _pago_real_interes_mora = 0;
      _pago_real_capital = 0;
      _mora_exonerada = 0;
       
      _deuda_cuota = _plan_pago_cuota.valor_cuota +     
	    _plan_pago_cuota.interes_mora + _plan_pago_cuota.interes_diferido -
	    (_plan_pago_cuota.pago_interes_mora + _plan_pago_cuota.pago_interes_corriente +
	    _plan_pago_cuota.pago_interes_diferido + _plan_pago_cuota.pago_capital);
	    
      _deuda_interes_desembolso = _plan_pago_cuota.interes_desembolso - _plan_pago_cuota.pago_interes_desembolso;
      _deuda_interes_diferido = _plan_pago_cuota.interes_diferido - _plan_pago_cuota.pago_interes_diferido;
      _deuda_interes_mora = _plan_pago_cuota.interes_mora - _plan_pago_cuota.pago_interes_mora;      
      _deuda_interes_corriente = _plan_pago_cuota.interes_corriente - _plan_pago_cuota.pago_interes_corriente;
      _deuda_capital = _plan_pago_cuota.amortizado - _plan_pago_cuota.pago_capital;
      --_remanente_por_aplicar = _remanente_por_aplicar + _plan_pago_cuota.remanente_por_aplicar;
     -- _pago_interes_desembolso = _plan_pago_cuota.pago_interes_desembolso;      
      --_pago_interes_diferido = _plan_pago_cuota.pago_interes_diferido;
      --_pago_interes_mora = _plan_pago_cuota.pago_interes_mora;      
      --_pago_interes_corriente = _plan_pago_cuota.pago_interes_corriente;
      --_pago_capital = _plan_pago_cuota.pago_capital;

      _pago_interes_desembolso = 0;      
      _pago_interes_diferido = 0;
      _pago_interes_mora = 0;      
      _pago_interes_corriente = 0;
      _pago_capital = 0;

      _remanente_por_aplicar_cuota = 0;
     -- raise notice 'numero_cuota___________________%',_plan_pago_cuota.numero;
      if _deuda_interes_diferido > 0 then
	      --if (_remanente_por_aplicar >= _deuda_interes_diferido) or (_deuda_interes_diferido-_remanente_por_aplicar<1) then
		if (_remanente_por_aplicar > 0) then
			if (_remanente_por_aplicar >= _deuda_interes_diferido) then
				_pago_interes_diferido = _deuda_interes_diferido;	        	
			else
				_pago_interes_diferido = _remanente_por_aplicar;
			end if;
	        _pago_acumulado_interes_diferido = _pago_acumulado_interes_diferido + _pago_interes_diferido;
	        _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_diferido;	
	      else
	        _pago_incompleto = true;
	      end if;
      end if;
      
	if _pago_incompleto = false and _deuda_interes_mora > 0 and p_proceso_nocturno = false then
		--raise notice 'tiene_mora_____________';
		-- if ((_remanente_por_aplicar >= _deuda_interes_mora) or (_deuda_interes_mora -_remanente_por_aplicar<1) )then}
		--if (_remanente_por_aplicar >= _deuda_interes_mora) then

		if (_remanente_por_aplicar > 0) then

			if _p_exonerar_mora = false then
			--_pago_interes_mora_aux = _pago_interes_mora;
				if _remanente_por_aplicar >= _deuda_interes_mora then
       
					_pago_interes_mora = _deuda_interes_mora;	        
				else	              
					_pago_interes_mora = _remanente_por_aplicar;	      
					_pago_incompleto = true;  

				end if; ---> if _remanente_por_aplicar >= _deuda_interes_mora then

			_remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_mora;

			raise notice 'pago_interes_mora ____________-%', _pago_interes_mora;
			raise notice 'remanente_por_aplicar ____________-%', _remanente_por_aplicar;
			-- _pago_interes_mora =  _pago_interes_mora  + _pago_interes_mora_aux;

			else        
				if _deuda_interes_desembolso > 0  then

					if  _remanente_por_aplicar >= _deuda_interes_desembolso then
						_mora_exonerada = _mora_exonerada + _deuda_interes_mora;
					end if;

				elsif _deuda_interes_corriente > 0 then
					if  _remanente_por_aplicar >= _deuda_interes_corriente then
						_mora_exonerada = _mora_exonerada + _deuda_interes_mora;
					end if;

				end if;  ---> if _deuda_interes_desembolso > 0  then

		  	
			end if; ---> if _p_exonerar_mora = false then
		else
			_pago_incompleto = true;

		end if;  ---> if (_remanente_por_aplicar > 0) then

		--raise notice 'remanente_por_aplicar despues de la mora___________________%',_remanente_por_aplicar;   

	end if; --> if _pago_incompleto = false and _deuda_interes_mora > 0 and p_proceso_nocturno = false then
      
      if _pago_incompleto = false and _deuda_interes_desembolso > 0 then
       -- if ((_remanente_por_aplicar >= _deuda_interes_corriente) or (_deuda_interes_corriente -_remanente_por_aplicar<1)) then
       if (_remanente_por_aplicar > 0 ) then
          if (_remanente_por_aplicar >= _deuda_interes_desembolso ) then
	        _pago_interes_desembolso = _deuda_interes_desembolso;	        
	      else
	        _pago_interes_desembolso = _remanente_por_aplicar;
	        _pago_incompleto = true;
	      end if;
	      _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_desembolso;  
	      else
	        _pago_incompleto = true;
	    end if;
	    --raise notice 'remanente_por_aplicar despues de interes desembolso___________________%',_remanente_por_aplicar;   
      end if;
      if _pago_incompleto = false and _deuda_interes_corriente > 0 then
       -- if ((_remanente_por_aplicar >= _deuda_interes_corriente) or (_deuda_interes_corriente -_remanente_por_aplicar<1)) then
       if (_remanente_por_aplicar > 0) then
       		 if (_remanente_por_aplicar >= _deuda_interes_corriente) then
	        	_pago_interes_corriente = _deuda_interes_corriente;
	         else
	            _pago_interes_corriente = _remanente_por_aplicar;
	            _pago_incompleto = true;
	         end if;	
	        _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_corriente;
	        --Inicio Contabilidad
	        if p_modalidad = 'B' then
	           _con_monto_comision_intermediario = _con_monto_comision_intermediario + _plan_pago_cuota.interes_intermediario;
	        end if;
	        --Fin Contabilidad
	      else
	        _pago_incompleto = true;
	    end if;
	    --raise notice 'remanente_por_aplicar despues de interes___________________%',_remanente_por_aplicar;   
      end if;

      if _pago_incompleto = false and _deuda_capital > 0 then
       -- if ((_remanente_por_aplicar >= _deuda_capital) or (_deuda_capital -_remanente_por_aplicar<1)) then
        if (_remanente_por_aplicar > 0)  then
        	if (_remanente_por_aplicar >= _deuda_capital)  then
          		_pago_capital = _deuda_capital;
          	else
          		_pago_capital = _remanente_por_aplicar;
          		_pago_incompleto = true;
          	end if;
          _remanente_por_aplicar = _remanente_por_aplicar - _pago_capital;

            raise notice 'pago_capital ____________%', _pago_capital;
	    raise notice 'remanente_por_aplicar ____________%', _remanente_por_aplicar;
          
        else
          _pago_incompleto = true;
        end if;
        --raise notice 'remanente_por_aplicar despues de capital___________________%',_remanente_por_aplicar;   
      end if;

      /*
      -----------------------------------------------------------------------
	Diego Bertaso
	Se resta el monto de mora exonerada del remanente por aplicar despues
        de haberse descargado cada uno de los rubros que conforman la cuota
	fecha: 20/08/2007
      -----------------------------------------------------------------------
      */

      if _p_exonerar_mora = true then

	      _mora_exonerada = _deuda_interes_mora;

		raise notice 'Entro por exonerar mora = true___________________%',_deuda_interes_mora;   

	      if (_deuda_interes_mora > 0) then

		raise notice 'Entro por mora exonerada mayor que cero___________________%',_mora_exonerada;   

		if (_remanente_por_aplicar >= _mora_exonerada)  then

			raise notice 'Entro por remanente mayor = que la mora___________________%',_mora_exonerada;   

			_remanente_por_aplicar = _remanente_por_aplicar - _mora_exonerada;
		else
			raise notice 'Entro por remanente menor que la mora___________________%',_mora_exonerada;  
			_mora_exonerada = _remanente_por_aplicar;
			_remanente_por_aplicar = _remanente_por_aplicar - _mora_exonerada;

		end if;
		
			raise notice 'resultado despues del calculo del remanente__________________%',_remanente_por_aplicar;   
	       end if;
	end if;

       ---> Fin de la Modificacion

      --if _remanente_por_aplicar < 1 then
      --  _remanente_por_aplicar = 0;
      --end if;      
      if _pago_incompleto = true then        
        if (_pago_interes_diferido + _pago_interes_mora + _pago_interes_desembolso + _pago_interes_corriente + _pago_capital) > 0 then                  
          _estatus_pago = 'P';
        else        
          _estatus_pago = _plan_pago_cuota.estatus_pago;
        end if;
      else        
        _estatus_pago = 'T';
      end if;
           

      --_remanente_por_aplicar_cuota = _remanente_por_aplicar - _prestamo.remanente_por_aplicar;
      
      
    --  _pago_cuota_total = _pago_interes_diferido + _pago_interes_mora + _pago_interes_desembolso + 
    --   _pago_interes_corriente + _pago_capital + _remanente_por_aplicar_cuota;
      
      
      
      
      --  _pago_real_interes_diferido = _pago_interes_diferido -_plan_pago_cuota.pago_interes_diferido;
      --  _pago_real_interes_mora = _pago_interes_mora -_plan_pago_cuota.pago_interes_mora;
      --  _pago_real_interes_corriente = _pago_interes_corriente -_plan_pago_cuota.pago_interes_corriente;
      --  _pago_real_interes_desembolso = _pago_interes_desembolso -_plan_pago_cuota.pago_interes_desembolso;
      --  _pago_real_capital = _pago_capital -_plan_pago_cuota.pago_capital;
      
      
        _pago_real_interes_diferido = _pago_interes_diferido ;
        _pago_real_interes_mora = _pago_interes_mora ;
        _pago_real_interes_corriente = _pago_interes_corriente ;
        _pago_real_interes_desembolso = _pago_interes_desembolso ;
        _pago_real_capital = _pago_capital ;
      
        
        _pago_cuota_total = 
          _pago_real_interes_diferido
          + _pago_real_interes_mora
          + _pago_real_interes_desembolso
          + _pago_real_interes_corriente 
          + _pago_real_capital;

      -- Actualiza la cuota
      
      update plan_pago_cuota set 
        pago_interes_diferido = pago_interes_diferido +  _pago_interes_diferido,
        pago_interes_mora = pago_interes_mora + _pago_interes_mora,
        pago_interes_desembolso = pago_interes_desembolso + _pago_interes_desembolso,
        pago_interes_corriente = pago_interes_corriente+ _pago_interes_corriente,
        pago_capital = pago_capital + _pago_capital,
        mora_exonerada = mora_exonerada + _mora_exonerada,
       -- remanente_por_aplicar = _remanente_por_aplicar_cuota,
        estatus_pago = _estatus_pago
        where id = _plan_pago_cuota.id;

      insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id, 
	    monto, interes_corriente, interes_diferido, interes_mora, interes_desembolso, capital, remanente_por_aplicar)
	    values(_plan_pago_cuota.id, _pago_prestamo_id, _pago_cuota_total,
	    _pago_real_interes_corriente, _pago_real_interes_diferido, _pago_real_interes_mora, _pago_real_interes_desembolso, 
	    _pago_real_capital, _remanente_por_aplicar_cuota);
	   
	 -- insert into pago_cuota (plan_pago_cuota_id, pago_prestamo_id, 
	  --  monto, interes_corriente, interes_diferido, interes_mora, interes_desembolso, capital)
	   -- values(_plan_pago_cuota.id, _pago_prestamo_id, _pago_cuota_total,
	    --_pago_interes_corriente, _pago_interes_diferido, _pago_interes_mora, _pago_interes_desembolso, 
	    --_pago_capital);
	   
      _pago_cuota_id = currval('pago_cuota_id_seq');

   

   --INICIO CONTABILIDAD
   
    _pago_acumulado_interes_mora = _pago_acumulado_interes_mora + _pago_real_interes_mora;
    
--    if _anio_1 = 0 or _anio_1 = extract (year from _plan_pago_cuota.fecha) then
    if extract (year from _plan_pago_cuota.fecha) = extract(year from p_fecha) then
      raise notice 'pasa anio 1-----------------------';
      _anio_1 = extract (year from _plan_pago_cuota.fecha);
      _monto_mora_anio_1 = _monto_mora_anio_1 + _pago_real_interes_mora;
      raise notice 'p_fecha - _plan_pago_cuota.fecha-----------------------%', p_fecha - _plan_pago_cuota.fecha;
      --if _plan_pago_cuota.vencida = true and (p_fecha - _plan_pago_cuota.fecha) >= 0 then
      if(p_fecha - _plan_pago_cuota.fecha) >= _parametro_general.dias_gracia_mora then
        -- _con_monto_intereses_por_cobrar_vencido = _con_monto_intereses_por_cobrar_vencido + _pago_real_interes_corriente;
	    _con_monto_credito_cuota_vencido = _con_monto_credito_cuota_vencido + _pago_real_capital;	   
	  else
	    _con_monto_capital_cuota = _con_monto_capital_cuota + _pago_real_capital;  
      end if;  

      _con_monto_intereses_por_cobrar = _con_monto_intereses_por_cobrar + _plan_pago_cuota.intereses_por_cobrar_al_30;
    
      raise notice '_con_monto_intereses_por_cobrar_al_30-------------------%',_plan_pago_cuota.intereses_por_cobrar_al_30;
    
      raise notice '_con_monto_intereses_por_cobrar-------------------%',_con_monto_intereses_por_cobrar;
    
      if _pago_real_interes_corriente > 0 then
       _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + (_pago_real_interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30);
       raise notice 'con_monto_ingreso_intereses-----------------------%',_con_monto_ingreso_intereses;
      end if;
      if _pago_real_interes_desembolso > 0 then
       _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + _pago_real_interes_desembolso;
      end if;

       --Diego Bertaso (Se inluyo pago de interes diferido)
      if _deuda_interes_diferido > 0 then
        _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + _deuda_interes_diferido;
      end if;
    
      
      
    else
      raise notice 'pasa por anio 2................';
      _anio_2 = extract (year from _plan_pago_cuota.fecha);
      _monto_mora_anio_2 = _monto_mora_anio_2 + _pago_real_interes_mora;
      ---if _plan_pago_cuota.vencida = true and (p_fecha - _plan_pago_cuota.fecha) >= 0 then
	  if(p_fecha - _plan_pago_cuota.fecha) >= _parametro_general.dias_gracia_mora then
        --_con_monto_intereses_por_cobrar_vencido_anio_2 = _con_monto_intereses_por_cobrar_vencido_anio_2 + _pago_real_interes_corriente;
	    _con_monto_credito_cuota_vencido_anio_2 = _con_monto_credito_cuota_vencido_anio_2 + _pago_real_capital;	   
      else
	    _con_monto_intereses_por_cobrar_anio_2 = _con_monto_intereses_por_cobrar_anio_2 + _plan_pago_cuota.intereses_por_cobrar_al_30;
	    if _pago_real_interes_corriente > 0 then
	     _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + (_pago_real_interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30);
	    end if;
	    if _pago_real_interes_desembolso > 0 then
	       _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + _pago_real_interes_desembolso;
	    end if;
	    _con_monto_capital_cuota_anio_2 = _con_monto_capital_cuota_anio_2 + _pago_real_capital;

	     --Diego Bertaso (Se inluyo pago de interes diferido)
	      if _deuda_interes_diferido > 0 then
	        _con_monto_ingreso_intereses = _con_monto_ingreso_intereses + _deuda_interes_diferido;
	      end if;
      end if;  
    end if;   
   --FIN CONTABILIDAD
	raise notice '******************************* SETP 1';
   
    end loop;    
    --if _pago_incompleto = false and _remanente_por_aplicar > 0 then
      --select into _pago_cuota * from pago_cuota
        --where id = _pago_cuota_id;
        
      --update pago_cuota set remanente_por_aplicar = _remanente_por_aplicar where id = _pago_cuota.id;
      --update plan_pago_cuota set remanente_por_aplicar = _remanente_por_aplicar where id = _pago_cuota.plan_pago_cuota_id;
      
    --end if;
    
    update pago_prestamo set 
	  interes_diferido = _pago_acumulado_interes_diferido,
	  interes_mora = _pago_real_interes_mora,
	  interes_desembolso = _pago_acumulado_interes_desembolso,
	  interes_corriente = _pago_acumulado_interes_corriente,
	  capital = _pago_acumulado_capital,
	  remanente_por_aplicar = _remanente_por_aplicar,
	  monto = _pago_monto_prestamo
	  where id = _pago_prestamo_id;
    
    
    raise notice '******************************* SETP 2';
    update prestamo set remanente_por_aplicar = _remanente_por_aplicar 
      where id = _prestamo_id;
      
    if p_proceso_nocturno = false then  
      perform calcular_prestamo(_prestamo_id, p_fecha, false);  
      _monto_factura = p_monto;
    else
      _monto_factura = _remanente_por_aplicar_inicial - _remanente_por_aplicar;
    end if;
 
    if  not (_remanente_por_aplicar =  _remanente_por_aplicar_inicial and p_proceso_nocturno = true ) then
    
    
    insert into factura (numero, monto, fecha, fecha_realizacion, pago_cliente_id, tipo, proceso_nocturno, prestamo_id)
      values ((select ultima_factura from parametro_general) + 1, _monto_factura, p_fecha,
      p_fecha_realizacion, _pago_cliente_id, 'P', p_proceso_nocturno, _prestamo_id) ;
 
   -- select into _factura * from factura order by id desc limit 1;
   
    _factura_id = currval('factura_id_seq');  
    
    --_factura_id = _factura.id;
    
    raise notice 'factura_id__%',_factura_id;
    
     
    update parametro_general set ultima_factura = ultima_factura + 1;
            
  end if;
    
 raise notice '******************************* SETP 3';
  
  select into _prestamo * from prestamo
      where id = _prestamo_id;
  
  raise notice 'situacion___%',_prestamo.estatus;    
 
 
  raise notice 'pago_acumulado_interes_mora______________%',_pago_acumulado_interes_mora;
 -- raise exception 'error';
	if p_modalidad = 'B' then
		_monto_factura = _monto_factura - _con_monto_comision_intermediario;
	end if;
	
	if _prestamo.intermediado = true then
	  --_con_monto_ingreso_intereses = _con_monto_ingreso_intereses - (_pago_real_interes_corriente
	end if;
	
 if p_cancelacion_prestamo = false then
	 if p_proceso_nocturno = false then
		  -- INIIO CONTABILIDAD
		  if _anio_2 = 0 then
		     raise notice 'ENTRO POR PAGO AV______________%',cast(_con_monto_intereses_por_cobrar as float);
			  perform stc_pago(
			    cast(p_modalidad as varchar), 
			    _con_codigo_cuenta_contable_banco, 
			    cast(_monto_factura as float),
			    cast(_con_monto_ingreso_intereses as float),
			    cast(_con_monto_intereses_por_cobrar as float),
			    cast(_remanente_por_aplicar as float), 
			    --cast(_prestamo.estatus as varchar), 
			    cast(_con_monto_capital_cuota as float), 
			    cast(_pago_acumulado_interes_mora as float), 
			    --cast(_con_monto_intereses_por_cobrar_vencido as float),
			    cast(_con_monto_credito_cuota_vencido as float),
			    cast(_con_remanente_por_aplicar_inicial as float), 
			    cast(_con_monto_comision_intermediario as float),
			    _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
			    p_fecha,
			    p_fecha_realizacion,
			    _prestamo.id,
			    _factura_id,
			    _anio_1);
		   else
		       _monto_anio_1 =  _con_monto_capital_cuota + _monto_mora_anio_1 + 
		        _con_monto_intereses_por_cobrar + _con_monto_credito_cuota_vencido ;
	         --     _con_monto_intereses_por_cobrar + _con_monto_credito_cuota_vencido + _con_monto_intereses_por_cobrar_vencido;
	        
	           _monto_anio_2 = _monto_factura - _monto_anio_1;
	        
	         raise notice 'ENTRO POR PAGO AA______________';
		       perform stc_pago_anio_anterior(
			    cast(p_modalidad as varchar), 
			    _con_codigo_cuenta_contable_banco, 
			    cast(_monto_anio_1 as float),
			    cast(0 as float),
			    cast(_con_monto_intereses_por_cobrar as float),
			    cast(0 as float), 		    
			    cast(_con_monto_capital_cuota as float), 
			    cast(_monto_mora_anio_1 as float), 
			   -- cast(_con_monto_intereses_por_cobrar_vencido as float),
			    cast(_con_monto_credito_cuota_vencido as float),
			    cast(0 as float), 
			    _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
			    p_fecha,
			    p_fecha_realizacion,
			    _prestamo.id,
			    _factura_id,
			    _anio_1);
			    
			    raise notice 'modalidad_______________________%',p_modalidad;
			    
			    raise notice 'monto_anio_1_______________________%', _monto_anio_1;
	            raise notice 'monto_anio_2_______________________%', _monto_anio_2;
	          
			    raise notice '_con_monto_intereses_por_cobrar_______________________%', _con_monto_intereses_por_cobrar;
			    raise notice '_con_monto_capital_cuota_______________________%', _con_monto_capital_cuota;
			    raise notice '_monto_mora_anio_1_______________________%',_monto_mora_anio_1;
			    raise notice '_con_monto_intereses_por_cobrar_vencido_______________________%',_con_monto_intereses_por_cobrar_vencido;
			    raise notice '_con_monto_credito_cuota_vencido_______________________%',_con_monto_credito_cuota_vencido;		    
			    
			     perform stc_pago(
			    cast(p_modalidad as varchar), 
			    _con_codigo_cuenta_contable_banco, 
			    cast(_monto_anio_2 as float),
			    cast(_con_monto_ingreso_intereses as float),
			    cast(_con_monto_intereses_por_cobrar_anio_2 as float),
			    cast(_remanente_por_aplicar as float), 		    
			    cast(_con_monto_capital_cuota_anio_2 as float), 
			    cast(_monto_mora_anio_2 as float), 
			    --cast(_con_monto_intereses_por_cobrar_vencido_anio_2 as float),
			    cast(_con_monto_credito_cuota_vencido_anio_2 as float),
			    cast(_con_remanente_por_aplicar_inicial as float), 
			    cast(_con_monto_comision_intermediario as float),
			    _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_id,
			    _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
			    p_fecha,
			    p_fecha_realizacion,
			    _prestamo.id,
			    _factura_id,
			    _anio_2);
		   end if;
	 else
	    if  not (_remanente_por_aplicar =  _remanente_por_aplicar_inicial and p_proceso_nocturno = true ) then
	      perform stc_pago_cierre(
		    cast(_monto_factura as float),
		    cast(_remanente_por_aplicar as float), 
		    cast(_con_monto_ingreso_intereses as float),
		    cast(_con_monto_intereses_por_cobrar as float),	    
		    --cast(_prestamo.estatus as varchar), 
		    cast(_con_monto_capital_cuota as float), 
		    cast(_pago_acumulado_interes_mora as float), 
		    --cast(_con_monto_intereses_por_cobrar_vencido as float),
		    cast(_con_monto_credito_cuota_vencido as float),
		    cast(_con_remanente_por_aplicar_inicial as float), 
		    cast(_con_monto_comision_intermediario as float),
		    _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,
		    _con_programa_origen_fondo.cuenta_contable_capital_id,
		    _con_programa_origen_fondo.cuenta_contable_capital_vencido_id,
		    p_fecha,
		    p_fecha_realizacion,
		    _prestamo.id,
		    _factura_id,
		    _anio_1);
		end if;
	 end if;
end if;

raise notice '******************************* SETP 4';
	    raise notice '____________________EJECUTO EL SP DE CONTABILIDAD';
	  
	  -- FIN CONTABILIDAD
  
  --raise exception 'error';
  return _factura_id;
 -- return 1;
  
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_cancelacion_prestamo boolean, p_hay_cheques boolean, p_exonerar_mora boolean) OWNER TO cartera;

--
-- Name: eventos_vencimiento_cuota(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION eventos_vencimiento_cuota(p_prestamo_id integer, p_fecha date) RETURNS boolean
    AS $$

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

      if _con_prestamo.intermediado = true then

         _interes = _plan_pago_cuota.interes_corriente  * (_con_prestamo.porcentaje_tasa_foncrei/100);

         _interes = _interes - _plan_pago_cuota.intereses_por_cobrar_al_30;       

      else

         _interes = _plan_pago_cuota.interes_corriente - _plan_pago_cuota.intereses_por_cobrar_al_30;

      end if;

      if _interes > 0 then

          update plan_pago_cuota set intereses_por_cobrar_al_30 = intereses_por_cobrar_al_30 + _interes where id = _plan_pago_cuota.id;

                  

 	     perform stc_eventos_vencimiento_cuota(

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

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.eventos_vencimiento_cuota(p_prestamo_id integer, p_fecha date) OWNER TO cartera;

--
-- Name: generar_plan_pago(boolean, integer, integer, integer, integer, character, double precision, double precision, date, double precision, integer, integer, double precision, integer, integer, integer, boolean, double precision, integer, integer, boolean, date, double precision); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION generar_plan_pago(p_proyectado boolean, p_formula_id integer, p_prestamo_id integer, p_plan_pago_id integer, p_numero_cuota_inicial integer, p_tipo_cuota_inicial character, p_interes_acumulado_inicial double precision, p_amortizado_acumulado_inicial double precision, p_fecha_liquidacion date, p_monto double precision, p_plazo integer, p_frecuencia_pago integer, p_tasa_valor double precision, p_meses_muertos integer, p_meses_gracia integer, p_meses_diferidos integer, p_exonerar_intereses_diferidos boolean, p_tasa_valor_gracia double precision, p_frecuencia_pago_gracia integer, p_desembolso_id integer, p_inicial boolean, p_fecha_evento date, p_monto_desembolso double precision) RETURNS boolean
    AS $$
declare  
  _prestamo prestamo%rowtype;
  _dia integer;
  _mes integer;
  _year integer;  
  _fecha_inicio date;
  _fecha_fin date;
  _plan_pago_id integer;
  _fecha_cuota date;
  _numero_cuota integer;
  _cantidad_cuotas integer;
  _periodicidad_cuota integer;
  _interes_cuota float;
  _tasa_cuota float;
  _monto_cuota_fija float;
  _monto_cuota float;
  _tasa_frances float;
  _saldo_insoluto float;
  _amortizado_acumulado float;
  _interes_acumulado float;
  _plan_pago_cuota refcursor;
  _row_plan_pago_cuota plan_pago_cuota%rowtype;
  _dias_interes_desembolso smallint = 0;
  _interes_desembolso float = 0;
  _interes_desembolso_aux float = 0;
  _parametro_general parametro_general%rowtype;
  _cantidad_dias integer = 30;
  _fecha_revision_tasa date;
  _interes_corriente_ajustado float;
  _interes_foncrei float;
  _interes_intermediario float;
  _inicial bool = false;
  _tasa_historico tasa_historico%rowtype;
  _desembolso desembolso%rowtype;
  _se_calculo_desembolso bool = false;
  --Variables Para el 365
  _fecha_365 date;
  _fecha_365_aux date;
  _amortizado float = 0;
  _dias float = 0;
  _interes float = 0;
  _monto_cuota_365 float = 0;
  _monto_cuota_aux float = 0;
  _factura_id integer;
  _fecha_cobranza_intermediario date;
  --Contabilidad
   _con_cur_desembolso_pago refcursor;
   _con_desembolso_pago desembolso_pago%rowtype;
   _con_factura_id integer;
   _con_programa_origen_fondo programa_origen_fondo%rowtype;
   _con_solicitud solicitud%rowtype;
   
   _con_entidad_financiera entidad_financiera%rowtype;
   _con_cuenta_contable_banco cuenta_contable%rowtype;    
   _con_codigo_cuenta_contable_banco integer;
     
begin
  
  select into _parametro_general * from parametro_general limit 1;

  select into _prestamo * from prestamo where id = p_prestamo_id;
  
 
  
  -- Determina el dia de facturaciÃ³n
  _dia = extract(day from p_fecha_liquidacion);
  _mes = extract(month from p_fecha_liquidacion);
  _year = extract(year from p_fecha_liquidacion);
  
  if _prestamo.dia_facturacion = 0 then
    if _dia > 16 and _dia <= 28 then
      _dia = 28;
    else
      _dia = 16;
    end if;
    -- Se actualiza el dia de facturacion en el prestamo
    update prestamo set dia_facturacion = _dia where id = p_prestamo_id;    
  else
    _dia = _prestamo.dia_facturacion;
  end if;
  
  _fecha_inicio = date (_year || '-' || _mes || '-' || _dia);
  -- calcula los dias de los interes de desembolso si el parametro asi lo indica
  if p_desembolso_id <> 0 then	  
	  if _parametro_general.exonerar_intereses_desembolso = false then
	    -- Cuando es el plan_pago inicial
	    if p_inicial then
	      _dias_interes_desembolso = _fecha_inicio - p_fecha_liquidacion;
	    else
	    -- Cuando no es el plan_pago inicial
	      _dias_interes_desembolso = _fecha_inicio - p_fecha_evento;
	    end if;
	  end if;
  end if;
  -- Determina la fecha fin
  _fecha_fin = agregar_meses(_fecha_inicio, p_meses_muertos + p_meses_gracia + p_plazo);

  -- Se agrega el registro de plan_pago en caso de que no venga de un plan_pago existente
  
  if p_plan_pago_id = 0 then
    _inicial = true;
    insert into plan_pago (
      fecha_inicio,
      fecha_fin,
      prestamo_id,
      activo,
      proyeccion,
      plazo,
      tasa,
      monto,
      meses_gracia,
      meses_muertos,
      diferir_intereses,
      exonerar_intereses_diferidos,
      tasa_gracia,
      frecuencia_pago,
      frecuencia_pago_gracia,
      dia_facturacion,
      fecha_evento,
      motivo_evento)
    values(
      _fecha_inicio,
      _fecha_fin,
      p_prestamo_id,
      not(p_proyectado),
      p_proyectado,
      p_plazo,
      p_tasa_valor,
      p_monto,
      p_meses_gracia,
      p_meses_muertos,
      false,
      p_exonerar_intereses_diferidos,
      p_tasa_valor_gracia,
      p_frecuencia_pago,
      p_frecuencia_pago_gracia,
      _dia,
      p_fecha_liquidacion,
      'D');
    _plan_pago_id = currval('plan_pago_id_seq');
    
  else
    _plan_pago_id = p_plan_pago_id;
  end if;
    
  -- Determina la fecha de la cuota inicial
  _fecha_cuota = _fecha_inicio;  

  -- Genera las cuotas del perÃ­odo muerto
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'M' then
    _numero_cuota = p_numero_cuota_inicial;
  else
    _numero_cuota = 0;
  end if;
  
  for i in 1..p_meses_muertos loop    

    _fecha_cuota = agregar_meses(_fecha_cuota, 1);
    _numero_cuota = _numero_cuota + 1;
     if _dias_interes_desembolso > 0 and i = 1 then
      _se_calculo_desembolso = true;
     end if;
    insert into plan_pago_cuota (
      plan_pago_id,    
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      tipo_cuota, 
      interes_mora,
      tasa_nominal_anual,estatus_pago)
    values(
      _plan_pago_id,
      _fecha_cuota,
      _numero_cuota,
      0,
      0,
      0,
      0,
      0,
      0,
      p_monto,
      0,
      'M',0,0,'X');
    
  end loop;
  
  --raise exception 'ocurrio un error'; 
  
  _cantidad_dias = 30 * p_frecuencia_pago;
  
  -- Genera las cuotas del perÃ­odo de gracia
  
	
  _cantidad_cuotas = p_meses_gracia / p_frecuencia_pago;
  _periodicidad_cuota = 12 / p_frecuencia_pago_gracia;
  _interes_cuota = p_monto * ( (p_tasa_valor_gracia / 100) / _periodicidad_cuota );
  _tasa_cuota = p_tasa_valor_gracia / _periodicidad_cuota;
    
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'G' then
    _numero_cuota = p_numero_cuota_inicial;
  else
    _numero_cuota = 0;
  end if;
  for i in 1.._cantidad_cuotas loop
    _fecha_365 = _fecha_cuota; 
	  if _prestamo.base_calculo_intereses = 365 then      
	      _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);                    
	      _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
	      _dias = (_fecha_365 - _fecha_365_aux);                
	      _cantidad_dias = _dias;
	  end if;
	  
     _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    _numero_cuota = _numero_cuota + 1;
    
    _interes_desembolso = 0;
    if _dias_interes_desembolso > 0 and i = 1 and _se_calculo_desembolso = false then
      if p_inicial = true then
        _interes_desembolso =  (_interes_cuota/30) * _dias_interes_desembolso;	     
      else
        _interes_desembolso = (p_monto_desembolso * ( (p_tasa_valor_gracia / 100) / _periodicidad_cuota ))/30 *  _dias_interes_desembolso;
      end if;
      _interes_desembolso_aux =  _interes_desembolso;     
      _se_calculo_desembolso = true; 
    end if;
    
    insert into plan_pago_cuota (
      plan_pago_id,
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      interes_desembolso,
      tipo_cuota, interes_mora,tasa_nominal_anual,estatus_pago, cantidad_dias)
    values(
      _plan_pago_id,
      _fecha_cuota,
      _numero_cuota,
      _interes_cuota,
      0,
      0,
      _interes_cuota,
      0,
      0,
      p_monto,
      _tasa_cuota,
      _interes_desembolso,
      'G',0,p_tasa_valor_gracia,'X',_cantidad_dias);
  end loop;
  
  -- Genera cuotas corrientes
   
  _cantidad_cuotas = p_plazo / p_frecuencia_pago;  
  _periodicidad_cuota = 12 / p_frecuencia_pago;
  _tasa_cuota = p_tasa_valor / _periodicidad_cuota;
  
  
  -- Calculo de cuotas, cuota fija cuota frances/rausseo
  if p_formula_id = 3 then
    _monto_cuota_fija = (p_monto / (p_plazo / p_frecuencia_pago));
  else
    if p_tasa_valor > 0 then
      _tasa_frances = ( p_tasa_valor / (12 / p_frecuencia_pago) ) / 100 ;
      _monto_cuota = p_monto * ( ( _tasa_frances  * ( (1 + _tasa_frances)^_cantidad_cuotas ) ) / ( ( (1 + _tasa_frances)^_cantidad_cuotas ) - 1 ) );
    else        
      _monto_cuota = p_monto / _cantidad_cuotas;
    end if;
  end if;

  _saldo_insoluto = p_monto;
  _monto_cuota_aux = _monto_cuota;
  _fecha_365 = _fecha_cuota;
  -- GeneraciÃ³n de cuotas
  for i in 1.._cantidad_cuotas loop
    
    _interes_cuota = _saldo_insoluto * _tasa_cuota / 100;
    
    if _prestamo.base_calculo_intereses = 365 and p_formula_id = 1 then
        _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);        
        _amortizado = _monto_cuota - _interes_cuota;       
        _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
        _dias = (_fecha_365 - _fecha_365_aux);        
        _interes =  (p_tasa_valor / 100) * (_dias / 365)  * _saldo_insoluto;        
        _monto_cuota_365 = _amortizado + _interes;        
        _monto_cuota_aux = _monto_cuota_365;
        _cantidad_dias = _dias;
    end if;
	if p_formula_id = 3 then
	  if _prestamo.base_calculo_intereses = 365 then
	     _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);
	     _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
	     _dias = (_fecha_365 - _fecha_365_aux);
	     _interes =  (p_tasa_valor / 100) * (_dias / 365)  * _saldo_insoluto;
	     _monto_cuota_365 = _monto_cuota_fija + _interes;
	     _monto_cuota_aux = _monto_cuota_365;
	     _cantidad_dias = _dias;
	  else
	     _monto_cuota = _monto_cuota_fija + _interes_cuota;
	     _monto_cuota_aux = _monto_cuota;
	  end if;
	end if;
    _saldo_insoluto = _saldo_insoluto - (_monto_cuota - _interes_cuota);
    
    --********
    -- Calculo de interes de desembolso OJO se debe verificar la formula de este calculo con Paul   
    --********
    _interes_desembolso = 0;
    if _dias_interes_desembolso > 0 and i = 1 and _se_calculo_desembolso = false then
      if p_inicial = true then
        _interes_desembolso =  (_interes_cuota/30) * _dias_interes_desembolso;	     
      else
        _interes_desembolso = ((p_monto_desembolso * _tasa_cuota / 100)/30) * _dias_interes_desembolso;
      end if;
      _interes_desembolso_aux =  _interes_desembolso;      
    end if;
         
    insert into plan_pago_cuota (
      plan_pago_id,
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      tipo_cuota, 
      interes_mora,
      interes_desembolso,
      tasa_nominal_anual,
      estatus_pago,
      cantidad_dias)
    values(
      _plan_pago_id,
      current_date,
      0,
      _monto_cuota_aux,
      _monto_cuota - _interes_cuota,
      0,
      _interes_cuota,
      0,
      0,
      _saldo_insoluto,
      _tasa_cuota,
      'C',
      0,
      _interes_desembolso,
      p_tasa_valor,
      'X',
      _cantidad_dias);
  end loop;
  
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'C' then	  
    _numero_cuota = p_numero_cuota_inicial;
    _interes_acumulado = p_interes_acumulado_inicial;
    _amortizado_acumulado = p_amortizado_acumulado_inicial;    
  else	  
    _numero_cuota = 0;
    _interes_acumulado = 0;
    _amortizado_acumulado = 0;
    
  end if;
  
  if p_formula_id = 2 then
    open _plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago_id and tipo_cuota='C' and numero = 0 order by id desc;
    _saldo_insoluto = p_monto;
  else
    open _plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago_id and tipo_cuota='C' and numero = 0 order by id asc;  
  end if;
  
  for i in 1.._cantidad_cuotas loop
    fetch _plan_pago_cuota INTO _row_plan_pago_cuota;
    _amortizado_acumulado = _amortizado_acumulado + _row_plan_pago_cuota.amortizado;
    --_interes_acumulado = _interes_acumulado + _row_plan_pago_cuota.interes_corriente;

    _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    _numero_cuota = _numero_cuota + 1;
    
	if p_formula_id = 2 then
	  if _row_plan_pago_cuota.amortizado < _saldo_insoluto then
        _saldo_insoluto = _saldo_insoluto - _row_plan_pago_cuota.amortizado;
      else
        _saldo_insoluto =  0;
      end if;
    else
      _saldo_insoluto = _row_plan_pago_cuota.saldo_insoluto;
    end if;
  
    update plan_pago_cuota set
      fecha = _fecha_cuota,
      numero = _numero_cuota,
      amortizado_acumulado = _amortizado_acumulado,
      --interes_corriente_acumulado = _interes_acumulado,
      saldo_insoluto = _saldo_insoluto
      --cantidad_dias = _cantidad_dias
      where id = _row_plan_pago_cuota.id;
      
     if i = _cantidad_cuotas and _amortizado_acumulado <> _prestamo.monto_liquidado then
        update plan_pago_cuota set amortizado_acumulado = _prestamo.monto_liquidado  
          where id = _row_plan_pago_cuota.id;   
     end if; 
  end loop;
  
  close _plan_pago_cuota;
  open _plan_pago_cuota for select * from plan_pago_cuota where plan_pago_id = _plan_pago_id order by id;
  
  _interes_acumulado = 0;
  --Se redondea y se trunca
  loop 
    fetch _plan_pago_cuota INTO _row_plan_pago_cuota;
    exit when not found;   
     _interes_foncrei = 0;
     _interes_intermediario = 0;
     _interes_corriente_ajustado = _row_plan_pago_cuota.interes_corriente;
     if (_row_plan_pago_cuota.amortizado + _row_plan_pago_cuota.interes_corriente) <> _row_plan_pago_cuota.valor_cuota then
      _interes_corriente_ajustado = _row_plan_pago_cuota.valor_cuota  - _row_plan_pago_cuota.amortizado;
     end if;
     _interes_acumulado = _interes_acumulado +  _interes_corriente_ajustado;
     
    if _prestamo.intermediado = true then
      _interes_foncrei = _interes_corriente_ajustado * (_prestamo.porcentaje_tasa_foncrei/100);
      _interes_intermediario = _interes_corriente_ajustado - _interes_foncrei;
    end if;  

     update plan_pago_cuota set
        interes_corriente = _interes_corriente_ajustado,
        interes_corriente_acumulado =  _interes_acumulado,
        interes_foncrei = _interes_foncrei,
        interes_intermediario = _interes_intermediario
        where id = _row_plan_pago_cuota.id;          
  end loop;
 

    if _prestamo.meses_fijos_sin_cambio_tasa > 0 and p_plan_pago_id = 0 then
      _fecha_revision_tasa = agregar_meses(_fecha_inicio, _prestamo.meses_fijos_sin_cambio_tasa);
    end if;
    
    -- Si el prestamo es intermediado actualiza la proxima fecha de cobranza
    if _prestamo.intermediado = true then
        _fecha_cobranza_intermediario = agregar_meses(_fecha_inicio, _prestamo.frecuencia_pago_intermediario + _prestamo.meses_muertos);
        --_fecha_cobranza_intermediario = agregar_dias(_fecha_cobranza_intermediario, _parametro_general.dias_gracia_mora+1);
    end if;
  --    raise notice '_fecha_revision_tasa%',_fecha_revision_tasa;
    --update prestamo set monto_solicitado = 0, fecha_inicio = _fecha_inicio, fecha_revision_tasa = _fecha_revision_tasa
      --where id = p_prestamo_id;
      --raise notice 'actualizÃ³';
 
    --update prestamo set monto_solicitado = 0, fecha_inicio = _fecha_inicio, fecha_revision_tasa = _fecha_inicio
    if p_plan_pago_id = 0 then
      update prestamo set fecha_revision_tasa = _fecha_revision_tasa, fecha_inicio = _fecha_inicio, 
        fecha_cobranza_intermediario = _fecha_cobranza_intermediario where id = p_prestamo_id;
    end if;

        
    perform calcular_prestamo(p_prestamo_id, _prestamo.fecha_liquidacion, p_proyectado);
    
    if _inicial = true and p_proyectado = false then   
      select into _tasa_historico * from tasa_historico
        where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1; 
      
      insert into prestamo_tasa_historico 
        (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
        values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
        _tasa_historico.tasa_cliente, p_prestamo_id, _tasa_historico.id, _prestamo.fecha_liquidacion);
  	raise notice '---------- ACTUALIZO LA TASA VIGENTE DEL PRESTAMO CON EL VALOR %',p_tasa_valor;      
      update prestamo set tasa_vigente = p_tasa_valor where id = p_prestamo_id;  
    end if;
    

    if p_desembolso_id <> 0 then  
    
      select into _desembolso * from desembolso where id = p_desembolso_id;
      
      insert into factura (numero, monto, fecha, fecha_realizacion, desembolso_id, tipo, prestamo_id)
        values ((select ultima_factura from parametro_general) + 1, p_monto_desembolso, p_fecha_evento,
        p_fecha_evento, _desembolso.id, 'D', p_prestamo_id);
        
      _factura_id = currval('factura_id_seq');  
 
      update parametro_general set ultima_factura = ultima_factura + 1;
      
       
       update desembolso set interes_desembolso = _interes_desembolso_aux where id = _desembolso.id;     
                       
      -- Inicio Contabilidad 
     
      select into _con_solicitud * from solicitud
            where id = _prestamo.solicitud_id;
     
      select into _con_programa_origen_fondo * from programa_origen_fondo
            where programa_id = _con_solicitud.programa_id 
            and origen_fondo_id = _con_solicitud.origen_fondo_id;
         
      open _con_cur_desembolso_pago for select * from desembolso_pago where desembolso_id = _desembolso.id;  
	  loop 
	    fetch _con_cur_desembolso_pago INTO _con_desembolso_pago;
	    exit when not found;   
	    
	    select into _con_entidad_financiera * from entidad_financiera where id = _con_desembolso_pago.entidad_financiera_id;
        select into _con_cuenta_contable_banco * from cuenta_contable where id = _con_entidad_financiera.cuenta_contable_id;
        _con_codigo_cuenta_contable_banco = _con_cuenta_contable_banco.id;
    
	    perform stc_desembolso(
	       _con_desembolso_pago.monto, 
	       _con_codigo_cuenta_contable_banco, 
	       _con_programa_origen_fondo.cuenta_contable_capital_id,
	       p_fecha_evento,
		   p_fecha_evento,
		   _prestamo.id,
		   _factura_id,
		   cast(extract(year from p_fecha_evento) as integer));
      end loop;
      
      --Fin Contabilidad     
    end if;
  
  
  --raise exception 'ocurrio un error';
  return true;
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.generar_plan_pago(p_proyectado boolean, p_formula_id integer, p_prestamo_id integer, p_plan_pago_id integer, p_numero_cuota_inicial integer, p_tipo_cuota_inicial character, p_interes_acumulado_inicial double precision, p_amortizado_acumulado_inicial double precision, p_fecha_liquidacion date, p_monto double precision, p_plazo integer, p_frecuencia_pago integer, p_tasa_valor double precision, p_meses_muertos integer, p_meses_gracia integer, p_meses_diferidos integer, p_exonerar_intereses_diferidos boolean, p_tasa_valor_gracia double precision, p_frecuencia_pago_gracia integer, p_desembolso_id integer, p_inicial boolean, p_fecha_evento date, p_monto_desembolso double precision) OWNER TO cartera;

--
-- Name: generar_plan_pago(boolean, integer, integer, integer, integer, character, double precision, double precision, date, double precision, integer, integer, double precision, integer, integer, integer, boolean, double precision, integer, integer, boolean, date, double precision, numeric); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION generar_plan_pago(p_proyectado boolean, p_formula_id integer, p_prestamo_id integer, p_plan_pago_id integer, p_numero_cuota_inicial integer, p_tipo_cuota_inicial character, p_interes_acumulado_inicial double precision, p_amortizado_acumulado_inicial double precision, p_fecha_liquidacion date, p_monto double precision, p_plazo integer, p_frecuencia_pago integer, p_tasa_valor double precision, p_meses_muertos integer, p_meses_gracia integer, p_meses_diferidos integer, p_exonerar_intereses_diferidos boolean, p_tasa_valor_gracia double precision, p_frecuencia_pago_gracia integer, p_desembolso_id integer, p_inicial boolean, p_fecha_evento date, p_monto_desembolso double precision, p_interes_diferido numeric) RETURNS boolean
    AS $$
declare  
  _prestamo prestamo%rowtype;
  _dia integer;
  _mes integer;
  _year integer;  
  _fecha_inicio date;
  _fecha_fin date;
  _plan_pago_id integer;
  _fecha_cuota date;
  _numero_cuota integer;
  _cantidad_cuotas integer;
  _periodicidad_cuota integer;
  _interes_cuota float;
  _tasa_cuota float;
  _monto_cuota_fija float;
  _monto_cuota float;
  _tasa_frances float;
  _saldo_insoluto float;
  _amortizado_acumulado float;
  _interes_acumulado float;
  _plan_pago_cuota refcursor;
  _row_plan_pago_cuota plan_pago_cuota%rowtype;
  _dias_interes_desembolso smallint = 0;
  _interes_desembolso float = 0;
  _interes_desembolso_aux float = 0;
  _parametro_general parametro_general%rowtype;
  _cantidad_dias integer = 30;
  _fecha_revision_tasa date;
  _interes_corriente_ajustado float;
  _interes_foncrei float;
  _interes_intermediario float;
  _inicial bool = false;
  _tasa_historico tasa_historico%rowtype;
  _desembolso desembolso%rowtype;
  _se_calculo_desembolso bool = false;
  --Variables Para el 365
  _fecha_365 date;
  _fecha_365_aux date;
  _amortizado float = 0;
  _dias float = 0;
  _interes float = 0;
  _monto_cuota_365 float = 0;
  _monto_cuota_aux float = 0;
  _factura_id integer;
  _fecha_cobranza_intermediario date;
  --Contabilidad
   _con_cur_desembolso_pago refcursor;
   _con_desembolso_pago desembolso_pago%rowtype;
   _con_factura_id integer;
   _con_programa_origen_fondo programa_origen_fondo%rowtype;
   _con_solicitud solicitud%rowtype;
   
   _con_entidad_financiera entidad_financiera%rowtype;
   _con_cuenta_contable_banco cuenta_contable%rowtype;    
   _con_codigo_cuenta_contable_banco integer;
     
begin
  
  select into _parametro_general * from parametro_general limit 1;

  select into _prestamo * from prestamo where id = p_prestamo_id;
  
 
  
  -- Determina el dia de facturaciÃ³n
  _dia = extract(day from p_fecha_liquidacion);
  _mes = extract(month from p_fecha_liquidacion);
  _year = extract(year from p_fecha_liquidacion);
  
  if _prestamo.dia_facturacion = 0 then
    if _dia > 16 and _dia <= 28 then
      _dia = 28;
    else
      _dia = 16;
    end if;
    -- Se actualiza el dia de facturacion en el prestamo
    update prestamo set dia_facturacion = _dia where id = p_prestamo_id;    
  else
    _dia = _prestamo.dia_facturacion;
  end if;
  
  _fecha_inicio = date (_year || '-' || _mes || '-' || _dia);
  -- calcula los dias de los interes de desembolso si el parametro asi lo indica
  if p_desembolso_id <> 0 then	  
	  if _parametro_general.exonerar_intereses_desembolso = false then
	    -- Cuando es el plan_pago inicial
	    if p_inicial then
	      _dias_interes_desembolso = _fecha_inicio - p_fecha_liquidacion;
	    else
	    -- Cuando no es el plan_pago inicial
	      _dias_interes_desembolso = _fecha_inicio - p_fecha_evento;
	    end if;
	  end if;
  end if;
  -- Determina la fecha fin
  _fecha_fin = agregar_meses(_fecha_inicio, p_meses_muertos + p_meses_gracia + p_plazo);

  -- Se agrega el registro de plan_pago en caso de que no venga de un plan_pago existente
  
  if p_plan_pago_id = 0 then
    _inicial = true;
    insert into plan_pago (
      fecha_inicio,
      fecha_fin,
      prestamo_id,
      activo,
      proyeccion,
      plazo,
      tasa,
      monto,
      meses_gracia,
      meses_muertos,
      diferir_intereses,
      exonerar_intereses_diferidos,
      tasa_gracia,
      frecuencia_pago,
      frecuencia_pago_gracia,
      dia_facturacion,
      fecha_evento,
      motivo_evento)
    values(
      _fecha_inicio,
      _fecha_fin,
      p_prestamo_id,
      not(p_proyectado),
      p_proyectado,
      p_plazo,
      p_tasa_valor,
      p_monto,
      p_meses_gracia,
      p_meses_muertos,
      false,
      p_exonerar_intereses_diferidos,
      p_tasa_valor_gracia,
      p_frecuencia_pago,
      p_frecuencia_pago_gracia,
      _dia,
      p_fecha_liquidacion,
      'D');
    _plan_pago_id = currval('plan_pago_id_seq');
    
  else
    _plan_pago_id = p_plan_pago_id;
  end if;
    
  -- Determina la fecha de la cuota inicial
  _fecha_cuota = _fecha_inicio;  

  -- Genera las cuotas del perÃ­odo muerto
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'M' then
    _numero_cuota = p_numero_cuota_inicial;
  else
    _numero_cuota = 0;
  end if;
  
  for i in 1..p_meses_muertos loop    

    _fecha_cuota = agregar_meses(_fecha_cuota, 1);
    _numero_cuota = _numero_cuota + 1;
     if _dias_interes_desembolso > 0 and i = 1 then
      _se_calculo_desembolso = true;
     end if;
    insert into plan_pago_cuota (
      plan_pago_id,    
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      tipo_cuota, 
      interes_mora,
      tasa_nominal_anual,estatus_pago)
    values(
      _plan_pago_id,
      _fecha_cuota,
      _numero_cuota,
      0,
      0,
      0,
      0,
      0,
      0,
      p_monto,
      0,
      'M',0,0,'X');
    
  end loop;
  
  --raise exception 'ocurrio un error'; 
  
  _cantidad_dias = 30 * p_frecuencia_pago;
  
  -- Genera las cuotas del perÃ­odo de gracia
  
	
  _cantidad_cuotas = p_meses_gracia / p_frecuencia_pago;
  _periodicidad_cuota = 12 / p_frecuencia_pago_gracia;
  _interes_cuota = p_monto * ( (p_tasa_valor_gracia / 100) / _periodicidad_cuota );
  _tasa_cuota = p_tasa_valor_gracia / _periodicidad_cuota;
    
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'G' then
    _numero_cuota = p_numero_cuota_inicial;
  else
    _numero_cuota = 0;
  end if;
  for i in 1.._cantidad_cuotas loop
    _fecha_365 = _fecha_cuota; 
	  if _prestamo.base_calculo_intereses = 365 then      
	      _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);                    
	      _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
	      _dias = (_fecha_365 - _fecha_365_aux);                
	      _cantidad_dias = _dias;
	  end if;
	  
     _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    _numero_cuota = _numero_cuota + 1;
    
    _interes_desembolso = 0;
    if _dias_interes_desembolso > 0 and i = 1 and _se_calculo_desembolso = false then
      if p_inicial = true then
        _interes_desembolso =  (_interes_cuota/30) * _dias_interes_desembolso;	     
      else
        _interes_desembolso = (p_monto_desembolso * ( (p_tasa_valor_gracia / 100) / _periodicidad_cuota ))/30 *  _dias_interes_desembolso;
      end if;
      _interes_desembolso_aux =  _interes_desembolso;     
      _se_calculo_desembolso = true; 
    end if;
    
    insert into plan_pago_cuota (
      plan_pago_id,
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      interes_desembolso,
      tipo_cuota, interes_mora,tasa_nominal_anual,estatus_pago, cantidad_dias)
    values(
      _plan_pago_id,
      _fecha_cuota,
      _numero_cuota,
      _interes_cuota,
      0,
      0,
      _interes_cuota,
      0,
      0,
      p_monto,
      _tasa_cuota,
      _interes_desembolso,
      'G',0,p_tasa_valor_gracia,'X',_cantidad_dias);
  end loop;
  
  -- Genera cuotas corrientes
   
  _cantidad_cuotas = p_plazo / p_frecuencia_pago;  
  _periodicidad_cuota = 12 / p_frecuencia_pago;
  _tasa_cuota = p_tasa_valor / _periodicidad_cuota;
  
  
  -- Calculo de cuotas, cuota fija cuota frances/rausseo
  if p_formula_id = 3 then
    _monto_cuota_fija = (p_monto / (p_plazo / p_frecuencia_pago));
  else
    if p_tasa_valor > 0 then
      _tasa_frances = ( p_tasa_valor / (12 / p_frecuencia_pago) ) / 100 ;
      _monto_cuota = p_monto * ( ( _tasa_frances  * ( (1 + _tasa_frances)^_cantidad_cuotas ) ) / ( ( (1 + _tasa_frances)^_cantidad_cuotas ) - 1 ) );
    else        
      _monto_cuota = p_monto / _cantidad_cuotas;
    end if;
  end if;

  _saldo_insoluto = p_monto;
  _monto_cuota_aux = _monto_cuota;
  _fecha_365 = _fecha_cuota;
  -- GeneraciÃ³n de cuotas
  for i in 1.._cantidad_cuotas loop
    
    _interes_cuota = _saldo_insoluto * _tasa_cuota / 100;
    
    if _prestamo.base_calculo_intereses = 365 and p_formula_id = 1 then
        _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);        
        _amortizado = _monto_cuota - _interes_cuota;       
        _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
        _dias = (_fecha_365 - _fecha_365_aux);        
        _interes =  (p_tasa_valor / 100) * (_dias / 365)  * _saldo_insoluto;        
        _monto_cuota_365 = _amortizado + _interes;        
        _monto_cuota_aux = _monto_cuota_365;
        _cantidad_dias = _dias;
    end if;
	if p_formula_id = 3 then
	  if _prestamo.base_calculo_intereses = 365 then
	     _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);
	     _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);
	     _dias = (_fecha_365 - _fecha_365_aux);
	     _interes =  (p_tasa_valor / 100) * (_dias / 365)  * _saldo_insoluto;
	     _monto_cuota_365 = _monto_cuota_fija + _interes;
	     _monto_cuota_aux = _monto_cuota_365;
	     _cantidad_dias = _dias;
	  else
	     _monto_cuota = _monto_cuota_fija + _interes_cuota;
	     _monto_cuota_aux = _monto_cuota;
	  end if;
	end if;
    _saldo_insoluto = _saldo_insoluto - (_monto_cuota - _interes_cuota);
    
    --********
    -- Calculo de interes de desembolso OJO se debe verificar la formula de este calculo con Paul   
    --********
    _interes_desembolso = 0;
    if _dias_interes_desembolso > 0 and i = 1 and _se_calculo_desembolso = false then
      if p_inicial = true then
        _interes_desembolso =  (_interes_cuota/30) * _dias_interes_desembolso;	     
      else
        _interes_desembolso = ((p_monto_desembolso * _tasa_cuota / 100)/30) * _dias_interes_desembolso;
      end if;
      _interes_desembolso_aux =  _interes_desembolso;      
    end if;
         
    insert into plan_pago_cuota (
      plan_pago_id,
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      saldo_insoluto,
      tasa_periodo,
      tipo_cuota, 
      interes_mora,
      interes_desembolso,
      tasa_nominal_anual,
      estatus_pago,
      cantidad_dias)
    values(
      _plan_pago_id,
      current_date,
      0,
      _monto_cuota_aux,
      _monto_cuota - _interes_cuota,
      0,
      _interes_cuota,
      0,
      p_interes_diferido,
      _saldo_insoluto,
      _tasa_cuota,
      'C',
      0,
      _interes_desembolso,
      p_tasa_valor,
      'X',
      _cantidad_dias);
  end loop;
  
  if p_numero_cuota_inicial > 0 and p_tipo_cuota_inicial = 'C' then	  
    _numero_cuota = p_numero_cuota_inicial;
    _interes_acumulado = p_interes_acumulado_inicial;
    _amortizado_acumulado = p_amortizado_acumulado_inicial;    
  else	  
    _numero_cuota = 0;
    _interes_acumulado = 0;
    _amortizado_acumulado = 0;
    
  end if;
  
  if p_formula_id = 2 then
    open _plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago_id and tipo_cuota='C' and numero = 0 order by id desc;
    _saldo_insoluto = p_monto;
  else
    open _plan_pago_cuota for select * from plan_pago_cuota 
      where plan_pago_id = _plan_pago_id and tipo_cuota='C' and numero = 0 order by id asc;  
  end if;
  
  for i in 1.._cantidad_cuotas loop
    fetch _plan_pago_cuota INTO _row_plan_pago_cuota;
    _amortizado_acumulado = _amortizado_acumulado + _row_plan_pago_cuota.amortizado;
    --_interes_acumulado = _interes_acumulado + _row_plan_pago_cuota.interes_corriente;

    _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    _numero_cuota = _numero_cuota + 1;
    
	if p_formula_id = 2 then
	  if _row_plan_pago_cuota.amortizado < _saldo_insoluto then
        _saldo_insoluto = _saldo_insoluto - _row_plan_pago_cuota.amortizado;
      else
        _saldo_insoluto =  0;
      end if;
    else
      _saldo_insoluto = _row_plan_pago_cuota.saldo_insoluto;
    end if;
  
    update plan_pago_cuota set
      fecha = _fecha_cuota,
      numero = _numero_cuota,
      amortizado_acumulado = _amortizado_acumulado,
      --interes_corriente_acumulado = _interes_acumulado,
      saldo_insoluto = _saldo_insoluto
      --cantidad_dias = _cantidad_dias
      where id = _row_plan_pago_cuota.id;
      
     if i = _cantidad_cuotas and _amortizado_acumulado <> _prestamo.monto_liquidado then
        update plan_pago_cuota set amortizado_acumulado = _prestamo.monto_liquidado  
          where id = _row_plan_pago_cuota.id;   
     end if; 
  end loop;
  
  close _plan_pago_cuota;
  open _plan_pago_cuota for select * from plan_pago_cuota where plan_pago_id = _plan_pago_id order by id;
  
  _interes_acumulado = 0;
  --Se redondea y se trunca
  loop 
    fetch _plan_pago_cuota INTO _row_plan_pago_cuota;
    exit when not found;   
     _interes_foncrei = 0;
     _interes_intermediario = 0;
     _interes_corriente_ajustado = _row_plan_pago_cuota.interes_corriente;
     if (_row_plan_pago_cuota.amortizado + _row_plan_pago_cuota.interes_corriente) <> _row_plan_pago_cuota.valor_cuota then
      _interes_corriente_ajustado = _row_plan_pago_cuota.valor_cuota  - _row_plan_pago_cuota.amortizado;
     end if;
     _interes_acumulado = _interes_acumulado +  _interes_corriente_ajustado;
     
    if _prestamo.intermediado = true then
      _interes_foncrei = _interes_corriente_ajustado * (_prestamo.porcentaje_tasa_foncrei/100);
      _interes_intermediario = _interes_corriente_ajustado - _interes_foncrei;
    end if;  

     update plan_pago_cuota set
        interes_corriente = _interes_corriente_ajustado,
        interes_corriente_acumulado =  _interes_acumulado,
        interes_foncrei = _interes_foncrei,
        interes_intermediario = _interes_intermediario
        where id = _row_plan_pago_cuota.id;          
  end loop;
 

    if _prestamo.meses_fijos_sin_cambio_tasa > 0 and p_plan_pago_id = 0 then
      _fecha_revision_tasa = agregar_meses(_fecha_inicio, _prestamo.meses_fijos_sin_cambio_tasa);
    end if;
    
    -- Si el prestamo es intermediado actualiza la proxima fecha de cobranza
    if _prestamo.intermediado = true then
        _fecha_cobranza_intermediario = agregar_meses(_fecha_inicio, _prestamo.frecuencia_pago_intermediario + _prestamo.meses_muertos);
        --_fecha_cobranza_intermediario = agregar_dias(_fecha_cobranza_intermediario, _parametro_general.dias_gracia_mora+1);
    end if;
  --    raise notice '_fecha_revision_tasa%',_fecha_revision_tasa;
    --update prestamo set monto_solicitado = 0, fecha_inicio = _fecha_inicio, fecha_revision_tasa = _fecha_revision_tasa
      --where id = p_prestamo_id;
      --raise notice 'actualizÃ³';
 
    --update prestamo set monto_solicitado = 0, fecha_inicio = _fecha_inicio, fecha_revision_tasa = _fecha_inicio
    if p_plan_pago_id = 0 then
      update prestamo set fecha_revision_tasa = _fecha_revision_tasa, fecha_inicio = _fecha_inicio, 
        fecha_cobranza_intermediario = _fecha_cobranza_intermediario where id = p_prestamo_id;
    end if;

        
    perform calcular_prestamo(p_prestamo_id, _prestamo.fecha_liquidacion, p_proyectado);
    
    if _inicial = true and p_proyectado = false then   
      select into _tasa_historico * from tasa_historico
        where tasa_valor_id in (select id from tasa_valor where tasa_id = _prestamo.tasa_id) order by id desc limit 1; 
      
      insert into prestamo_tasa_historico 
        (tasa_foncrei, tasa_intermediario, tasa_cliente, prestamo_id, tasa_historico_id, fecha) 
        values(_tasa_historico.tasa_foncrei, _tasa_historico.tasa_intermediario,
        _tasa_historico.tasa_cliente, p_prestamo_id, _tasa_historico.id, _prestamo.fecha_liquidacion);
  	raise notice '---------- ACTUALIZO LA TASA VIGENTE DEL PRESTAMO CON EL VALOR %',p_tasa_valor;      
      update prestamo set tasa_vigente = p_tasa_valor where id = p_prestamo_id;  
    end if;
    

    if p_desembolso_id <> 0 then  
    
      select into _desembolso * from desembolso where id = p_desembolso_id;
      
      insert into factura (numero, monto, fecha, fecha_realizacion, desembolso_id, tipo, prestamo_id)
        values ((select ultima_factura from parametro_general) + 1, p_monto_desembolso, p_fecha_evento,
        p_fecha_evento, _desembolso.id, 'D', p_prestamo_id);
        
      _factura_id = currval('factura_id_seq');  
 
      update parametro_general set ultima_factura = ultima_factura + 1;
      
       
       update desembolso set interes_desembolso = _interes_desembolso_aux where id = _desembolso.id;     
                       
      -- Inicio Contabilidad 
     
      select into _con_solicitud * from solicitud
            where id = _prestamo.solicitud_id;
     
      select into _con_programa_origen_fondo * from programa_origen_fondo
            where programa_id = _con_solicitud.programa_id 
            and origen_fondo_id = _con_solicitud.origen_fondo_id;
         
      open _con_cur_desembolso_pago for select * from desembolso_pago where desembolso_id = _desembolso.id;  
	  loop 
	    fetch _con_cur_desembolso_pago INTO _con_desembolso_pago;
	    exit when not found;   
	    
	    select into _con_entidad_financiera * from entidad_financiera where id = _con_desembolso_pago.entidad_financiera_id;
        select into _con_cuenta_contable_banco * from cuenta_contable where id = _con_entidad_financiera.cuenta_contable_id;
        _con_codigo_cuenta_contable_banco = _con_cuenta_contable_banco.id;
    
	    perform stc_desembolso(
	       _con_desembolso_pago.monto, 
	       _con_codigo_cuenta_contable_banco, 
	       _con_programa_origen_fondo.cuenta_contable_capital_id,
	       p_fecha_evento,
		   p_fecha_evento,
		   _prestamo.id,
		   _factura_id,
		   cast(extract(year from p_fecha_evento) as integer));
      end loop;
      
      --Fin Contabilidad     
    end if;
  
  
  --raise exception 'ocurrio un error';
  return true;
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.generar_plan_pago(p_proyectado boolean, p_formula_id integer, p_prestamo_id integer, p_plan_pago_id integer, p_numero_cuota_inicial integer, p_tipo_cuota_inicial character, p_interes_acumulado_inicial double precision, p_amortizado_acumulado_inicial double precision, p_fecha_liquidacion date, p_monto double precision, p_plazo integer, p_frecuencia_pago integer, p_tasa_valor double precision, p_meses_muertos integer, p_meses_gracia integer, p_meses_diferidos integer, p_exonerar_intereses_diferidos boolean, p_tasa_valor_gracia double precision, p_frecuencia_pago_gracia integer, p_desembolso_id integer, p_inicial boolean, p_fecha_evento date, p_monto_desembolso double precision, p_interes_diferido numeric) OWNER TO cartera;

--
-- Name: generar_plan_pago_evento(boolean, integer, date, boolean, double precision, boolean, double precision, boolean, double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION generar_plan_pago_evento(p_proyectado boolean, p_prestamo_id integer, p_fecha_evento date, p_tiene_desembolso boolean, p_monto_desembolso double precision, p_tiene_tasa boolean, p_valor_tasa double precision, p_tiene_abono boolean, p_monto_abono double precision, p_desembolso_id integer, p_extension_meses_muertos integer) RETURNS boolean
    AS $$







 declare







   _prestamo prestamo%rowtype;







   _plan_pago plan_pago%rowtype;







   _plan_pago_cuota plan_pago_cuota%rowtype;







   _cur_plan_pago_cuota refcursor;







   _fecha_focal date;







   _plan_pago_id integer;







   _plan_pago_cuota_id integer;







   _monto_insoluto float;







   _meses_muertos integer = 0;







   _meses_gracia integer = 0;







   _plazo integer = 0;







   _motivo_evento char;







   _valor_tasa float = 0;







   _factura_id integer;







   







   _con_programa_origen_fondo programa_origen_fondo%rowtype;







   _con_solicitud solicitud%rowtype;







   







 begin







 







   if p_proyectado = true  then







   	delete from plan_pago_cuota where plan_pago_id in (select id from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id);







   	delete from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id; 







   end if;







   







   raise notice 'PROYECTADO________________________________________________________________%',p_proyectado;  







   raise notice 'MONTO_ABONO_______________________________________________________________%',p_monto_abono;  







     







   raise notice 'PASO 1________________________';







   







   if p_tiene_tasa = true then







     _motivo_evento = 'T';







     _valor_tasa = p_valor_tasa;   







   elsif p_tiene_desembolso = true then







     _motivo_evento = 'D';







   elsif p_tiene_abono = true then







     _motivo_evento = 'A';  







   else







     _motivo_evento = 'M';  







   end if;







 







   raise notice 'PASO 2________________________';







     







   select into _prestamo * from prestamo







     where id = p_prestamo_id;







 







 -- Inicio Contabilidad 







      







    select into _con_solicitud * from solicitud







     where id = _prestamo.solicitud_id;







      







    select into _con_programa_origen_fondo * from programa_origen_fondo







     where programa_id = _con_solicitud.programa_id 







     and origen_fondo_id = _con_solicitud.origen_fondo_id;                        







    -- Fin Contabilidad







 







   raise notice 'PASO 3________________________';







      







   select into _plan_pago * from plan_pago 







     where prestamo_id = p_prestamo_id and activo = true and proyeccion = false;







   







   -- Busca la fecha de la cuota hasta donde se va clonar o mejor dicho hasta donde se mantiene intacta







   select into _plan_pago_cuota * from plan_pago_cuota







     where fecha >= p_fecha_evento and plan_pago_id = _plan_pago.id order by fecha asc limit 1;







   







   _fecha_focal = _plan_pago_cuota.fecha;







   







   raise notice 'PASO 4________________________';







     







   raise notice 'prestamo_id________________________%',p_prestamo_id;   







   raise notice 'plan_pago_id________________________%',_plan_pago.id;   







   raise notice 'fecha_inicio________________________%',_plan_pago.fecha_inicio;     







  -- raise notice 'prestamo_id_____%',p_prestamo_id;







  -- raise notice 'fecha_focal_____%',_fecha_focal;







  -- raise notice 'fecha_evento_____%',p_fecha_evento;







   







   







   -- Recupera las cuotas a clonar  







   open _cur_plan_pago_cuota for select * from plan_pago_cuota 







     where plan_pago_id = _plan_pago.id and fecha <= _fecha_focal order by fecha asc;







 







   if _valor_tasa = 0 then







     _valor_tasa = _plan_pago.tasa;







   end if;







   -- Clona el plan_pago







   insert into plan_pago (







     fecha_inicio,







     fecha_fin,







     prestamo_id,







     activo,







     proyeccion,







     plazo,







     tasa,







     monto,







     meses_gracia,







     meses_muertos,







     diferir_intereses,







     exonerar_intereses_diferidos,







     tasa_gracia,







     frecuencia_pago,







     frecuencia_pago_gracia,







     dia_facturacion,







     fecha_evento,







     motivo_evento)







   values(







     _plan_pago.fecha_inicio,







     _plan_pago.fecha_fin,







     _plan_pago.prestamo_id,







     not(p_proyectado),







     p_proyectado,







     _plan_pago.plazo,







     _valor_tasa,







     _plan_pago.monto,







     _plan_pago.meses_gracia,







     _plan_pago.meses_muertos + p_extension_meses_muertos,







     _plan_pago.diferir_intereses,







     _plan_pago.exonerar_intereses_diferidos,







     _plan_pago.tasa_gracia,







     _plan_pago.frecuencia_pago,







     _plan_pago.frecuencia_pago_gracia,







     _plan_pago.dia_facturacion,







     p_fecha_evento,







     _motivo_evento);







   _plan_pago_id = currval('plan_pago_id_seq');







   







   







   _meses_muertos = _plan_pago.meses_muertos + p_extension_meses_muertos;







   _meses_gracia = _plan_pago.meses_gracia;







   _plazo = _plan_pago.plazo;







   







   -- Actualiza el plan_pago anterior







 	if p_proyectado = false then







        update plan_pago set activo = false where id = _plan_pago.id;







   	end if;







   -- Clona las cuotas del plan_pago







   loop







     fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;







 	exit when not found;







 	







 	if _plan_pago_cuota.tipo_cuota = 'M' then







 	  _meses_muertos = _meses_muertos - 1;







 	elsif _plan_pago_cuota.tipo_cuota = 'G' then







 	  _meses_gracia = _meses_gracia - _prestamo.frecuencia_pago;	







 	else







 	  _plazo = _plazo - _prestamo.frecuencia_pago;	







 	end if;







 	







     insert into plan_pago_cuota (







       plan_pago_id,







       fecha,







       numero,







       valor_cuota,







       amortizado,







       amortizado_acumulado,







       interes_corriente,







       interes_corriente_acumulado,







       interes_diferido,







       interes_mora,







       saldo_insoluto,







       tasa_periodo,







       tipo_cuota,







       vencida,







       estatus_pago,







       pago_interes_mora,







       pago_interes_corriente,







       pago_interes_diferido,







       pago_capital,







       remanente_por_aplicar,







       causado_no_devengado,







       desembolso,







       cambio_tasa,







       abono_extraordinario,







       monto_desembolso,







       monto_abono,







       dias_mora,







       tasa_nominal_anual,







       interes_desembolso,







       pago_interes_desembolso,







       cantidad_dias,







       interes_foncrei,







       interes_intermediario)







     values(







       _plan_pago_id,







       _plan_pago_cuota.fecha,







       _plan_pago_cuota.numero,







       _plan_pago_cuota.valor_cuota,







       _plan_pago_cuota.amortizado,







       _plan_pago_cuota.amortizado_acumulado,







       _plan_pago_cuota.interes_corriente,







       _plan_pago_cuota.interes_corriente_acumulado,







       _plan_pago_cuota.interes_diferido,







       _plan_pago_cuota.interes_mora,







       _plan_pago_cuota.saldo_insoluto,







       _plan_pago_cuota.tasa_periodo,







       _plan_pago_cuota.tipo_cuota,







       _plan_pago_cuota.vencida,







       _plan_pago_cuota.estatus_pago,







       _plan_pago_cuota.pago_interes_mora,







       _plan_pago_cuota.pago_interes_corriente,







       _plan_pago_cuota.pago_interes_diferido,







       _plan_pago_cuota.pago_capital,







       _plan_pago_cuota.remanente_por_aplicar,







       _plan_pago_cuota.causado_no_devengado,







       _plan_pago_cuota.desembolso,







       _plan_pago_cuota.cambio_tasa,      







       _plan_pago_cuota.abono_extraordinario,







       _plan_pago_cuota.monto_desembolso,







       _plan_pago_cuota.monto_abono,







       _plan_pago_cuota.dias_mora,







       _plan_pago_cuota.tasa_nominal_anual,







       _plan_pago_cuota.interes_desembolso,







       _plan_pago_cuota.pago_interes_desembolso,







       _plan_pago_cuota.cantidad_dias,







       _plan_pago_cuota.interes_foncrei,







       _plan_pago_cuota.interes_intermediario);







   end loop;







 







    _plan_pago_cuota_id = currval('plan_pago_cuota_id_seq');







    







    if p_tiene_desembolso then







 	   update plan_pago_cuota set monto_desembolso = monto_desembolso + p_monto_desembolso, desembolso = true







 	     where id = _plan_pago_cuota_id;	     







    end if;







    







    if p_tiene_abono then







 	   update plan_pago_cuota set monto_abono = monto_abono + p_monto_abono, abono_extraordinario = true







 	     where id = _plan_pago_cuota_id;







    end if;







   







    if p_tiene_tasa then







 	   update plan_pago_cuota set cambio_tasa = true







 	     where id = _plan_pago_cuota_id;







    end if;  







    







    select into _plan_pago_cuota * from plan_pago_cuota 







     where id = _plan_pago_cuota_id;







     







   --if p_tiene_tasa then







   --  _monto_insoluto = _plan_pago_cuota.saldo_insoluto;







   --end if;







     







   --if p_tiene_desembolso then







   --  _monto_insoluto = _plan_pago_cuota.saldo_insoluto + p_monto_desembolso;







   --end if;







   







   --if p_tiene_abono then







   --  _monto_insoluto = _plan_pago_cuota.saldo_insoluto - p_monto_abono;







   --end if;







   







   _monto_insoluto = (_plan_pago_cuota.saldo_insoluto + _plan_pago_cuota.monto_desembolso)- _plan_pago_cuota.monto_abono;







   







  -- raise notice 'numero_cuota%',_plan_pago_cuota.numero;







   --raise notice 'saldo_insoluto_cuota%',_plan_pago_cuota.saldo_insoluto;







   --raise notice 'monto_abono%',p_monto_abono;







   --raise notice '**************************************************monto_insoluto%',_monto_insoluto;







    







  







  raise notice 'MESES_MUERTOS__________________________%', _meses_muertos;







  







   perform generar_plan_pago(







     p_proyectado,







     _prestamo.formula_id,







     p_prestamo_id,







     _plan_pago_id,







     _plan_pago_cuota.numero,







     _plan_pago_cuota.tipo_cuota,







     _plan_pago_cuota.interes_corriente_acumulado,







     _plan_pago_cuota.amortizado_acumulado,







     _fecha_focal,







     _monto_insoluto,







     _plazo,







     _plan_pago.frecuencia_pago,







     _valor_tasa,







     _meses_muertos,







     _meses_gracia,







     0,







     _plan_pago.exonerar_intereses_diferidos,







     _valor_tasa,







     _plan_pago.frecuencia_pago,







     p_desembolso_id,







     false,







     p_fecha_evento,







     p_monto_desembolso,



     _plan_pago_cuota.interes_diferido







   );







   -- Actualiza la tasa del prestamo si el evento es un cambio de tasa







   if p_tiene_tasa = true and p_proyectado = false then







     update prestamo set tasa_vigente = p_valor_tasa where id = p_prestamo_id;







   end if;







   







   if p_tiene_abono = true and p_proyectado = false then







       insert into factura (numero, monto, fecha, fecha_realizacion, desembolso_id, tipo, prestamo_id)







         values ((select ultima_factura from parametro_general) + 1, p_monto_abono, p_fecha_evento,







         p_fecha_evento, null, 'E', p_prestamo_id);







       _factura_id = currval('factura_id_seq');







       







       update parametro_general set ultima_factura = ultima_factura + 1;







   







      perform stc_abono_extraordinario(







      p_monto_abono, 







      _con_programa_origen_fondo.cuenta_contable_capital_id,







      p_fecha_evento, 







      p_fecha_evento, 







      p_prestamo_id, 







      _factura_id, 







      cast( extract(year from p_fecha_evento) as integer));  







      







     -- raise notice 'si paso por el abono';







   end if;







   







   --raise exception 'error';







   







   return true;







  







 end;







 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.generar_plan_pago_evento(p_proyectado boolean, p_prestamo_id integer, p_fecha_evento date, p_tiene_desembolso boolean, p_monto_desembolso double precision, p_tiene_tasa boolean, p_valor_tasa double precision, p_tiene_abono boolean, p_monto_abono double precision, p_desembolso_id integer, p_extension_meses_muertos integer) OWNER TO cartera;

--
-- Name: generar_plan_pago_evento_bf(boolean, integer, date, boolean, double precision, boolean, double precision, boolean, double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION generar_plan_pago_evento_bf(p_proyectado boolean, p_prestamo_id integer, p_fecha_evento date, p_tiene_desembolso boolean, p_monto_desembolso double precision, p_tiene_tasa boolean, p_valor_tasa double precision, p_tiene_abono boolean, p_monto_abono double precision, p_desembolso_id integer, p_extension_meses_muertos integer) RETURNS boolean
    AS $$
declare
  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;
  _fecha_focal date;
  _plan_pago_id integer;
  _plan_pago_cuota_id integer;
  _monto_insoluto float;
  _meses_muertos integer = 0;
  _meses_gracia integer = 0;
  _plazo integer = 0;
  _motivo_evento char;
  _valor_tasa float = 0;
  _factura_id integer;
  
  _con_programa_origen_fondo programa_origen_fondo%rowtype;
  _con_solicitud solicitud%rowtype;
  
begin

  if p_proyectado = true  then
  	delete from plan_pago_cuota where plan_pago_id in (select id from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id);
  	delete from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id; 
  end if;
  
  raise notice 'PROYECTADO________________________________________________________________%',p_proyectado;  
  raise notice 'MONTO_ABONO_______________________________________________________________%',p_monto_abono;  
 
  raise notice 'PASO 1________________________';
    
  select into _prestamo * from prestamo
    where id = p_prestamo_id;

   
  raise notice 'PASO 2________________________';
  
  if p_tiene_tasa = true then
    _motivo_evento = 'T';
    _valor_tasa = p_valor_tasa;   
  elsif p_tiene_desembolso = true then
    _motivo_evento = 'D';
  elsif p_tiene_abono = true then
    _motivo_evento = 'A';
  elsif p_tiene_abono = true and _prestamo.remanente_por_aplicar = 0 then
    _motivo_evento = 'B';
  else
    _motivo_evento = 'M';  
  end if;

-- Inicio Contabilidad 
     
   select into _con_solicitud * from solicitud
    where id = _prestamo.solicitud_id;
     
   select into _con_programa_origen_fondo * from programa_origen_fondo
    where programa_id = _con_solicitud.programa_id 
    and origen_fondo_id = _con_solicitud.origen_fondo_id;                        
   -- Fin Contabilidad

  raise notice 'PASO 3________________________';
     
  select into _plan_pago * from plan_pago 
    where prestamo_id = p_prestamo_id and activo = true and proyeccion = false;
  
  -- Busca la fecha de la cuota hasta donde se va clonar o mejor dicho hasta donde se mantiene intacta
  select into _plan_pago_cuota * from plan_pago_cuota
    where fecha >= p_fecha_evento and plan_pago_id = _plan_pago.id order by fecha asc limit 1;
  
  _fecha_focal = _plan_pago_cuota.fecha;
  
  raise notice 'PASO 4________________________';
    
  raise notice 'prestamo_id________________________%',p_prestamo_id;   
  raise notice 'plan_pago_id________________________%',_plan_pago.id;   
  raise notice 'fecha_inicio________________________%',_plan_pago.fecha_inicio;     
 -- raise notice 'prestamo_id_____%',p_prestamo_id;
 -- raise notice 'fecha_focal_____%',_fecha_focal;
 -- raise notice 'fecha_evento_____%',p_fecha_evento;
  
  
  -- Recupera las cuotas a clonar  
  open _cur_plan_pago_cuota for select * from plan_pago_cuota 
    where plan_pago_id = _plan_pago.id and fecha <= _fecha_focal order by fecha asc;

  if _valor_tasa = 0 then
    _valor_tasa = _plan_pago.tasa;
  end if;
  -- Clona el plan_pago
  insert into plan_pago (
    fecha_inicio,
    fecha_fin,
    prestamo_id,
    activo,
    proyeccion,
    plazo,
    tasa,
    monto,
    meses_gracia,
    meses_muertos,
    diferir_intereses,
    exonerar_intereses_diferidos,
    tasa_gracia,
    frecuencia_pago,
    frecuencia_pago_gracia,
    dia_facturacion,
    fecha_evento,
    motivo_evento)
  values(
    _plan_pago.fecha_inicio,
    _plan_pago.fecha_fin,
    _plan_pago.prestamo_id,
    not(p_proyectado),
    p_proyectado,
    _plan_pago.plazo,
    _valor_tasa,
    _plan_pago.monto,
    _plan_pago.meses_gracia,
    _plan_pago.meses_muertos + p_extension_meses_muertos,
    _plan_pago.diferir_intereses,
    _plan_pago.exonerar_intereses_diferidos,
    _plan_pago.tasa_gracia,
    _plan_pago.frecuencia_pago,
    _plan_pago.frecuencia_pago_gracia,
    _plan_pago.dia_facturacion,
    p_fecha_evento,
    _motivo_evento);
  _plan_pago_id = currval('plan_pago_id_seq');
  
  
  _meses_muertos = _plan_pago.meses_muertos + p_extension_meses_muertos;
  _meses_gracia = _plan_pago.meses_gracia;
  _plazo = _plan_pago.plazo;
  
  -- Actualiza el plan_pago anterior
	if p_proyectado = false then
       update plan_pago set activo = false where id = _plan_pago.id;
  	end if;
  -- Clona las cuotas del plan_pago
  loop
    fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
	exit when not found;
	
	if _plan_pago_cuota.tipo_cuota = 'M' then
	  _meses_muertos = _meses_muertos - 1;
	elsif _plan_pago_cuota.tipo_cuota = 'G' then
	  _meses_gracia = _meses_gracia - _prestamo.frecuencia_pago;	
	else
	  _plazo = _plazo - _prestamo.frecuencia_pago;	
	end if;
	
    insert into plan_pago_cuota (
      plan_pago_id,
      fecha,
      numero,
      valor_cuota,
      amortizado,
      amortizado_acumulado,
      interes_corriente,
      interes_corriente_acumulado,
      interes_diferido,
      interes_mora,
      saldo_insoluto,
      tasa_periodo,
      tipo_cuota,
      vencida,
      estatus_pago,
      pago_interes_mora,
      pago_interes_corriente,
      pago_interes_diferido,
      pago_capital,
      remanente_por_aplicar,
      causado_no_devengado,
      desembolso,
      cambio_tasa,
      abono_extraordinario,
      monto_desembolso,
      monto_abono,
      dias_mora,
      tasa_nominal_anual,
      interes_desembolso,
      pago_interes_desembolso,
      cantidad_dias,
      interes_foncrei,
      interes_intermediario)
    values(
      _plan_pago_id,
      _plan_pago_cuota.fecha,
      _plan_pago_cuota.numero,
      _plan_pago_cuota.valor_cuota,
      _plan_pago_cuota.amortizado,
      _plan_pago_cuota.amortizado_acumulado,
      _plan_pago_cuota.interes_corriente,
      _plan_pago_cuota.interes_corriente_acumulado,
      _plan_pago_cuota.interes_diferido,
      _plan_pago_cuota.interes_mora,
      _plan_pago_cuota.saldo_insoluto,
      _plan_pago_cuota.tasa_periodo,
      _plan_pago_cuota.tipo_cuota,
      _plan_pago_cuota.vencida,
      _plan_pago_cuota.estatus_pago,
      _plan_pago_cuota.pago_interes_mora,
      _plan_pago_cuota.pago_interes_corriente,
      _plan_pago_cuota.pago_interes_diferido,
      _plan_pago_cuota.pago_capital,
      _plan_pago_cuota.remanente_por_aplicar,
      _plan_pago_cuota.causado_no_devengado,
      _plan_pago_cuota.desembolso,
      _plan_pago_cuota.cambio_tasa,      
      _plan_pago_cuota.abono_extraordinario,
      _plan_pago_cuota.monto_desembolso,
      _plan_pago_cuota.monto_abono,
      _plan_pago_cuota.dias_mora,
      _plan_pago_cuota.tasa_nominal_anual,
      _plan_pago_cuota.interes_desembolso,
      _plan_pago_cuota.pago_interes_desembolso,
      _plan_pago_cuota.cantidad_dias,
      _plan_pago_cuota.interes_foncrei,
      _plan_pago_cuota.interes_intermediario);
  end loop;

   _plan_pago_cuota_id = currval('plan_pago_cuota_id_seq');
   
   if p_tiene_desembolso then
	   update plan_pago_cuota set monto_desembolso = monto_desembolso + p_monto_desembolso, desembolso = true
	     where id = _plan_pago_cuota_id;	     
   end if;
   
   if p_tiene_abono then
	   update plan_pago_cuota set monto_abono = monto_abono + p_monto_abono, 
	                              bolivar_fuerte = true
	     where id = _plan_pago_cuota_id;
   end if;
  
   if p_tiene_tasa then
	   update plan_pago_cuota set cambio_tasa = true
	     where id = _plan_pago_cuota_id;
   end if;  
   
   select into _plan_pago_cuota * from plan_pago_cuota 
    where id = _plan_pago_cuota_id;
    

   if _plan_pago_cuota is null then
      _monto_insoluto = _prestamo.monto_liquidado;
   else
      _monto_insoluto = (_plan_pago_cuota.saldo_insoluto + _plan_pago_cuota.monto_desembolso)- _plan_pago_cuota.monto_abono;
   end if;
  
  _monto_insoluto = rounded(_monto_insoluto / 1000);

 -- raise notice 'numero_cuota%',_plan_pago_cuota.numero;
  raise notice 'saldo_insoluto_cuota%________________________', _monto_insoluto;
  --raise notice 'monto_abono%',p_monto_abono;
  --raise notice '**************************************************monto_insoluto%',_monto_insoluto;
   
 
 raise notice 'MESES_MUERTOS__________________________%', _meses_muertos;
 
  perform generar_plan_pago(
    p_proyectado,
    _prestamo.formula_id,
    p_prestamo_id,
    _plan_pago_id,
    _plan_pago_cuota.numero,
    _plan_pago_cuota.tipo_cuota,
    _plan_pago_cuota.interes_corriente_acumulado,
    _plan_pago_cuota.amortizado_acumulado,
    _fecha_focal,
    _monto_insoluto,
    _plazo,
    _plan_pago.frecuencia_pago,
    _valor_tasa,
    _meses_muertos,
    _meses_gracia,
    0,
    _plan_pago.exonerar_intereses_diferidos,
    _valor_tasa,
    _plan_pago.frecuencia_pago,
    p_desembolso_id,
    false,
    p_fecha_evento,
    p_monto_desembolso,
    _plan_pago_cuota.interes_diferido
  );
  -- Actualiza la tasa del prestamo si el evento es un cambio de tasa
  if p_tiene_tasa = true and p_proyectado = false then
    update prestamo set tasa_vigente = p_valor_tasa where id = p_prestamo_id;
  end if;
 
/*
#  if p_tiene_abono = true and p_proyectado = false then
#      insert into factura (numero, monto, fecha, fecha_realizacion, desembolso_id, tipo, prestamo_id)
#        values ((select ultima_factura from parametro_general) + 1, p_monto_abono, p_fecha_evento,
#        p_fecha_evento, null, 'E', p_prestamo_id);
#      _factura_id = currval('factura_id_seq');
#      
#      update parametro_general set ultima_factura = ultima_factura + 1;
#  
#     perform stc_abono_extraordinario(
#     p_monto_abono, 
#     _con_programa_origen_fondo.cuenta_contable_capital_id,
#     p_fecha_evento, 
#     p_fecha_evento, 
#     p_prestamo_id, 
#     _factura_id, 
#     cast( extract(year from p_fecha_evento) as integer));  
#     
#    -- raise notice 'si paso por el abono';
#  end if;
*/

  --raise exception 'error';
  
  return true;
 
end;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.generar_plan_pago_evento_bf(p_proyectado boolean, p_prestamo_id integer, p_fecha_evento date, p_tiene_desembolso boolean, p_monto_desembolso double precision, p_tiene_tasa boolean, p_valor_tasa double precision, p_tiene_abono boolean, p_monto_abono double precision, p_desembolso_id integer, p_extension_meses_muertos integer) OWNER TO cartera;

--
-- Name: generar_plan_pago_reestructuracion(integer, date, integer, integer, double precision, integer, double precision); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION generar_plan_pago_reestructuracion(p_prestamo_id integer, p_fecha date, p_formula_id integer, p_frecuencia_pago integer, p_monto double precision, p_plazo integer, p_valor_tasa double precision) RETURNS boolean
    AS $$

 declare

   

   

 begin

 

   perform generar_plan_pago(

     false,

     p_formula_id,

     p_prestamo_id,

     0,

     null,

     'C',

     0,

     0,

     p_fecha,

     p_monto,

     p_plazo,

     p_frecuencia_pago,

     p_valor_tasa,

     0,

     0,

     0,

     false,

     p_valor_tasa,

     p_frecuencia_pago,

     null,

     true,

     null,

     0

   );  

   

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.generar_plan_pago_reestructuracion(p_prestamo_id integer, p_fecha date, p_formula_id integer, p_frecuencia_pago integer, p_monto double precision, p_plazo integer, p_valor_tasa double precision) OWNER TO cartera;

--
-- Name: iniciar_transaccion(integer, integer, character varying, character, character varying); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION iniciar_transaccion(p_prestamo_id integer, p_usuario_id integer, p_nombre character varying, p_tipo character, p_descripcion character varying) RETURNS boolean
    AS $$





 declare





   _meta_transaccion meta_transaccion%rowtype;





 begin





   





   select into _meta_transaccion * from meta_transaccion





     where nombre = p_nombre;





 





   insert into transaccion (prestamo_id, meta_transaccion_id, usuario_id, fecha, tipo, descripcion) 





     values(p_prestamo_id, _meta_transaccion.id, p_usuario_id, current_timestamp, p_tipo, p_descripcion);





 





   return true;





 





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.iniciar_transaccion(p_prestamo_id integer, p_usuario_id integer, p_nombre character varying, p_tipo character, p_descripcion character varying) OWNER TO cartera;

--
-- Name: interes_devengado_fin_mes(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION interes_devengado_fin_mes(p_prestamo_id integer, p_fecha date) RETURNS boolean
    AS $$





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





     





      if _interes > 0 then





          update plan_pago_cuota set intereses_por_cobrar_al_30 = intereses_por_cobrar_al_30 + _interes where id = _plan_pago_cuota.id;





          





        --  raise notice '__________________________-cuenta_contable_id%',_con_programa_origen_fondo.cuenta_contable_ingreso_interes_id; 





 	     perform stc_interes_devengado_fin_mes(





 		     _interes, 





 		     _con_programa_origen_fondo.cuenta_contable_ingreso_interes_id,





 		     p_fecha, p_fecha, p_prestamo_id, 0, 





 		     cast(extract(year from _plan_pago_cuota.fecha) as integer));





 	 end if;





    end if;   





    --raise exception 'se_termino_todo';





    return false;





 





 end;





 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interes_devengado_fin_mes(p_prestamo_id integer, p_fecha date) OWNER TO cartera;

--
-- Name: interes_devengado_vencimiento_cuota(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION interes_devengado_vencimiento_cuota(p_prestamo_id integer, p_fecha date) RETURNS boolean
    AS $$

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

 		     p_fecha, p_fecha, p_prestamo_id, 0, 

 		     cast(extract(year from _plan_pago_cuota.fecha) as integer));

 	 end if;

    end if;   

     

    return false;

 

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interes_devengado_vencimiento_cuota(p_prestamo_id integer, p_fecha date) OWNER TO cartera;

--
-- Name: log_transaccion(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION log_transaccion() RETURNS "trigger"
    AS $$

 declare

   _tipo char;

   _cur_attributes refcursor;

   _registro record;

   _registro_retorno record;

   _attribute varchar;

   _sql_execute varchar;

   _sql_fields varchar;

   _first_field bool;

   _transaccion_id integer;

   _table_name varchar;

   _transaccion_accion_id integer;

   _t_momento char;

 begin

 

   _table_name = cast(TG_RELNAME as varchar);

   

   begin

 

 	  if TG_OP = 'INSERT' then

 	    _tipo = 'A';

 	    _registro = NEW;

 	    _registro_retorno = NEW;

 	    _t_momento = 'D';

 	    --raise notice 'SE AGREGO CON____%,', _registro.id;

 	  elsif TG_OP = 'UPDATE' then

 	    _tipo = 'M';

 	    if TG_WHEN = 'BEFORE' then

 	      _registro = OLD;

 	      _registro_retorno = NEW;

 	      _t_momento = 'A';

 	    elsif TG_WHEN = 'AFTER' then

 	      _registro = NEW;

 	      _registro_retorno = NEW;

 	      _t_momento = 'D';

 	    end if;

 	    --raise notice 'SE MODIFICO CON____%,', _registro.id;

 	  elsif TG_OP = 'DELETE' then

 	    _tipo = 'E';

 	    _registro = OLD;

 	    _registro_retorno = OLD;

 	    _t_momento = 'A';

 		--raise notice 'SE ELIMINO CON____%,', _registro.id;

 	  end if;

   

     _transaccion_id = currval('transaccion_id_seq');    

     

   

 

   

   if not (TG_OP = 'UPDATE' and TG_WHEN = 'AFTER') then

     insert into transaccion_accion (transaccion_id, tipo, tabla, tabla_id) values(_transaccion_id, _tipo, _table_name, _registro.id);

   end if;

   

   _transaccion_accion_id = currval('transaccion_accion_id_seq');

   

   perform tabla_transaccion(_table_name);

   

   _sql_fields = campos_tabla(_table_name, false, false);

   

   _sql_execute = 'insert into tr_' || _table_name || ' (tr_transaccion_accion_id, tr_momento, ' || _sql_fields

     || ') select ' || _transaccion_accion_id || ', ' || quote_literal(_t_momento) || ', ' || _sql_fields || ' from ' || _table_name 

     ||' where id = ' || _registro.id;

   

   execute _sql_execute;

   

   return _registro_retorno;

  exception when others then

     return _registro_retorno;

   end;

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.log_transaccion() OWNER TO cartera;

--
-- Name: preparar_tablas(); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION preparar_tablas() RETURNS boolean
    AS $$

 declare

   _cur_tablas refcursor;

   _tabla varchar;

   _sql_execute varchar;

 begin

 

   open _cur_tablas for 

     select relname from pg_class where relkind = 'r' and not relname~'pg_.*' and not relname~'tr_.*' and not relname~'sql_.*' and relname<>'comprobante_contable' and relname<>'asiento_contable' and relname<>'transaccion' and relname<>'transaccion_accion';

 

   loop

     fetch _cur_tablas INTO _tabla;

 	exit when not found;

 	

     _sql_execute = 'drop trigger log_trigger_' || _tabla || ' on ' || _tabla;

 	begin

       execute _sql_execute;

     exception when others then

       raise notice 'No existe el trigger log_trigger_%', _tabla;

     end;

     

     _sql_execute = 'drop trigger log_e_trigger_' || _tabla || ' on ' || _tabla;

 	begin

       execute _sql_execute;

     exception when others then

       raise notice 'No existe el trigger log_e_trigger_%', _tabla;

     end;

 	

 	_sql_execute = 'create trigger log_trigger_' || _tabla || ' after insert or update on ' 

 	  || _tabla || ' for each row execute procedure log_transaccion()';

 	execute _sql_execute;

 	

     raise notice 'Creado el trigger log_trigger_%', _tabla;

 	

 	_sql_execute = 'create trigger log_e_trigger_' || _tabla || ' before delete or update on ' 

 	  || _tabla || ' for each row execute procedure log_transaccion()';

 	execute _sql_execute;

 	

     raise notice 'Creado el trigger log_e_trigger_%', _tabla;

 

   end loop;

   

   raise notice 'El procedimiento se ejecutÃƒÂ³ con ÃƒÂ©xito';

   

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.preparar_tablas() OWNER TO cartera;

--
-- Name: reclasificar_cuota(integer, date); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION reclasificar_cuota(p_prestamo_id integer, p_fecha date) RETURNS boolean
    AS $$

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

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.reclasificar_cuota(p_prestamo_id integer, p_fecha date) OWNER TO cartera;

--
-- Name: reversar_transaccion(integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION reversar_transaccion(p_transaccion_id integer) RETURNS boolean
    AS $$

 declare

   _cur_acciones refcursor;

   _transaccion_accion record;

   _sql_execute varchar;

   _sql_fields varchar;

   _first_field bool;

   _prestamo record;

   _cur_comprobantes refcursor;

   _comprobante_contable record;

   _comprobante_contable_id integer;

   _cur_asientos refcursor;

   _asiento_contable record;

   _asiento_tipo char;

   _asiento_contable_id integer;

 begin

 

   open _cur_acciones for 

     select * from transaccion_accion where transaccion_id = p_transaccion_id order by id desc;

 

 

   loop

     fetch _cur_acciones INTO _transaccion_accion;

 	exit when not found;

 	

     if _transaccion_accion.tipo = 'A' then

       _sql_execute = 'delete from ' || _transaccion_accion.tabla || ' where id = ' || _transaccion_accion.tabla_id;

       raise notice 'AgregÃƒÂ³ el registro %',_transaccion_accion.tabla;

       raise notice 'AgregÃƒÂ³ el registro %',_transaccion_accion.tabla_id;

       raise notice 'AgregÃƒÂ³ la acciÃƒÂ³n %',_transaccion_accion.id;

       execute _sql_execute;

     else

       

       if _transaccion_accion.tipo = 'E' then

     	_sql_fields = campos_tabla(_transaccion_accion.tabla, false, false);

       

         _sql_execute = 'insert into ' || _transaccion_accion.tabla || ' (' || _sql_fields || ')  '

           || ' select ' || _sql_fields || ' from tr_' || _transaccion_accion.tabla 

           || ' where tr_transaccion_accion_id = ' || _transaccion_accion.id;

 

         raise notice 'EliminÃƒÂ³ el registro %',_transaccion_accion.tabla;          

         raise notice 'EliminÃƒÂ³ el registro %',_transaccion_accion.tabla_id;

         raise notice 'EliminÃƒÂ³ la acciÃƒÂ³n %',_transaccion_accion.id;

         

         execute _sql_execute;

 

       elsif _transaccion_accion.tipo = 'M' then

     	_sql_fields = campos_tabla(_transaccion_accion.tabla, false, true);

 

         _sql_execute = 'update ' || _transaccion_accion.tabla || ' set ' || _sql_fields

           || ' from tr_' || _transaccion_accion.tabla 

           || ' where tr_' || _transaccion_accion.tabla || '.tr_transaccion_accion_id = ' || _transaccion_accion.id

           || ' and tr_' || _transaccion_accion.tabla || '.id = ' || _transaccion_accion.tabla || '.id and tr_' 

           || _transaccion_accion.tabla || '.tr_momento = ' || quote_literal('A');

 

         raise notice 'ActualizÃƒÂ³ el registro %',_transaccion_accion.tabla;

         raise notice 'ActualizÃƒÂ³ el registro %',_transaccion_accion.tabla_id;

         raise notice 'ActualizÃƒÂ³ la acciÃƒÂ³n %',_transaccion_accion.id;

           

         execute _sql_execute;

         

         if _transaccion_accion.tabla = 'prestamo' then

           select into _prestamo * from prestamo where id = _transaccion_accion.tabla_id;

           raise notice 'PrÃƒÂ©stamo %',_prestamo.remanente_por_aplicar;

         end if;

       end if;

     end if;

   end loop;

   

   open _cur_comprobantes for 

     select * from comprobante_contable where transaccion_id = p_transaccion_id order by id asc;

     

   loop

     fetch _cur_comprobantes INTO _comprobante_contable;

 	exit when not found;

 	

 	insert into comprobante_contable 

 	  (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, 

 	  factura_id, anio, reverso, reversado, comprobante_reversado_id, total_debe, total_haber) 

 	  values(current_date, current_date, false, _comprobante_contable.prestamo_id,

 	  _comprobante_contable.transaccion_contable_id,

 	  _comprobante_contable.factura_id,

 	  _comprobante_contable.anio,

 	  true, false, _comprobante_contable_id, 

 	  _comprobante_contable.total_haber, _comprobante_contable.total_debe);

 	

 	_comprobante_contable_id = currval('comprobante_contable_id_seq');

 	

     open _cur_asientos for 

 	    select * from asiento_contable where 

 	      comprobante_contable_id = _comprobante_contable.id order by id asc;

 	      

     loop

       fetch _cur_asientos INTO _asiento_contable;

 	  exit when not found;

 	  

 	  if _asiento_contable.tipo = 'D' then

 	    _asiento_tipo = 'H';

 	  else

 	    _asiento_tipo = 'D';

 	  end if;

 	    

       insert into asiento_contable (comprobante_contable_id, cuenta_contable_id, 

         cuenta_contable_presupuesto_id, monto, tipo) values(

         _comprobante_contable_id, _asiento_contable.cuenta_contable_id,

         _asiento_contable.cuenta_contable_presupuesto_id,

         _asiento_contable.monto, _asiento_tipo);

     end loop;

         

 	update comprobante_contable set reversado = true, comprobante_reverso_id = _comprobante_contable_id

 	  where id = _comprobante_contable.id;

 	  

 	close _cur_asientos;

 	

   end loop;

   

   update transaccion set reversada = true where id = p_transaccion_id;

   

           select into _prestamo * from prestamo where id = _transaccion_accion.tabla_id;

           raise notice 'PrÃƒÂ©stamo %',_prestamo.remanente_por_aplicar;

   

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.reversar_transaccion(p_transaccion_id integer) OWNER TO cartera;

--
-- Name: stc_abono_extraordinario(double precision, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_abono_extraordinario(p_monto double precision, p_cuenta_capital integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 7, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true  then

     

     

     if p_monto > 0 then

       

       

         _cuenta_contable_id = 105;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_monto > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'H');

       

       

         _total_haber = _total_haber + p_monto;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_abono_extraordinario(p_monto double precision, p_cuenta_capital integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_abono_extraordinario_online(character varying, integer, double precision, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_abono_extraordinario_online(p_modalidad character varying, p_cuenta_banco integer, p_monto double precision, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 6, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if p_modalidad = 'R' then

     

     

     if p_monto > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_monto > 0 then

       

       

         _cuenta_contable_id = 105;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'H');

       

       

         _total_haber = _total_haber + p_monto;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'O' then

     

     

     if p_monto > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_monto > 0 then

       

       

         _cuenta_contable_id = 105;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'H');

       

       

         _total_haber = _total_haber + p_monto;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_abono_extraordinario_online(p_modalidad character varying, p_cuenta_banco integer, p_monto double precision, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_cancelacion_prestamo(double precision, integer, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_cancelacion_prestamo(p_monto double precision, p_cuenta_banco integer, p_capital double precision, p_intereses_por_cobrar double precision, p_ingreso_por_intereses double precision, p_capital_vencido double precision, p_intereses_por_cobrar_vencido double precision, p_intereses_mora double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 8, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true = true then

     

     

     if p_monto > 0 then

       

       

         _cuenta_contable_id = 106;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_capital > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital,

         'H');

       

       

         _total_haber = _total_haber + p_capital;

       

       

     end if;

     

     

     if p_intereses_por_cobrar > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_por_cobrar,

         'H');

       

       

         _total_haber = _total_haber + p_intereses_por_cobrar;

       

       

     end if;

     

     

     if p_ingreso_por_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_por_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_por_intereses;

       

       

     end if;

     

     

     if p_capital_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_capital_vencido;

       

       

     end if;

     

     

     if p_intereses_por_cobrar_vencido > 0 then

       

       

         _cuenta_contable_id = 64;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_por_cobrar_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_intereses_por_cobrar_vencido;

       

       

     end if;

     

     

     if p_intereses_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_mora,

         'H');

       

       

         _total_haber = _total_haber + p_intereses_mora;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_cancelacion_prestamo(p_monto double precision, p_cuenta_banco integer, p_capital double precision, p_intereses_por_cobrar double precision, p_ingreso_por_intereses double precision, p_capital_vencido double precision, p_intereses_por_cobrar_vencido double precision, p_intereses_mora double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_cancelacion_prestamo(double precision, integer, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_cancelacion_prestamo(p_monto double precision, p_cuenta_banco integer, p_capital double precision, p_intereses_por_cobrar double precision, p_ingreso_por_intereses double precision, p_capital_vencido double precision, p_intereses_mora double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 8, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true = true then

     

     

     if p_monto > 0 then

       

       

         _cuenta_contable_id = 106;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_capital > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital,

         'H');

       

       

         _total_haber = _total_haber + p_capital;

       

       

     end if;

     

     

     if p_intereses_por_cobrar > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_por_cobrar,

         'H');

       

       

         _total_haber = _total_haber + p_intereses_por_cobrar;

       

       

     end if;

     

     

     if p_ingreso_por_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_por_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_por_intereses;

       

       

     end if;

     

     

     if p_capital_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_capital_vencido;

       

       

     end if;

     

     

     if p_intereses_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_mora,

         'H');

       

       

         _total_haber = _total_haber + p_intereses_mora;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_cancelacion_prestamo(p_monto double precision, p_cuenta_banco integer, p_capital double precision, p_intereses_por_cobrar double precision, p_ingreso_por_intereses double precision, p_capital_vencido double precision, p_intereses_mora double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_desembolso(double precision, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_desembolso(p_monto double precision, p_cuenta_banco integer, p_cuenta_capital integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 9, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true then

     

     

     if p_monto > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'D');

       

       

         _total_debe = _total_debe + p_monto;

       

       

     end if;

     

     

     if p_monto > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto,

         'H');

       

       

         _total_haber = _total_haber + p_monto;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_desembolso(p_monto double precision, p_cuenta_banco integer, p_cuenta_capital integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_eventos_vencimiento_cuota(double precision, integer, double precision, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_eventos_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_capital_cuota double precision, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 10, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true then

     

     

     if p_monto_interes > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'D');

       

       

         _total_debe = _total_debe + p_monto_interes;

       

       

     end if;

     

     

     if p_monto_interes > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'H');

       

       

         _total_haber = _total_haber + p_monto_interes;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_eventos_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_capital_cuota double precision, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_interes_devengado_fin_mes(double precision, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_interes_devengado_fin_mes(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 5, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true = true then

     

     

     if p_monto_interes > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'D');

       

       

         _total_debe = _total_debe + p_monto_interes;

       

       

     end if;

     

     

     if p_monto_interes > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'H');

       

       

         _total_haber = _total_haber + p_monto_interes;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_interes_devengado_fin_mes(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_interes_devengado_vencimiento_cuota(double precision, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_interes_devengado_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 10, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true then

     

     

     if p_monto_interes > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'D');

       

       

         _total_debe = _total_debe + p_monto_interes;

       

       

     end if;

     

     

     if p_monto_interes > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'H');

       

       

         _total_haber = _total_haber + p_monto_interes;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_interes_devengado_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_interes_devengado_vencimiento_cuota(double precision, integer, double precision, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_interes_devengado_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_capital_cuota double precision, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 10, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true then

     

     

     if p_monto_interes > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'D');

       

       

         _total_debe = _total_debe + p_monto_interes;

       

       

     end if;

     

     

     if p_monto_interes > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_interes,

         'H');

       

       

         _total_haber = _total_haber + p_monto_interes;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_interes_devengado_vencimiento_cuota(p_monto_interes double precision, p_cuenta_ingreso_interes integer, p_capital_cuota double precision, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 1, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if p_modalidad = 'R' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 4;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'O' then

     

     

     if p_monto_pago > 0 then

       

       

         _cuenta_contable_id = 1;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'B' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_comision_intereses > 0 then

       

       

         _cuenta_contable_id = 15;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_comision_intereses,

         'D');

       

       

         _total_debe = _total_debe + p_monto_comision_intereses;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 4;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_comision_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_comision_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_comision_intereses;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 1, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if p_modalidad = 'B' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_comision_intereses > 0 then

       

       

         _cuenta_contable_id = 107;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_comision_intereses,

         'D');

       

       

         _total_debe = _total_debe + p_monto_comision_intereses;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_comision_intereses > 0 then

       

       

         _cuenta_contable_id = 107;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_comision_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_comision_intereses;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'R' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'O' then

     

     

     if p_monto_pago > 0 then

       

       

         _cuenta_contable_id = 1;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago_anio_anterior(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago_anio_anterior(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 4, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if p_modalidad = 'R' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 4;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'O' then

     

     

     if p_monto_pago > 0 then

       

       

         _cuenta_contable_id = 1;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago_anio_anterior(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago_anio_anterior(character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago_anio_anterior(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 4, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if p_modalidad = 'O' then

     

     

     if p_monto_pago > 0 then

       

       

         _cuenta_contable_id = 1;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

   end if;

   

 

   if p_modalidad = 'R' then

     

     

     if p_monto_pago > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_banco;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_pago,

         'D');

       

       

         _total_debe = _total_debe + p_monto_pago;

       

       

     end if;

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago_anio_anterior(p_modalidad character varying, p_cuenta_banco integer, p_monto_pago double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_remanente_por_aplicar double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago_cierre(double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago_cierre(p_monto_pago double precision, p_remanente_por_aplicar double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intermediario double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 2, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true = true then

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 4;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses_vencido > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses_vencido;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 7;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 6;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago_cierre(p_monto_pago double precision, p_remanente_por_aplicar double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_por_cobrar_intereses_vencido double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intermediario double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_pago_cierre(double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_pago_cierre(p_monto_pago double precision, p_remanente_por_aplicar double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intermediario double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 2, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true = true then

     

     

     if p_remanente_por_aplicar_inicial > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar_inicial,

         'D');

       

       

         _total_debe = _total_debe + p_remanente_por_aplicar_inicial;

       

       

     end if;

     

     

     if p_monto_capital_cuota > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_monto_capital_cuota;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 65;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_monto_ingreso_intereses > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_ingreso_interes;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingreso_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingreso_intereses;

       

       

     end if;

     

     

     if p_monto_credito_cuota_vencido > 0 then

       

       

         select into _cuenta_contable * from cuenta_contable where id = p_cuenta_capital_vencido;

         _cuenta_contable_id = _cuenta_contable.id;

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_credito_cuota_vencido,

         'H');

       

       

         _total_haber = _total_haber + p_monto_credito_cuota_vencido;

       

       

     end if;

     

     

     if p_ingreso_mora > 0 then

       

       

         _cuenta_contable_id = 99;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_ingreso_mora,

         'H');

       

       

         _total_haber = _total_haber + p_ingreso_mora;

       

       

     end if;

     

     

     if p_remanente_por_aplicar > 0 then

       

       

         _cuenta_contable_id = 209;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_remanente_por_aplicar,

         'H');

       

       

         _total_haber = _total_haber + p_remanente_por_aplicar;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_pago_cierre(p_monto_pago double precision, p_remanente_por_aplicar double precision, p_monto_ingreso_intereses double precision, p_monto_por_cobrar_intereses double precision, p_monto_capital_cuota double precision, p_ingreso_mora double precision, p_monto_credito_cuota_vencido double precision, p_remanente_por_aplicar_inicial double precision, p_monto_comision_intermediario double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: stc_reclasificacion_prestamo(double precision, double precision, double precision, double precision, integer, integer, integer, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION stc_reclasificacion_prestamo(p_intereses_por_cobrar_vencidos double precision, p_capital_cuota double precision, p_monto_ingresos_intereses double precision, p_monto_por_cobrar_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) RETURNS boolean
    AS $$

 

 declare

   _comprobante_contable_id integer;

   _cuenta_contable_id integer;

   _cuenta_contable cuenta_contable%rowtype;

   _cuenta_contable_presupuesto_id integer = null;

   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;

   _transaccion_contable transaccion_contable%rowtype;

   _total_debe float;

   _total_haber float;

   _factura_id integer = null;

   _transaccion_id integer;

 begin

 

   if p_factura_id > 0 then

     _factura_id = p_factura_id;

   end if;

   

   begin

     _transaccion_id = currval('transaccion_id_seq');

   exception when others then

     _transaccion_id = 0;

   end;

 

   insert into comprobante_contable (fecha_registro, fecha_comprobante, enviado, prestamo_id, transaccion_contable_id, factura_id, anio, transaccion_id, reverso, reversado) values(

     p_fecha_registro, p_fecha_comprobante, false, p_prestamo_id, 3, _factura_id, p_anio, _transaccion_id, false, false);

  

   _comprobante_contable_id = currval('comprobante_contable_id_seq');

 

   _total_debe = 0;

   _total_haber = 0;

 

 

   if true then

     

     

     if p_intereses_por_cobrar_vencidos > 0 then

       

       

         _cuenta_contable_id = 8;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_intereses_por_cobrar_vencidos,

         'D');

       

       

         _total_debe = _total_debe + p_intereses_por_cobrar_vencidos;

       

       

     end if;

     

     

     if p_monto_por_cobrar_intereses > 0 then

       

       

         _cuenta_contable_id = 5;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_por_cobrar_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_por_cobrar_intereses;

       

       

     end if;

     

     

     if p_capital_cuota > 0 then

       

       

         _cuenta_contable_id = 9;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital_cuota,

         'D');

       

       

         _total_debe = _total_debe + p_capital_cuota;

       

       

     end if;

     

     

     if p_monto_ingresos_intereses > 0 then

       

       

         _cuenta_contable_id = 4;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_monto_ingresos_intereses,

         'H');

       

       

         _total_haber = _total_haber + p_monto_ingresos_intereses;

       

       

     end if;

     

     

     if p_capital_cuota > 0 then

       

       

         _cuenta_contable_id = 3;   	

       

      

       if p_anio > 0 then

         select into _cuenta_contable_presupuesto * from cuenta_contable_presupuesto

           where cuenta_contable_id = _cuenta_contable_id and anio = p_anio;

         if found then

           _cuenta_contable_presupuesto_id = _cuenta_contable_presupuesto.id;

         end if;

       end if;

       

       insert into asiento_contable (

         comprobante_contable_id, 

         cuenta_contable_id, 

         cuenta_contable_presupuesto_id,

         monto,

         tipo) values(

         _comprobante_contable_id, 

         _cuenta_contable_id,

         _cuenta_contable_presupuesto_id,

         p_capital_cuota,

         'H');

       

       

         _total_haber = _total_haber + p_capital_cuota;

       

       

     end if;

     

   end if;

   

 

 

   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber

     where id = _comprobante_contable_id;

 

   return true;

  

 end;

 $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.stc_reclasificacion_prestamo(p_intereses_por_cobrar_vencidos double precision, p_capital_cuota double precision, p_monto_ingresos_intereses double precision, p_monto_por_cobrar_intereses double precision, p_cuenta_ingreso_interes integer, p_cuenta_capital integer, p_cuenta_capital_vencido integer, p_fecha_registro date, p_fecha_comprobante date, p_prestamo_id integer, p_factura_id integer, p_anio integer) OWNER TO cartera;

--
-- Name: tabla_transaccion(character varying); Type: FUNCTION; Schema: public; Owner: cartera
--

CREATE OR REPLACE FUNCTION tabla_transaccion(p_tablename character varying) RETURNS boolean
    AS $$

 declare

   _pg_type pg_type%rowtype;

   _sql_execute varchar;

 

 begin

 

   select into _pg_type * from pg_type where typname = 'tr_' || p_tablename;

 

   if not found then

     

     _sql_execute = 'create table tr_' || p_tablename || ' as select * from ' 

       || p_tablename || ' where false; alter table tr_' || p_tablename 

       || ' add column tr_id serial primary key, add column tr_transaccion_accion_id integer, add column tr_momento char;';

     execute _sql_execute;

   end if;

   

   return false;

  

 end;

 $$
    LANGUAGE plpgsql;


