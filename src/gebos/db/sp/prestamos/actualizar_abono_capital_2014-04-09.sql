CREATE OR REPLACE FUNCTION actualizar_abono_capital(p_prestamo_id integer, 
                                                    p_fecha date) RETURNS boolean AS
$body$
declare

   _plan_pago plan_pago%rowtype;
   _prestamo prestamo%rowtype;
   _plan_pago_cuota plan_pago_cuota%rowtype;
   _plan_pago_cuota_ultima plan_pago_cuota%rowtype;
   _solicitud solicitud%rowtype;
   _cliente cliente%rowtype;
   _persona persona%rowtype;
   _empresa empresa%rowtype;

   _remanente_por_aplicar decimal(14,2);
   _abono_capital decimal(14,2);
   _fecha_inicio date;
   _monto_insoluto decimal(16,2);
   _nombre_cliente character varying;
   _anio_1 integer = 0;
   _factura_id integer = 0;
   _numero_voucher character varying;
   _fuente_recursos_id integer = 0;


begin

  /*
  --------------------------------------------------------------
  Si el remanente por aplicar es mayor que cero se procede
  a la verificación de abono a capital/cancelación de préstamo
  y si aplica la generación de una nueva tabla de amortización
  --------------------------------------------------------------
  */

  select into
          _prestamo *
  from
          prestamo
  where
          prestamo.id = p_prestamo_id;

  if not found then

    raise notice 'No existe el prestamo Número   %', _prestamo.numero;
    return false;

    if _prestamo.banco_origen = 'FONDAS' then
      _fuente_recursos_id = 1;
    end if;
    
    if _prestamo.banco_origen = 'AGROVENEZUELA' then
      _fuente_recursos_id = 2;
    end if;
    
    if _prestamo.banco_origen = 'FONDAFA' then
      _fuente_recursos_id = 3;
    end if;

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

        _nombre_cliente := _empresa.nombre;

      else

        select
        into
             _persona *
        from
             persona
        where
             persona.id = _cliente.persona_id;

        _nombre_cliente := _persona.primer_apellido || ' ' || _persona.primer_nombre;

      end if;

    end if;

    select
    into
          _factura_id id
    from
          factura 
    where
          prestamo_id = prestamo.id
    order by
          fecha desc
    limit 1;

  end if;

  select
  into
        _solicitud *
  from

        solicitud
  where
        id = _prestamo.solicitud_id;

  if not found then
    raise notice 'No existe la solicitud asociada al prestamo Número %', _prestamo.numero;
    return false;


  end if;

  select into
        _plan_pago *
  from
        plan_pago
  where
        plan_pago.prestamo_id = _prestamo.id and
        activo = true;

  if not found then

    raise notice 'No existe plan_pago del prestamo Nro.   %', _prestamo.numero;
    return false;
  end if;

  select into
         _plan_pago_cuota_ultima *
  from
         plan_pago_cuota
  where
         plan_pago_cuota.plan_pago_id = _plan_pago.id and
         plan_pago_cuota.tipo_cuota = 'C'  and
         plan_pago_cuota.estatus_pago = 'T'
  order by
         fecha desc
  limit 1;

  if found then

    _fecha_inicio = _plan_pago_cuota_ultima.fecha;

  end if;

  /*
  -------------------------------------------------------------
  Si no tiene cuotas pagadas en el périodo de amortizacion
  se toma como referencia la fecha de la ultima cuota del
  periodo de gracia
  -------------------------------------------------------------
  */

  if not found then

    select into
         _plan_pago_cuota_ultima *
    from
         plan_pago_cuota
    where
         plan_pago_cuota.plan_pago_id = _plan_pago.id and
         plan_pago_cuota.estatus_pago = 'T'
    order by
         fecha desc
    limit 1;

    if found then

      _fecha_inicio = _plan_pago_cuota_ultima.fecha;

    else
      _fecha_inicio = _prestamo.fecha_liquidacion;

    end if;

  end if;

  raise notice 'MONTO ABONO ===================================> %', _prestamo.abono_capital;
  if _prestamo.abono_capital > 0 then
 
    update
          prestamo
    set
          capital_pagado = capital_pagado + _prestamo.abono_capital
    where
          id = _prestamo.id;

  end if;
  
  if _prestamo.abono_capital > 0 and
     _prestamo.frecuencia_pago > 0 then


    raise notice 'FECHA INICIO ===================================> %', _fecha_inicio;

    perform generar_plan_pago_evento(false, _prestamo.id, _fecha_inicio,
                                     false, 0, false, 0, true, _prestamo.abono_capital, 0, 0, 0, 0, 0, 0);

  end if;

  /*
  -------------------------------------------------
  Si el financiamiento es de pago único se genera
  un plan_pago como si fuera inicial inactivando
  el anterior
  --------------------------------------------------
  */

  if _prestamo.abono_capital > 0 and
     _prestamo.frecuencia_pago = 0 then

     /*
     -------------------------
     Cálculo del nuevo saldo
     -------------------------
     */

     _remanente_por_aplicar = 0;

     if _prestamo.abono_capital < _prestamo.saldo_insoluto then
        _monto_insoluto = _prestamo.saldo_insoluto - _prestamo.abono_capital;
     else
        _remanente_por_aplicar = _prestamo.abono_capital - _prestamo.saldo_insoluto;
     end if;


     if _remanente_por_aplicar = 0 then

      update
            plan_pago
      set
            activo = false
      where
            id = _plan_pago.id;

      /*
      ------------------------------------------------
      Inactivación de plan pago actual para proceder
      a la generación del nuevo
      ------------------------------------------------
      */

      perform generar_plan_pago

        (

          false,
          _prestamo.formula_id,
          _prestamo.id,
          0,
          0,
          'Z',
          0,
          0,
          _fecha_inicio,
          _monto_insoluto,
          _prestamo.plazo,
          _prestamo.plazo,
          _prestamo.tasa_inicial,
          _prestamo.meses_muertos,
          _prestamo.meses_gracia,
          0,
          false,
          _prestamo.tasa_inicial,
          _prestamo.plazo,
          0,
          true,
          _fecha_inicio,
          _monto_insoluto,
          0,
          0,
          0,
          0

        );

        /*
        --------------------------------------------
        Lectura del nuevo plan pago para actualizar
        el monto del abono en la nueva cuota
        --------------------------------------------
        */

        select
        into
                _plan_pago *
        from
                plan_pago
        where
                plan_pago.prestamo_id = _prestamo.id and
                activo = true;

        if found then

          /*
          ------------------------------------
          Actualizazión del motivo del nuevo
          plan_pago
          ------------------------------------
          */

          update
                plan_pago
          set
                motivo_evento = 'A'
          where
                id = _plan_pago.id;

          select
          into
                   _plan_pago_cuota *
          from
                   plan_pago_cuota
          where
                   plan_pago_cuota.plan_pago_id = _plan_pago.id
          order by
                   fecha desc
          limit 1;

          if found then

            update
                    plan_pago_cuota
            set
                    monto_abono = monto_abono + _prestamo.abono_capital,
                    abono_extraordinario = true
            where
                    id = _plan_pago_cuota.id;

          end if;

        end if;

      end if;  -- Fin del if _remanente_por_aplicar = 0;

      if _remanente_por_aplicar > 0 then

        update
                plan_pago_cuota
        set
                monto_abono = monto_abono + _prestamo.abono_capital,
                abono_extraordinario = true
        where
                id = _plan_pago_cuota.id;

        update
                prestamo
        set
                saldo_insoluto = 0,
                deuda = 0,
                exigible = 0,
                estatus = 'C'
        where
                id = _prestamo.id;

      end if;

  end if;  -->  if _prestamo.abono_capital > 0 and _prestamo.frecuencia_pago = 0 then

  /*
  -------------------------------------------------
  Proceso de contabilización del abono a capital
  -------------------------------------------------
  */

  _anio_1 = EXTRACT(YEAR from p_fecha);
  _numero_voucher = CAST(_factura_id as varchar) || '-' || CAST(p_fecha as varchar);

  perform registro_contable(35,
      'X',
      _fuente_recursos_id,
      _solicitud.programa_id,
      _prestamo.estatus,
      0,
      0,
      0,
      0,
      _prestamo.abono_capital,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      p_fecha,
      p_fecha,
      _prestamo.id,
      0,
      _anio_1,
      _numero_voucher,
      ' ',
      _nombre_cliente,
      'ABONO A CAPITAL',
      cast(_prestamo.numero as character varying),
      _prestamo.reestructurado,
      0);

  /*
  --------------------------------------------
  Actualización de abono_capital en prestamo
  --------------------------------------------
  */

  update
        prestamo
  set
        abono_capital = 0
  where
        prestamo.id = _prestamo.id;



  perform calcular_prestamo(_prestamo.id, p_fecha, false);

  --perform calcular_montos_recuperados(_prestamo.id,false);

  return true;

end;
$body$
LANGUAGE 'plpgsql' VOLATILE;

