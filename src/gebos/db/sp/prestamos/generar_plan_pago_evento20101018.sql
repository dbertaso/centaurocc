-- Function: generar_plan_pago_evento(boolean, integer, date, boolean, double precision, boolean, double precision, boolean, double precision, integer, integer)

-- DROP FUNCTION generar_plan_pago_evento(boolean, integer, date, boolean, double precision, boolean, double precision, boolean, double precision, integer, integer);

CREATE OR REPLACE FUNCTION generar_plan_pago_evento(p_proyectado boolean,
                                                    p_prestamo_id integer,
                                                    p_fecha_evento date,
                                                    p_tiene_desembolso boolean,
                                                    p_monto_desembolso double precision,
                                                    p_tiene_tasa boolean,
                                                    p_valor_tasa double precision,
                                                    p_tiene_abono boolean,
                                                    p_monto_abono double precision,
                                                    p_desembolso_id integer,
                                                    p_extension_meses_muertos integer,
                                                    p_monto_banco double precision,
                                                    p_monto_sras double precision,
                                                    p_monto_insumos double precision,
                                                    p_monto_gasto_total double precision)
  RETURNS boolean AS
$BODY$

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
  _estatus_pago character(1);

  /*
  ------------------------------------
  Variables para control de diferidos
  ------------------------------------
  */

  _monto_diferido_gracia float;
  _monto_diferido_amortizacion float;


  begin

    if p_proyectado = true  then
      delete from plan_pago_cuota where plan_pago_id in (select id from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id);
      delete from plan_pago where proyeccion = true and activo = false and prestamo_id = p_prestamo_id;
    end if;

    --raise notice 'PROYECTADO________________________________________________________________%',p_proyectado;
    --raise notice 'MONTO_ABONO_______________________________________________________________%',p_monto_abono;
    --raise notice 'PASO 1________________________';

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

    --raise notice 'PASO 2________________________';

    select
    into
          _prestamo *
    from
          prestamo
    where
          id = p_prestamo_id;

    -- Inicio Contabilidad

    select
    into
           _con_solicitud *
    from
           solicitud
    where
           id = _prestamo.solicitud_id;

    select
    into
           _con_programa_origen_fondo *
    from
           programa_origen_fondo
    where
           programa_id = _con_solicitud.programa_id and
           origen_fondo_id = _con_solicitud.origen_fondo_id;

    -- Fin Contabilidad

    --raise notice 'PASO 3________________________';

    select
    into
           _plan_pago *
    from
           plan_pago
    where
           prestamo_id = p_prestamo_id and
           activo      = true          and
           proyeccion  = false;

   /*
   ------------------------------------------------------
   Antes de clonar el plan pago se buscan las alicuotas
   de interes diferido para las cuotas de gracia y las
   cuotas de amortización
   ------------------------------------------------------
   */


   -- Alicuota de interes diferido durante el periodo de gracia

   begin

     select
     into
            _plan_pago_cuota *
     from
            plan_pago_cuota
     where
            plan_pago_cuota.plan_pago_id = _plan_pago.id and
            plan_pago_cuota.tipo_cuota = 'G'
     order by
            fecha desc
     limit 1;


     if found then

        _monto_diferido_gracia = _plan_pago_cuota.interes_diferido;

        raise notice 'Interes Diferido Gracia =======> %', _monto_diferido_gracia;
      else
        _monto_diferido_gracia = 0;
      end if;
    end;

    -- Alicuota de interes diferido durante el periodo de amortización

    begin

      select
      into
            _plan_pago_cuota *
      from
            plan_pago_cuota
      where
            plan_pago_cuota.plan_pago_id = _plan_pago.id and
            plan_pago_cuota.tipo_cuota = 'C'
     order by
            fecha desc
     limit 1;


      if found then

        _monto_diferido_amortizacion = _plan_pago_cuota.interes_diferido;
        raise notice 'Interes Diferido Amortización =======> %', _monto_diferido_amortizacion;
      else
        _monto_diferido_amortizacion = 0;
      end if;

    end;



    -- Busca la fecha de la cuota hasta donde se va clonar o mejor dicho hasta donde se mantiene intacta

    select
    into
           _plan_pago_cuota *
    from
           plan_pago_cuota
    where
           fecha >= p_fecha_evento and
           plan_pago_id = _plan_pago.id
    order by
           fecha asc
    limit 1;

    _fecha_focal = _plan_pago_cuota.fecha;

    raise notice 'PASO 4________________________';

    raise notice 'prestamo_id________________________%',p_prestamo_id;
    raise notice 'plan_pago_id________________________%',_plan_pago.id;
    raise notice 'fecha_inicio________________________%',_plan_pago.fecha_inicio;
    raise notice 'prestamo_id_____%',p_prestamo_id;
    raise notice 'fecha_focal_____%',_fecha_focal;
    raise notice 'fecha_evento_____%',p_fecha_evento;

    -- Recupera las cuotas a clonar

    open
          _cur_plan_pago_cuota
    for
          select
                *
          from
                plan_pago_cuota
          where
                plan_pago_id =  _plan_pago.id and
                fecha        <= _fecha_focal
          order by
                fecha asc;

    if _valor_tasa = 0 then
      _valor_tasa = _plan_pago.tasa;
    end if;

    -- Clona el plan_pago

    insert
    into
          plan_pago (
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
                      motivo_evento
                    )

          values
                    (
                      _plan_pago.fecha_inicio,
                      _plan_pago.fecha_fin,
                      _plan_pago.prestamo_id,
                      true,
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
                      _motivo_evento
                    );

    _plan_pago_id = currval('plan_pago_id_seq');

    _meses_muertos = _plan_pago.meses_muertos + p_extension_meses_muertos;
    _meses_gracia = _plan_pago.meses_gracia;
    _plazo = _plan_pago.plazo;

    -- Actualiza el plan_pago anterior

    if p_proyectado = false then

      update
            plan_pago
      set
            activo = false
      where
            id = _plan_pago.id;
    end if;

     -- Clona las cuotas del plan_pago

    loop

      fetch
           _cur_plan_pago_cuota
      INTO
           _plan_pago_cuota;
      exit when not found;

      if _plan_pago_cuota.tipo_cuota = 'M' then

        _meses_muertos = _meses_muertos - 1;
      elsif
        _plan_pago_cuota.tipo_cuota = 'G' then
        _meses_gracia = _meses_gracia - _prestamo.frecuencia_pago;
      else
        _plazo = _plazo - _prestamo.frecuencia_pago;
      end if;

      insert
      into
          plan_pago_cuota (
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
                    fecha_ultima_mora
                  )
          values
                  (

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
                    _plan_pago_cuota.fecha_ultima_mora
                  );

    end loop;

    _plan_pago_cuota_id = currval('plan_pago_cuota_id_seq');

    if p_tiene_desembolso then

      update
              plan_pago_cuota
      set
              monto_desembolso = monto_desembolso + p_monto_desembolso,
              desembolso = true
      where
              id = _plan_pago_cuota_id;
    end if;

    if p_tiene_abono then

      update
              plan_pago_cuota
      set
              monto_abono = monto_abono + p_monto_abono,
              abono_extraordinario = true
      where
              id = _plan_pago_cuota_id;
    end if;

    if p_tiene_tasa then

      update
              plan_pago_cuota
      set
              cambio_tasa = true
      where
              id = _plan_pago_cuota_id;
    end if;

    select
    into
          _plan_pago_cuota *
    from
          plan_pago_cuota
    where
          id = _plan_pago_cuota_id;

    --if p_tiene_tasa then
    --  _monto_insoluto = _plan_pago_cuota.saldo_insoluto;
    --end if;


    --if p_tiene_desembolso then
    --_monto_insoluto = _plan_pago_cuota.saldo_insoluto + p_monto_desembolso;
    --end if;

    --if p_tiene_abono then
    --_monto_insoluto = _plan_pago_cuota.saldo_insoluto - p_monto_abono;
    --end if;


    _monto_insoluto = (_plan_pago_cuota.saldo_insoluto + _plan_pago_cuota.monto_desembolso)- _plan_pago_cuota.monto_abono;


    --raise notice 'numero_cuota%',_plan_pago_cuota.numero;
    --raise notice 'saldo_insoluto_cuota%',_plan_pago_cuota.saldo_insoluto;
    --raise notice 'monto_abono%',p_monto_abono;
    --raise notice '**************************************************monto_insoluto%',_monto_insoluto;
    --raise notice 'MESES_MUERTOS__________________________%', _meses_muertos;
    raise notice 'Meses de Gracia ------------------------> % ', _meses_gracia;

    perform generar_plan_pago

    (

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
      _monto_diferido_amortizacion,
      _monto_diferido_gracia,
      p_monto_banco,
      p_monto_sras,
      p_monto_insumos,
      p_monto_gasto_total

    );


    -- Actualiza la tasa del prestamo si el evento es un cambio de tasa

    if p_tiene_tasa = true  and
       p_proyectado = false then

       update
              prestamo
       set
              tasa_vigente = p_valor_tasa
       where
              id = p_prestamo_id;

    end if;


    --raise exception 'error';


    return true;

  end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

