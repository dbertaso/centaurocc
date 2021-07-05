-- Function: calcular_cartera_programa(date, integer, integer)

-- DROP FUNCTION calcular_cartera_programa(date, integer, integer);

CREATE OR REPLACE FUNCTION calcular_cartera_programa(p_fecha date, p_oficina_id integer, p_programa_id integer)
  RETURNS boolean AS
$BODY$
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
                                      
    where prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A', 'X') order by prestamo.numero;

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
		prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A', 'X') and
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
		    prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A', 'X')   	 
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

	/*
	----------------------------------------------------------------------
	El cursor que se agrega a continuacion verifica la ultima cuota del
	prestamo. Si es la ultima cuota del prestamo no procede el cambio de
	tasa ya que no existen mas cuotas y no se puede hacer una equivalencia
	financiera

	Diego Bertaso 
	Fecha:	2008-02-29
	-----------------------------------------------------------------------
	*/

	open _cur_cuotas_por_cobrar 
			for select count(id) as cantidad from plan_pago_cuota 
				where
					fecha >= p_fecha and tipo_cuota = 'C'
					and plan_pago_id in (select id from plan_pago 
					where prestamo_id = _prestamo.id and activo = true and proyeccion = false);

	fetch _cur_cuotas_por_cobrar INTO _row_cuotas_por_cobrar;

	if _row_cuotas_por_cobrar.cantidad = 1 then
		_tiene_tasa = false;
		_tiene_abono = false;
	end if;

	close _cur_cuotas_por_cobrar;

	/* Fin de modificacion validacion ultima cuota */
      
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

	where prestamo.estatus not in ('S', 'L', 'Q', 'R', 'C', 'F', 'A', 'X') and
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION calcular_cartera_programa(date, integer, integer) OWNER TO cartera;
