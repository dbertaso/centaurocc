-- Function: generar_plan_pago(boolean, integer, integer, integer, integer, character, double precision, double precision, date, double precision, integer, integer, double precision, integer, integer, integer, boolean, double precision, integer, integer, boolean, date, double precision, numeric)

-- DROP FUNCTION generar_plan_pago(boolean, integer, integer, integer, integer, character, double precision, double precision, date, double precision, integer, integer, double precision, integer, integer, integer, boolean, double precision, integer, integer, boolean, date, double precision, numeric);

CREATE OR REPLACE FUNCTION generar_plan_pago(p_proyectado boolean,
                                             p_formula_id integer,
                                             p_prestamo_id integer,
                                             p_plan_pago_id integer,
                                             p_numero_cuota_inicial integer,
                                             p_tipo_cuota_inicial character,
                                             p_interes_acumulado_inicial double precision,
                                             p_amortizado_acumulado_inicial double precision,
                                             p_fecha_liquidacion date,
                                             p_monto double precision,
                                             p_plazo integer,
                                             p_frecuencia_pago integer,
                                             p_tasa_valor double precision,
                                             p_meses_muertos integer,
                                             p_meses_gracia integer,
                                             p_meses_diferidos integer,
                                             p_exonerar_intereses_diferidos boolean,
                                             p_tasa_valor_gracia double precision,
                                             p_frecuencia_pago_gracia integer,
                                             p_desembolso_id integer,
                                             p_inicial boolean,
                                             p_fecha_evento date,
                                             p_monto_desembolso double precision,
                                             p_interes_diferido double precision,
                                             p_interes_diferido_gracia double precision,
                                             p_monto_banco double precision,
                                             p_monto_sras double precision,
                                             p_monto_insumos double precision)
  RETURNS boolean AS
$BODY$

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

  _plan_pago_cuota_dif refcursor;

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

  _cuotas_gracia_diferidas integer;


  _cur_plan_pago_cuota refcursor;

  _tasa_historico tasa_historico%rowtype;

  _desembolso desembolso%rowtype;

  _se_calculo_desembolso bool = false;

  _interes_cuota_aux float;
  _interes_cuota_dif float;
  _interes_diferido float;

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

  _p_frecuencia_pago integer = 0;

  --Contabilidad

   _con_cur_desembolso_pago refcursor;

   --_con_desembolso_pago desembolso_pago%rowtype;

   _con_factura_id integer;

   _con_programa_origen_fondo programa_origen_fondo%rowtype;

   _con_solicitud solicitud%rowtype;



   _con_entidad_financiera entidad_financiera%rowtype;

   _con_cuenta_contable_banco cuenta_contable%rowtype;

   _con_codigo_cuenta_contable_banco integer;

    _total_interes_gracia_diferido decimal(16,2) = 0;
     _estatus_pago character(1);


begin



  select into _parametro_general * from parametro_general limit 1;
  select into _prestamo * from prestamo where id = p_prestamo_id;

   --raise notice '_fecha_liquidacion -----> %',p_fecha_liquidacion;

  -- Determina el dia de facturaciÃ³n

  _dia = extract(day from p_fecha_liquidacion);

  _mes = extract(month from p_fecha_liquidacion);

  _year = extract(year from p_fecha_liquidacion);



  if _parametro_general.dia_facturacion = 'V' then

      _fecha_inicio = p_fecha_liquidacion;

  end if;

  if _parametro_general.dia_facturacion = 'F' then

      _fecha_inicio = p_fecha_liquidacion;
  end if;

  if _parametro_general.dia_facturacion = 'C' then

    if _dia = 29 or
       _dia = 30 or
       _dia = 31 then

       _mes = _mes + 1;

        --raise notice 'mes -----> %',_mes;

       if _mes = 13 then
          _mes = 01;
          _year = _year + 1;
       end if;

       --raise notice 'year -----> %', _year;

    end if;

    if _dia > _parametro_general.dia_mes_primer_ciclo and _dia <= _parametro_general.dia_mes_segundo_ciclo then

      _dia = _parametro_general.dia_mes_segundo_ciclo;

    else

      _dia = _parametro_general.dia_mes_primer_ciclo;

    end if;

    -- Se actualiza el dia de facturacion en el prestamo

    update prestamo set dia_facturacion = _dia where id = p_prestamo_id and dia_facturacion = 0;
     _fecha_inicio = date (_year || '-' || _mes || '-' || _dia);

  end if;



   --raise notice 'fecha_inicio -----> %',_fecha_inicio;

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


  if _parametro_general.dia_facturacion = 'V' then

     _fecha_fin = agregar_dias(_fecha_inicio, ((p_meses_muertos + p_meses_gracia + p_plazo) * 30));
  else
     _fecha_fin = agregar_meses(_fecha_inicio, (p_meses_muertos + p_meses_gracia + p_plazo));
  end if;



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


    if _parametro_general.dia_facturacion = 'V' then
       _fecha_cuota = agregar_dias(_fecha_cuota,30);
    else
        _fecha_cuota = agregar_meses(_fecha_cuota, 1);
    end if;

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

      tasa_nominal_anual,estatus_pago,fecha_ultima_mora)

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

      'M',0,0,'X',_fecha_cuota);


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

  raise notice 'Meses de gracia pasados por parámetro % ', p_meses_gracia;
  raise notice 'Cantidad de cuotas de gracia % ', _cantidad_cuotas;
  raise notice 'Número cuota de arranque % ', _numero_cuota;

  _cuotas_gracia_diferidas = 0;
  _cuotas_gracia_diferidas = p_meses_gracia / p_frecuencia_pago;

  for i in 1.._cantidad_cuotas loop

    _fecha_365 = _fecha_cuota;

    if _prestamo.base_calculo_intereses = 365 then

        _fecha_365 = agregar_meses(_fecha_365, p_frecuencia_pago);

        _fecha_365_aux = agregar_meses(_fecha_365, -p_frecuencia_pago);

        _dias = (_fecha_365 - _fecha_365_aux);

        _cantidad_dias = _dias;

    end if;



    if _parametro_general.dia_facturacion = 'V' then
        _fecha_cuota = agregar_dias(_fecha_cuota, _cantidad_dias);
    else
        _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    end if;

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

    if _prestamo.tipo_diferimiento = true then

      raise notice 'Entro por programa tipo de diferimiento ===========================> %', _numero_cuota;
      raise notice '===================================================================>';

      _interes_diferido = _interes_cuota;

      _total_interes_gracia_diferido = _total_interes_gracia_diferido + _interes_diferido;

      raise notice 'Interes Gracia =======> %', _interes_cuota;
      raise notice 'Interes Diferido calculado =======> %', _interes_diferido;

      _interes_cuota_dif = _interes_cuota - _interes_diferido;

      if _interes_cuota_dif > 0 then
        _estatus_pago = 'X';
      else
        _interes_cuota_dif = 0;
        _estatus_pago = 'D';
      end if;

     else
        _interes_cuota_dif = _interes_cuota;
        _interes_diferido = 0;
        _estatus_pago = 'X';
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

      tipo_cuota, interes_mora,tasa_nominal_anual,estatus_pago, cantidad_dias, fecha_ultima_mora)

    values(

      _plan_pago_id,

      _fecha_cuota,

      _numero_cuota,

      _interes_cuota_dif,

      0,

      0,

      _interes_cuota_dif,

      0,

      _interes_diferido,

      p_monto,

      _tasa_cuota,

      _interes_desembolso,

      'G',0,p_tasa_valor_gracia, _estatus_pago,_cantidad_dias, _fecha_cuota);

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

  open _plan_pago_cuota_dif for select * from plan_pago_cuota
    where plan_pago_id = _plan_pago_id and tipo_cuota = 'G';

  _total_interes_gracia_diferido = 0;

  loop
    fetch _plan_pago_cuota_dif INTO _row_plan_pago_cuota;
    exit when not found;

    _total_interes_gracia_diferido = _total_interes_gracia_diferido + _row_plan_pago_cuota.interes_diferido;

  end loop;

  close _plan_pago_cuota_dif;

  _interes_cuota_dif = _total_interes_gracia_diferido / p_plazo;

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

      cantidad_dias,
      fecha_ultima_mora)

    values(

      _plan_pago_id,

      current_date,

      0,

      _monto_cuota_aux,

      _monto_cuota - _interes_cuota,

      0,

      _interes_cuota,

      0,

      _interes_cuota_dif,

      _saldo_insoluto,

      _tasa_cuota,

      'C',

      0,

      _interes_desembolso,

      p_tasa_valor,

      'X',

      _cantidad_dias,
      current_date);

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



    if _parametro_general.dia_facturacion = 'V' then
        _fecha_cuota = agregar_dias(_fecha_cuota, _cantidad_dias);
    else
        _fecha_cuota = agregar_meses(_fecha_cuota, p_frecuencia_pago);
    end if;

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
      fecha_ultima_mora = _fecha_cuota,

      numero = _numero_cuota,

      amortizado_acumulado = _amortizado_acumulado,

      --interes_corriente_acumulado = _interes_acumulado,

      saldo_insoluto = _saldo_insoluto

      --cantidad_dias = _cantidad_dias

      where id = _row_plan_pago_cuota.id;



     /*
     -------------------------------------------------------------------
     Se agregó a la compraración de la amortización acumulada
     de la última cuota los montos liquidados por orden de despacho
     y el monto del sras ya que estos también forman parte del capital
     del financiamiento ----> Diego Bertaso ----> 2011-12-19
     --------------------------------------------------------------------
     */

     if i = _cantidad_cuotas and _amortizado_acumulado <> (_prestamo.monto_liquidado + _prestamo.monto_liquidado_insumos + _prestamo.monto_sras_total) then
        update plan_pago_cuota set amortizado_acumulado = (_prestamo.monto_liquidado + _prestamo.monto_liquidado_insumos + _prestamo.monto_sras_total)
          where id = _row_plan_pago_cuota.id;
     end if;

     /*
     --------------------------------------------------------
     Comentado por Diego Bertaso el 2011-12-19 por haber
     substituido estas lineas por las que se encuentran arriba

     if i = _cantidad_cuotas and _amortizado_acumulado <> _prestamo.monto_liquidado then
        update plan_pago_cuota set amortizado_acumulado = _prestamo.monto_liquidado
          where id = _row_plan_pago_cuota.id;
     end if;
     */

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



    --if _prestamo.intermediado = true then

      --_interes_foncrei = _interes_corriente_ajustado * (_prestamo.porcentaje_tasa_foncrei/100);

      --_interes_intermediario = _interes_corriente_ajustado - _interes_foncrei;

    --end if;



     update plan_pago_cuota set

        interes_corriente = _interes_corriente_ajustado,

        interes_corriente_acumulado =  _interes_acumulado

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




   --FUNCION AJUSTE ULTIMA CUOTA SI HAY IMPRECISION
      raise notice '1290a  -----> %', _prestamo.monto_liquidado;
      raise notice '1290b  -----> %', _plan_pago_id;
      raise notice '1290b  -----> %', p_plan_pago_id;
      raise notice '---------- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA %',p_monto;

    --perform fix_ultima_cuota(p_plan_pago_id, _prestamo.monto_liquidado);


    perform calcular_prestamo(p_prestamo_id, _prestamo.fecha_liquidacion, p_proyectado);

    if _inicial = true and p_proyectado = false then

      insert into prestamo_tasa_historico
                  (tasa_cliente, prestamo_id, tasa_id, fecha)
      values
                  (p_tasa_valor, p_prestamo_id, _prestamo.tasa_id, _prestamo.fecha_liquidacion);

      raise notice '---------- ACTUALIZO LA TASA VIGENTE DEL PRESTAMO CON EL VALOR %',p_tasa_valor;

      update prestamo set tasa_vigente = p_tasa_valor where id = p_prestamo_id;

    end if;

    if p_desembolso_id <> 0 then

      select into _desembolso * from desembolso where id = p_desembolso_id;

      insert into factura (numero, monto, fecha, fecha_realizacion, desembolso_id, tipo, prestamo_id, monto_banco, monto_sras, monto_insumos)

        values ((select ultima_factura from parametro_general) + 1, p_monto_desembolso, p_fecha_evento,

        p_fecha_evento, _desembolso.id, 'D', p_prestamo_id, p_monto_banco, p_monto_sras, p_monto_insumos);



      _factura_id = currval('factura_id_seq');



      update parametro_general set ultima_factura = ultima_factura + 1;





       --update desembolso set interes_desembolso = _interes_desembolso_aux where id = _desembolso.id;



      -- Inicio Contabilidad



      select into _con_solicitud * from solicitud

            where id = _prestamo.solicitud_id;



      select into _con_programa_origen_fondo * from programa_origen_fondo

            where programa_id = _con_solicitud.programa_id

            and origen_fondo_id = _con_solicitud.origen_fondo_id;



      --open _con_cur_desembolso_pago for select * from desembolso_pago where desembolso_id = _desembolso.id;

    --loop

      --fetch _con_cur_desembolso_pago INTO _con_desembolso_pago;

      --exit when not found;



      --select into _con_entidad_financiera * from entidad_financiera where id = _con_desembolso_pago.entidad_financiera_id;

        --select into _con_cuenta_contable_banco * from cuenta_contable where id = _con_entidad_financiera.cuenta_contable_id;

        --_con_codigo_cuenta_contable_banco = _con_cuenta_contable_banco.id;



      --perform stc_desembolso(

      --   _con_desembolso_pago.monto,

      --   _con_codigo_cuenta_contable_banco,

      --   _con_programa_origen_fondo.cuenta_contable_capital_id,

      --   p_fecha_evento,

      -- p_fecha_evento,

      -- _prestamo.id,

      -- _factura_id,

      -- cast(extract(year from p_fecha_evento) as integer));

     -- end loop;



      --Fin Contabilidad

    end if;





  --raise exception 'ocurrio un error';

  return true;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

