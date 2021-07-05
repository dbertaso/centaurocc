CREATE OR REPLACE FUNCTION cancelar_prestamo(p_cliente_id integer, p_prestamo_id integer, p_cheques character varying[], p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_contabilizacion date, p_fecha_realizacion date, p_nombre_analista character varying, p_consultoria_juridica boolean, p_observaciones_analista character varying, p_entidad_financiera_id integer, p_numero_voucher character varying, p_observacion_precancelacion text)
  RETURNS boolean AS
$BODY$

declare
    _prestamo prestamo%rowtype;
    _solicitud solicitud%rowtype;
    _origen_fondo origen_fondo%rowtype;
    _factura_id integer;
    _deuda_total NUMERIC(14, 2) = 0;
    _cur_plan_pago_cuota refcursor;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _factura factura%rowtype;
    _cliente cliente%rowtype;
    _empresa empresa%rowtype;
    _persona persona%rowtype;
    _entidad_financiera entidad_financiera%rowtype;
    _pago_prestamo pago_prestamo%rowtype;
    _prestamo_id integer;
    _pago_interes_diferido NUMERIC(14, 2);
    _pago_causado_no_devengado NUMERIC(14, 2);
    _pago_acumulado_interes_diferido NUMERIC(14, 2);
    _pago_cuota pago_cuota%rowtype;
    _sector_economico_id integer = 0;
    _anio_1 integer = 0;

    _con_intereses_mora NUMERIC(14, 2) = 0;
    _con_capital NUMERIC(14, 2) = 0;
    _con_capital_vencido NUMERIC(14, 2) = 0;
    _con_intereses_por_cobrar NUMERIC(14, 2) = 0;
    _con_intereses_por_cobrar_vencido NUMERIC(14, 2) = 0;
    _con_ingreso_intereses NUMERIC(14, 2) = 0;
    _con_diferencia NUMERIC(14, 2) = 0;
    _con_cur_pago_cuota refcursor;
    _con_pago_cuota record;
    _fuente_recursos_id integer = 0;
    _nombre_cliente character varying = ' ';
    _con_intereses_diferidos numeric(16,2) = 0;

    _con_programa_origen_fondo programa_origen_fondo%rowtype;
    _con_solicitud solicitud%rowtype;

    _con_entidad_financiera entidad_financiera%rowtype;
    _con_cuenta_contable_banco cuenta_contable%rowtype;
    _con_codigo_cuenta_contable_banco integer;

    _remanente_por_aplicar numeric(16,2) = 0;

    _transaccion_id integer;

begin

   -- perform iniciar_transaccion(p_prestamo_id, 1, 'p_pre-cancelar', 'L', 'pre-cancelacion sobre el prestamo'||p_prestamo_id);

    _prestamo_id = p_prestamo_id;
    _transaccion_id = currval('transaccion_id_seq');

    /*
    ----------------------
    Lectura del Préstamo
    ----------------------
    */

    select
    into
          _prestamo *
    from
          prestamo
    where
          id = _prestamo_id;

    if found then

      /*
      --------------------------------------
      Lectura de la solicitud relacionada
      con el préstamo
      --------------------------------------
      */

      select
      into
             _solicitud *
      from
             solicitud
      where
             solicitud.id = _prestamo.solicitud_id;

      if found then

        /*
        ----------------------------------------
        Seleccion del origen de fondo asignado
        a la solicitud
        ----------------------------------------
        */

        select
        into
              _origen_fondo *
        from
              origen_fondo
        where
              origen_fondo.id = _solicitud.origen_fondo_id;

        if found then

          /*
          -----------------------------------------------
          Si el origen de fondo existe se le asigna la
          fuente de recursos relacionada al origen del
          fondo
          -----------------------------------------------
          */

          _fuente_recursos_id = _origen_fondo.banco_origen;

        end if;

      end if;

      /*
      -------------------------------------------
      Búsqueda del sector económico del cliente
      -------------------------------------------
      */

        select
        into
              _cliente *
        from
              cliente
        where
              cliente.id = _prestamo.cliente_id;

        if found then

          if _cliente.type = 'ClienteEmpresa' then

            select
            into
                  _empresa *
            from
                  empresa
            where
                  empresa.id = _cliente.empresa_id;

            _sector_economico_id := _empresa.sector_economico_id;
            _nombre_cliente := _empresa.nombre;

         else

            select
            into
                  _persona *
            from
                  persona
            where
                  persona.id = _cliente.persona_id;

            _sector_economico_id := _persona.sector_economico_id;
            _nombre_cliente := _persona.primer_apellido || ' ' || _persona.primer_nombre;

         end if;

       end if;

     end if;

    /*
    -------------------------------
    Lectura de entidad_financiera
    -------------------------------
    */

    select
    into
           _entidad_financiera *
    from
           entidad_financiera
    where
           id = p_entidad_financiera_id;

    _deuda_total = _deuda_total + _prestamo.deuda;
    _remanente_por_aplicar = _prestamo.remanente_por_aplicar;


    /*
    ---------------------------------
    Comienza proceso de cancelación
    ---------------------------------
    */

    if cast(_deuda_total as float) = cast(p_monto as float) then

      _factura_id = ejecutar_pago_cancelacion(
                                              p_cliente_id,
                                              p_cheques,
	                                            _prestamo_id,
	                                            p_modalidad,
	                                            p_monto+100,
	                                            p_oficina_id,
	                                            p_fecha_realizacion,
	                                            p_fecha_contabilizacion,
                                              p_numero_voucher,
                                              0,
                                              p_entidad_financiera_id,
                                              false,
                                              true,
                                              true,
                                              false,
                                              p_consultoria_juridica,
                                              p_observaciones_analista,
                                              p_nombre_analista);

        --p_cliente_id integer, p_cheques character varying[], p_prestamo_id integer, p_modalidad character, p_monto double precision, p_oficina_id integer, p_fecha_realizacion date, p_fecha date, p_numero_voucher character varying, p_monto_efectivo double precision, p_entidad_financiera_id integer, p_proceso_nocturno boolean, p_cancelacion_prestamo boolean, p_hay_cheques boolean, p_exonerar_mora boolean, p_consultoria_juridica boolean, p_observaciones_analista character varying, p_analista_nombre_completo character varying

        /*
        -----------------------------------------
        Cambio de tipo de factura a Cancelación
        -----------------------------------------
        */

	      update
               factura
        set
               tipo = 'C',
               monto = monto - 100
        where
               id =  _factura_id;

        /*
        --------------------
        Lectura de factura
        --------------------
        */

	      select
        into
               _factura *
        from
               factura
        where
               id = _factura_id;

	      --for i in array_lower(_prestamos,1) .. array_upper(_prestamos,1) loop
         --  _prestamo_id = cast(_prestamos[i][1] as integer);

        _pago_acumulado_interes_diferido = 0;
        _pago_causado_no_devengado = 0;

        /*
	      --------------------------------------------------------------
        Creación de cursor de cuotas con intereses diferidos en cero
        y no exigibles
        --------------------------------------------------------------
        */

	      open
             _cur_plan_pago_cuota
	      for
             select
                     *
             from
                     plan_pago_cuota
                                 inner join plan_pago on (plan_pago_cuota.plan_pago_id = plan_pago.id)

	           where
                     prestamo_id          = _prestamo_id and
                     estatus_pago        <> 'T'          and
                     interes_diferido     = 0            and
                     plan_pago.activo     = true         and
                     plan_pago.proyeccion = false        and
                     tipo_cuota           = 'C'
						 order by
                     numero;

         /*
         ---------------------------------------------------
         Recorrido del cursor de cuotas con intereses dife-
         ridos en cero
         ---------------------------------------------------
         */

         loop

           fetch
                 _cur_plan_pago_cuota
           INTO
                  _plan_pago_cuota;
			     exit when not found;


           /*
		       -----------------------------------------------
           Actualiza el pago de interes diferido en la
           cuota
           -----------------------------------------------
           */

		       update
                  plan_pago_cuota
           set
		              estatus_pago          = 'T'

		       where
                  id = _plan_pago_cuota.id;



	       end loop; --> Fin Recorrido del cursor de cuotas con intereses diferidos en cero

         close _cur_plan_pago_cuota;
        /*
	      --------------------------------------------------------------
        Creación de cursor de cuotas con intereses diferidos impagos
        --------------------------------------------------------------
        */

	      open
             _cur_plan_pago_cuota
	      for
             select
                     *
             from
                     plan_pago_cuota
                                 inner join plan_pago on (plan_pago_cuota.plan_pago_id = plan_pago.id)

	           where
                     prestamo_id          = _prestamo_id and
                     estatus_pago        <> 'T'          and
                     interes_diferido     > 0            and
                     plan_pago.activo     = true         and
                     plan_pago.proyeccion = false        and
                     tipo_cuota           = 'C'
						 order by
                     numero;

         /*
         ---------------------------------------------------
         Lectura de pago de prestamo relacionado con la
         factura y el prestamo
         ---------------------------------------------------
         */

	       select
         into
                _pago_prestamo *
         from
                pago_prestamo
	       where
                pago_cliente_id = _factura.pago_cliente_id and
                prestamo_id     = _prestamo_id;

         /*
         ---------------------------------------------------
         Recorrido del cursor de cuotas con intereses dife-
         ridos impagos
         ---------------------------------------------------
         */

         loop

           fetch
                 _cur_plan_pago_cuota
           INTO
                  _plan_pago_cuota;
			     exit when not found;

			     _pago_interes_diferido = 0;

           /*
		       -----------------------------------------------
           Actualiza el pago de interes diferido en la
           cuota
           -----------------------------------------------
           */

		       update
                  plan_pago_cuota
           set
		              pago_interes_diferido = interes_diferido,
		              estatus_pago          = 'T'

		       where
                  id = _plan_pago_cuota.id;

           /*
           ---------------------------------------------
           Totalización de intereses diferidos pagados
           ---------------------------------------------
           */

		       select
           into
                  _pago_interes_diferido pago_interes_diferido
		       from
		              plan_pago_cuota
		       where
		              id                              = _plan_pago_cuota.id;
		             _pago_acumulado_interes_diferido = _pago_acumulado_interes_diferido + _pago_interes_diferido;

           /*
		       ------------------------------------------------
           Actualizacion en pago_cuota del monto de inte-
           res diferido pagado
           ------------------------------------------------
           */

		       insert
           into
                     pago_cuota
		                           (plan_pago_cuota_id,
                                pago_prestamo_id,
			                          monto,
                                interes_diferido)
			               values
			                         (_plan_pago_cuota.id,
                                _pago_prestamo.id,
                                _pago_interes_diferido,
                                _pago_interes_diferido);

	       end loop; --> Fin Recorrido del cursor de cuotas con intereses diferidos impagos

         close _cur_plan_pago_cuota;
        /*
        ------------------------------------------
        Proceso de pago del causado no devengado
        ------------------------------------------
        */

        select
        into
               _plan_pago_cuota *
        from
               plan_pago_cuota
                              inner join plan_pago
                                         on (plan_pago_cuota.plan_pago_id = plan_pago.id)
        where
               prestamo_id                          = _prestamo_id and
               plan_pago.activo                     = true         and
               plan_pago.proyeccion                 = false        and
               plan_pago_cuota.causado_no_devengado > 0;

        _pago_causado_no_devengado = _plan_pago_cuota.causado_no_devengado;

        if _pago_causado_no_devengado > 0 then

          /*
          ----------------------------------------
          Selección del registro de pago_cuota
          coincidente con el plan_pago_cuota
          ----------------------------------------
          */

          select
          into
                 _pago_cuota *
          from
                 pago_cuota
          where
                 plan_pago_cuota_id = _plan_pago_cuota.id;

          if found then

            /*
            ------------------------------------------
            Actualización del registro de pago_cuota
            coincidente con el plan_pago_cuota
            ------------------------------------------
            */

            update
                   pago_cuota
            set
                   monto             = monto + _pago_causado_no_devengado,
                   interes_corriente = _pago_causado_no_devengado
            where
                   plan_pago_cuota_id = _plan_pago_cuota.id;
          else

            /*
            ------------------------------------------
            Si el pago_cuota no existe se inserta
            ------------------------------------------
            */
	          insert
            into
                   pago_cuota
                              (plan_pago_cuota_id,
                               pago_prestamo_id,
	                             monto,
                               interes_corriente)
	                 values
                              (_plan_pago_cuota.id,
                               _pago_prestamo.id,
                               _pago_causado_no_devengado,
	                             _plan_pago_cuota.causado_no_devengado);

          end if;   ----> if _pago_causado_no_devengado > 0 then

          /*
          -------------------------------------------------
          Actualización del pago de interes corriente en
          la cuota correspondiente
          -------------------------------------------------
          */

           update
                  plan_pago_cuota
           set
                  pago_interes_corriente = pago_interes_corriente + _pago_causado_no_devengado,
                  estatus_pago           = 'T'
           where
                  id = _plan_pago_cuota.id;

	   end if;

	   update
            pago_prestamo
     set
	          interes_diferido = interes_diferido + _pago_acumulado_interes_diferido,
    	      monto            = monto + interes_diferido + _pago_causado_no_devengado,
    	      interes_causado  = _pago_causado_no_devengado,
    	      saldo_insoluto  = _prestamo.saldo_insoluto,
            observacion_precancelacion = p_observacion_precancelacion
	   where
            id = _pago_prestamo.id;


     /*
     -----------------------------------------------------
     Apertura del cursor de cuotas total o parcialmente
     pagadas
     -----------------------------------------------------
     */

	   open
          _cur_plan_pago_cuota
     for
          select
                 *
          from
                  plan_pago_cuota
                           inner join plan_pago
	                                           on (plan_pago_cuota.plan_pago_id = plan_pago.id)
          where
                   prestamo_id          = _prestamo_id and
                   estatus_pago         in('T', 'P')    and
                   plan_pago.activo     = true         and
                   plan_pago.proyeccion = false
	        order by
                   plan_pago_cuota.id desc limit 1;

      /*
      -----------------------------------------------------
      Recorrido del cursor de cuotas total o parcialmente
      pagadas
      -----------------------------------------------------
      */

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

        --Se incluyo en el cursor el campo de intereses diferidos para poder contabilizarlos
        --Diego Bertaso

	    open _con_cur_pago_cuota for select
	       plan_pago_cuota.numero as numero,
	       plan_pago_cuota.dias_mora as dias_mora,
	       pago_cuota.interes_mora as pago_interes_mora,
	       pago_cuota.capital as pago_capital,
	       plan_pago_cuota.intereses_por_cobrar_al_30 as intereses_por_cobrar_al_30,
	       pago_cuota.interes_corriente as pago_interes_corriente,
	       pago_cuota.interes_diferido as pago_interes_diferido
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
	           _con_intereses_diferidos = _con_intereses_diferidos + _con_pago_cuota.pago_interes_diferido;
	           --Se incluyo la instruccion + _con_pago_cuota.pago_interes_diferido en la siguiente sentencia
	           --Diego Bertaso
			   _con_ingreso_intereses = _con_ingreso_intereses + (_con_pago_cuota.pago_interes_corriente - _con_pago_cuota.intereses_por_cobrar_al_30);
	       else
	           _con_intereses_mora =  _con_intereses_mora + _con_pago_cuota.pago_interes_mora;
	           _con_capital =  _con_capital + _con_pago_cuota.pago_capital;
	           _con_intereses_por_cobrar_vencido = _con_intereses_por_cobrar_vencido + _con_pago_cuota.intereses_por_cobrar_al_30;
             _con_intereses_diferidos = _con_intereses_diferidos + _con_pago_cuota.pago_interes_diferido;
	           --Se incluyo la instruccion + _con_pago_cuota.pago_interes_diferido en la siguiente sentencia
	           --Diego Bertaso
	           _con_ingreso_intereses = _con_ingreso_intereses + (_con_pago_cuota.pago_interes_corriente - _con_pago_cuota.intereses_por_cobrar_al_30);
	       end if;

	    end loop;

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


            /*
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
            */

      _anio_1 = extract (year from p_fecha_realizacion);

        _con_capital = _con_capital + _prestamo.saldo_insoluto;

        RAISE NOTICE '(cancelacion) MONTO CAPITAL CUOTA %', _con_capital;
        RAISE NOTICE '(cancelacion) MONTO INGRESO INTERESES %', _con_ingreso_intereses;
        RAISE NOTICE '(cancelacion) MONTO INTERES DIFERIDO %', _pago_acumulado_interes_diferido;
        RAISE NOTICE '(cancelacion) MONTO INGRESO MORA %', _con_intereses_mora;
        RAISE NOTICE '(cancelacion) SALDO INSOLUTO %', _prestamo.saldo_insoluto;

      perform registro_contable('CANCELACION PRESTAMO',
                                cast(p_modalidad as varchar),
                                _fuente_recursos_id,
                                _sector_economico_id,
                                _prestamo.estatus,
                                p_entidad_financiera_id,
                                cast(p_monto as float),
                                _con_ingreso_intereses,
                                _con_intereses_por_cobrar,
                                _remanente_por_aplicar,
                                _con_capital,
                                _con_intereses_mora,
                                0,
                                0,
                                _con_intereses_diferidos,
                                0,
                                p_fecha_contabilizacion,
                                p_fecha_realizacion,
                                _prestamo.id,
                                _factura_id,
                                _anio_1,
                                p_numero_voucher,
                                _entidad_financiera.nombre,
                                _nombre_cliente,
                                'Cancelación Préstamo',
                                cast(_prestamo.numero as character varying),
                                _prestamo.reestructurado,
                                _transaccion_id);

      /*
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

      */


	   -- Actualiza el prestamo
	   update prestamo set
	     estatus = 'C',
	     saldo_insoluto = 0,
	     interes_vencido = 0,
	     dias_mora = 0,
	     monto_mora = 0,
	     causado_no_devengado = 0,
	     interes_diferido_vencido = 0,
	     interes_diferido_por_vencer = 0,
	     remanente_por_aplicar = 0,
	     cantidad_cuotas_vencidas = 0,
	     monto_cuotas_vencidas = 0,
	     deuda = 0,
	     exigible = 0,
	     capital_vencido = 0
	     where id = _prestamo_id;
	--end loop;
	return true;
  else
    raise exception 'el monto de la deuda es diferente al monto que se desea pagar';
  end if;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;