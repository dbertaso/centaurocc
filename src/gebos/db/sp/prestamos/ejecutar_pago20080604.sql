-- Function: ejecutar_pago(integer, character varying[], integer, bpchar, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean)

-- DROP FUNCTION ejecutar_pago(integer, character varying[], integer, bpchar, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION ejecutar_pago(p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad bpchar, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_cancelacion_prestamo boolean, p_hay_cheques boolean, p_exonerar_mora boolean)
  RETURNS integer AS
$BODY$
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
    _interes_intermediario NUMERIC(16,2);
    
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
    _remanente_por_aplicar = _pago_monto_prestamo + _prestamo.remanente_por_aplicar;
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

    
    --if _p_exonerar_mora = true and
	--_pago_monto_prestamo  < _prestamo.exigible then
			--_p_exonerar_mora = false;
    --end if;
    
     ---> fin modificacion

    insert into pago_prestamo (monto, prestamo_id, pago_cliente_id)
        values(_pago_monto_prestamo, _prestamo_id, _pago_cliente_id);

    _pago_prestamo_id = currval('pago_prestamo_id_seq');

    if p_fecha_realizacion < p_fecha and _prestamo.estatus <> 'L' and _p_exonerar_mora = false then
	   select into _parametro_general * from parametro_general limit 1;
	   _fecha_calculo = p_fecha_realizacion;
	  -- _fecha_calculo = agregar_dias(p_fecha_realizacion, +(_parametro_general.dias_gracia_mora+1));
	   raise notice 'fecha_calculo antes de calcular mora______________%',_fecha_calculo;

	   /* Elimina los registros de plan_pago_mora que fueron calculados por el cierre y que tengan valor = 1 */
	   
	   delete from plan_pago_mora
				
           where plan_pago_mora.id
		in (

			   select plan_pago_mora.id from plan_pago_mora
						inner join plan_pago on (plan_pago.prestamo_id = _prestamo.id and
								   plan_pago.activo = true)
						inner join plan_pago_cuota on (plan_pago_cuota.plan_pago_id = plan_pago.id 		and
									 plan_pago_cuota.id = plan_pago_mora.plan_pago_cuota_id)
			   where
				 plan_pago_mora.valor = 1);

	   /* Elimina los registros de plan_pago_mora de tipo pago cuya fecha sea posterior a la fecha de calculo */

	   delete from plan_pago_mora
				
           where plan_pago_mora.id
		in (

			   select plan_pago_mora.id from plan_pago_mora
						inner join plan_pago on (plan_pago.prestamo_id = _prestamo.id and
								   plan_pago.activo = true)
						inner join plan_pago_cuota on (plan_pago_cuota.plan_pago_id = plan_pago.id 		and
									 plan_pago_cuota.id = plan_pago_mora.plan_pago_cuota_id)
			   where
				 plan_pago_mora.valor = 2 and plan_pago_mora.fecha_fin > _fecha_calculo);	
				   
	 perform calcular_mora(_prestamo_id, p_fecha_realizacion, _fecha_calculo, false, 2);
	 
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
	_interes_intermediario = 0;
    
       if _plan_pago_cuota.interes_mora >= _plan_pago_cuota.pago_interes_mora  then
            _deuda_interes_mora = _plan_pago_cuota.interes_mora - _plan_pago_cuota.pago_interes_mora;
       else
           _deuda_interes_mora =  _plan_pago_cuota.interes_mora;
       end if;
           
      _deuda_cuota = _plan_pago_cuota.valor_cuota +     
	    _deuda_interes_mora + _plan_pago_cuota.interes_diferido -
	    (_plan_pago_cuota.pago_interes_corriente +
	    _plan_pago_cuota.pago_interes_diferido + _plan_pago_cuota.pago_capital);
	    
      _deuda_interes_desembolso = _plan_pago_cuota.interes_desembolso - _plan_pago_cuota.pago_interes_desembolso;
      _deuda_interes_diferido = _plan_pago_cuota.interes_diferido - _plan_pago_cuota.pago_interes_diferido;
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

					/* insert de plan_pago_mora debido a cancelación de la totalidad de la mora y por lo
					   tanto se actualiza la nueva fecha para calculo de mora
					*/
					
					insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital,valor) values(_plan_pago_cuota.id, 0, p_fecha_realizacion, p_fecha_realizacion, 0,2);  
						        
				else	              
					_pago_interes_mora = _remanente_por_aplicar;	      
					_pago_incompleto = true;  

				end if; ---> if _remanente_por_aplicar >= _deuda_interes_mora then

				_remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_mora;
	
				raise notice 'pago_interes_mora ____________-%', _pago_interes_mora;
				raise notice 'remanente_por_aplicar ____________-%', _remanente_por_aplicar;
			     -- _pago_interes_mora =  _pago_interes_mora  + _pago_interes_mora_aux;

			else        
				_mora_exonerada = _mora_exonerada + _deuda_interes_mora;

				/* comentado por Diego Bertaso
				if _deuda_interes_desembolso > 0  then

					if  _remanente_por_aplicar >= _deuda_interes_desembolso then
						_mora_exonerada = _mora_exonerada + _deuda_interes_mora;
					end if;

				elsif _deuda_interes_corriente > 0 then
					if  _remanente_por_aplicar >= _deuda_interes_corriente then
						_mora_exonerada = _mora_exonerada + _deuda_interes_mora;
					end if;

				end if;  ---> if _deuda_interes_desembolso > 0  then

				*/
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

		 --if _interes_intermediario > 0 then

		--	raise notice 'Interes Intermediario____________%', _interes_intermediario;

		--	_remanente_por_aplicar = _remanente_por_aplicar + _interes_intermediario;

		--	raise notice 'remanente_por_aplicar despues de sumar interes inter.____________%',_remanente_por_aplicar;
		-- end if;

       		 if (_remanente_por_aplicar >= _deuda_interes_corriente) then
	        	_pago_interes_corriente = _deuda_interes_corriente;
	         else
	            _pago_interes_corriente = _remanente_por_aplicar;
	            _pago_incompleto = true;
	         end if;	
	        _remanente_por_aplicar = _remanente_por_aplicar - _pago_interes_corriente;
	        --Inicio Contabilidad
	        --if p_modalidad = 'B' then
	          -- _con_monto_comision_intermediario = _con_monto_comision_intermediario + _plan_pago_cuota.interes_intermediario;
	       -- end if;
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
			   /* 
				Insert de plan_pago_mora debido a cancelación de la totalidad de la mora y por lo
				tanto se actualiza la nueva fecha para calculo de mora
			   */
			
			    insert into plan_pago_mora(plan_pago_cuota_id, tasa_valor, fecha_inicio, fecha_fin, capital,valor) values(_plan_pago_cuota.id, 0, p_fecha_realizacion, p_fecha_realizacion, 0,2);  

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

      /*
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
       */

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

	/* Una vez que la cuota este totalmente pagada se elimina el plan pago mora de la cuota */
	
        delete from plan_pago_mora where plan_pago_cuota_id = _plan_pago_cuota.id;
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

    /*
    ---------------------------------------------------------------------------
    Se incluye la llamada a calcular_mora para recalcular la mora despues
    de haber efectuados todos los pagos
    ---------------------------------------------------------------------------
    */

    _fecha_calculo = p_fecha;
    perform calcular_mora(_prestamo_id, p_fecha, _fecha_calculo, false,1);


    --if _pago_incompleto = false and _remanente_por_aplicar > 0 then
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION ejecutar_pago(integer, character varying[], integer, bpchar, double precision, integer, date, date, character varying, double precision, integer, boolean, boolean, boolean, boolean) OWNER TO cartera;
