-- Function: registro_contable(character varying, character varying, integer, integer, character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, date, date, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character)

/*
  DROP FUNCTION registro_contable(p_transaccion_contable_id integer,
                                             p_modalidad character varying,
                                             p_fuente_recursos_id integer,
                                             p_programa_id integer,
                                             p_estatus character varying,
                                             p_entidad_financiera_id integer,
                                             p_monto_pago double precision,
                                             p_monto_ingreso_intereses double precision,
                                             p_monto_por_cobrar_intereses double precision,
                                             p_remanente_por_aplicar double precision,
                                             p_monto_capital_cuota double precision,
                                             p_ingreso_mora double precision,
                                             p_remanente_por_aplicar_inicial double precision,
                                             p_monto_comision_intereses double precision,
                                             p_interes_diferido double precision,
                                             p_monto_gasto double precision,
                                             p_monto_sras double precision,
                                             p_monto_excedente double precision,
                                             p_fecha_registro date,
                                             p_fecha_comprobante date,
                                             p_prestamo_id integer,
                                             p_factura_id integer,
                                             p_anio integer,
                                             p_voucher character varying,
                                             p_banco character varying,
                                             p_nombre character varying,
                                             p_tipo_transaccion character varying,
                                             p_prestamo character varying,
                                             p_reestructurado character,
                                             p_transaccion_id integer);
*/

CREATE OR REPLACE FUNCTION registro_contable(p_transaccion_contable_id integer,
                                             p_modalidad character varying,
                                             p_fuente_recursos_id integer,
                                             p_programa_id integer,
                                             p_estatus character varying,
                                             p_entidad_financiera_id integer,
                                             p_monto_pago double precision,
                                             p_monto_ingreso_intereses double precision,
                                             p_monto_por_cobrar_intereses double precision,
                                             p_remanente_por_aplicar double precision,
                                             p_monto_capital_cuota double precision,
                                             p_ingreso_mora double precision,
                                             p_remanente_por_aplicar_inicial double precision,
                                             p_monto_comision_intereses double precision,
                                             p_interes_diferido double precision,
                                             p_monto_gasto double precision,
                                             p_monto_sras double precision,
                                             p_monto_excedente double precision,
                                             p_monto_desembolso double precision,
                                             p_monto_boleta double precision,
                                             p_fecha_registro date,
                                             p_fecha_comprobante date,
                                             p_prestamo_id integer,
                                             p_factura_id integer,
                                             p_anio integer,
                                             p_voucher character varying,
                                             p_banco character varying,
                                             p_nombre character varying,
                                             p_tipo_transaccion character varying,
                                             p_prestamo character varying,
                                             p_reestructurado character,
                                             p_transaccion_id integer)
  RETURNS boolean AS
$BODY$

 declare

   _prestamo prestamo%rowtype;
   _solicitud solicitud%rowtype;
   _actividad actividad%rowtype;
   _comprobante_contable_id integer;
   _entidad_financiera entidad_financiera%rowtype;
   _cuenta_contable_id integer;
   _cuenta_contable cuenta_contable%rowtype;
   _cuenta_contable_presupuesto_id integer = null;
   _cuenta_contable_presupuesto cuenta_contable_presupuesto%rowtype;
   _transaccion_contable transaccion_contable%rowtype;
   _total_debe float;
   _total_haber float;
   _factura_id integer = null;
   _transaccion_id integer;
   _cur_regla_contable refcursor;
   _regla_contable regla_contable%rowtype;
   _referencia character varying;
   _codigo_contable character varying;
   _monto_contabilizacion double precision = 0;
   _auxiliar_contable character varying(7);
   _plazo_ciclo character(1) = 'C';
   _moneda_id integer;

 begin

   _referencia = ' ';

   if p_modalidad = 'Z'             and
      p_monto_ingreso_intereses = 0 and
      p_interes_diferido = 0        then

      return true;
   end if;

   RAISE NOTICE 'Interes ordinario =======> % ', p_monto_ingreso_intereses;
   RAISE NOTICE 'Interes diferido  =======> % ', p_interes_diferido;
   RAISE NOTICE 'REGLA CONTABLE plazos             ==================> %', _plazo_ciclo;
   RAISE NOTICE 'Modalidad             =============> % ', p_modalidad;

  select
  into
          _prestamo *
  from
          prestamo
  where
          prestamo.id = p_prestamo_id;

  if found then
  
    select
    into
            _solicitud *
    from
            solicitud
    where
            solicitud.id = _prestamo.solicitud_id;
            
    if found then
    
      select
      into
              _actividad *
      from
              actividad
      where
              actividad.id = _solicitud.actividad_id;

      if not found then
      
        _plazo_ciclo = 'C';
      else
        _plazo_ciclo = _actividad.plazo_ciclo;
      end if;
    end if;
    
  end if;

   raise notice 'Tipo Transaccion ========>, %', p_tipo_transaccion;
   raise notice 'Prestamo Numero  ========>, %', p_prestamo;
   raise notice 'Nombre Cliente   ========>, %', p_nombre;
   raise notice 'Nombre del Banco ========>, %', p_banco;
   raise notice 'Voucher Numero   ========>, %', p_voucher;
   raise notice 'Plazo Ciclo      ========>, %', _plazo_ciclo;

  if p_modalidad = 'Z' or p_modalidad = 'X' then

    RAISE INFO 'Paso or if de modalidad';
    _referencia = p_tipo_transaccion || ' del ' || 'Financiamiento nro. ' || p_prestamo || ' de ' || p_nombre;

  else
    RAISE INFO 'Paso or else de modalidad';
    _referencia = p_tipo_transaccion || ' del ' || 'Financiamiento nro. ' || p_prestamo || ' de ' || p_nombre || ' en el banco ' || p_banco || ' con voucher nro. ' || p_voucher;

  end if;
   
  if p_modalidad = 'A' then
   
    _referencia = p_tipo_transaccion || ' del ' || 'Financiamiento nro. ' || p_prestamo || ' de ' || p_nombre || ' en el silo ' || p_banco || ' con referencia nro. ' || p_voucher;
  end if;
   

  if p_factura_id > 0 then
     _factura_id = p_factura_id;
  end if;

  begin
    _transaccion_id = currval('transaccion_id_seq');
      exception when others then

      _transaccion_id = 0;

  end;

  RAISE NOTICE 'REFERENCIA DE COMPROBANTE ==========> %', _referencia;

   /*
   ----------------------------------------------
   Se graba encabezado del comprobante contable
   ----------------------------------------------
   */

    insert
    into
            comprobante_contable
                            (
                                fecha_registro,
                                fecha_comprobante,
                                enviado,
                                prestamo_id,
                                transaccion_contable_id,
                                estatus,
                                factura_id,
                                anio,
                                transaccion_id,
                                reverso,
                                reversado,
                                referencia)
            values
                            (
                                p_fecha_registro,
                                p_fecha_registro,
                                false,
                                p_prestamo_id,
                                p_transaccion_contable_id,
                                p_estatus,
                                _factura_id,
                                p_anio,
                                p_transaccion_id,
                                false,
                                false,
                                _referencia);

    _comprobante_contable_id = currval('comprobante_contable_id_seq');

    _total_debe = 0;
    _total_haber = 0;

   /*
   -------------------------------------------
   Se registra el asiento contable de banco
   -------------------------------------------
   */


   RAISE NOTICE 'PASO POR p_modalidad = R';
   /*
   ------------------------------------
   Registro contable cuenta de bancos
   ------------------------------------
   */

  if p_monto_pago > 0 then

    RAISE NOTICE 'ENTIDAD FINANCIERA ID =====> %', p_entidad_financiera_id;

    select
    into
          _regla_contable *
    from
          regla_contable
    where
          regla_contable.transaccion_contable_id = p_transaccion_contable_id and
          regla_contable.fuente_recursos_id = p_fuente_recursos_id and
          regla_contable.plazos = _plazo_ciclo and
          regla_contable.programa_id = p_programa_id and
          regla_contable.entidad_financiera_id = p_entidad_financiera_id and
          regla_contable.modalidad_pago = p_modalidad and
          regla_contable.estatus = p_estatus and
          regla_contable.reestructurado = p_reestructurado;

    
    if found then

      _auxiliar_contable = '';
      
      select
      into
              _entidad_financiera *
      from
              entidad_financiera
      where
              id = p_entidad_financiera_id;
              
      if found then
        _auxiliar_contable = _entidad_financiera.auxiliar_contable;
      end if;
      
      insert 
      into 
            asiento_contable (
                              comprobante_contable_id,
                              codigo_contable,
                              auxiliar_contable,
                              monto,
                              tipo)
            values
                            (
                              _comprobante_contable_id,
                              _regla_contable.codigo_contable,
                              _auxiliar_contable,
                              p_monto_pago,
                              _regla_contable.tipo_movimiento);

      if _regla_contable.tipo_movimiento = 'D' then

        _total_debe = _total_debe + p_monto_pago;
      else
        _total_haber = _total_haber + p_monto_pago;
      end if;
       
    end if;
    
  end if;
  
   /*
   ----------------------------------------------------------
   Se crea cursor de la tabla regla contable para
   determinar los asientos de la transaccion a contabilizar
   dependiendo de la modalidad de pago
   ----------------------------------------------------------
   */

    RAISE NOTICE 'REGLA CONTABLE codigo transaccion ==================> %', p_transaccion_contable_id;
    RAISE NOTICE 'REGLA CONTABLE fuente recursos    ==================> %', p_fuente_recursos_id;
    RAISE NOTICE 'REGLA CONTABLE programa           ==================> %', p_programa_id;
    RAISE NOTICE 'REGLA CONTABLE estatus            ==================> %', p_estatus;
    RAISE NOTICE 'REGLA CONTABLE p_modalidad        ==================> %', p_modalidad;
    RAISE NOTICE 'REGLA CONTABLE p_reestructurado   ==================> %', p_reestructurado;
    RAISE NOTICE 'REGLA CONTABLE plazos             ==================> %', _plazo_ciclo;

    /*
    -----------------------------------------
    Registro de asientos diferentes a banco
    -----------------------------------------
    */
    
    open
        _cur_regla_contable
    for
        select
                *
        from
                regla_contable
        where
                regla_contable.transaccion_contable_id = p_transaccion_contable_id and
                regla_contable.fuente_recursos_id = p_fuente_recursos_id and
                regla_contable.plazos = _plazo_ciclo and
                regla_contable.programa_id = p_programa_id and
                regla_contable.entidad_financiera_id is null and
                regla_contable.modalidad_pago = p_modalidad and
                regla_contable.estatus = p_estatus and
                regla_contable.reestructurado = p_reestructurado
        order by
                regla_contable.secuencia;


    loop

        RAISE NOTICE 'ENTRO EN EL LOOP DEL CURSOR DE LOS ASIENTOS CONTABLE';

        RAISE NOTICE 'PARAMETRO MONTO TRANSACCION %', p_monto_pago;
        RAISE NOTICE 'PARAMETRO MONTO CAPITAL CUOTA %', p_monto_capital_cuota;
        RAISE NOTICE 'PARAMETRO MONTO INGRESO INTERESES %', p_monto_ingreso_intereses;
        RAISE NOTICE 'PARAMETRO MONTO INTERES DIFERIDO %', p_interes_diferido;
        RAISE NOTICE 'PARAMETRO MONTO INGRESO MORA %', p_ingreso_mora;
        RAISE NOTICE 'PARAMETRO MONTO MONTO GASTO %', p_monto_gasto;

        fetch _cur_regla_contable INTO _regla_contable;
            exit when not found;

        if _regla_contable.tipo_monto = 'MC' THEN

          _monto_contabilizacion = p_monto_capital_cuota;
        end if;

        if _regla_contable.tipo_monto = 'IO' THEN

          _monto_contabilizacion = p_monto_ingreso_intereses;
        end if;

        if _regla_contable.tipo_monto = 'ID' THEN

          _monto_contabilizacion = p_interes_diferido;
        end if;

        if _regla_contable.tipo_monto = 'IM' THEN
          _monto_contabilizacion = p_ingreso_mora;
        end if;

        if _regla_contable.tipo_monto = 'MP' THEN

          _monto_contabilizacion = p_monto_pago;
        end if;

        if _regla_contable.tipo_monto = 'MD' THEN

          _monto_contabilizacion = p_monto_desembolso;
        end if;

        if _regla_contable.tipo_monto = 'MS' THEN

          _monto_contabilizacion = p_monto_sras;
        end if;

        if _regla_contable.tipo_monto = 'MG' THEN

          _monto_contabilizacion = p_monto_gasto;
        end if;

        if _regla_contable.tipo_monto = 'ME' THEN
          _monto_contabilizacion = p_remanente_por_aplicar;
        end if;

        if _regla_contable.tipo_monto = 'MB' THEN
          _monto_contabilizacion = p_monto_boleta;
        end if;

        RAISE NOTICE 'TIPO DE MONTO                    =============> % ', _regla_contable.tipo_monto;
        RAISE NOTICE 'Monto Contabilizacin             =============> % ', cast(_monto_contabilizacion as varchar);

        if _monto_contabilizacion > 0 then

          RAISE NOTICE 'Entro a grabar asiento             =============> % ', cast(_monto_contabilizacion as varchar);

          insert into asiento_contable (
                                          comprobante_contable_id,
                                          codigo_contable,
                                          auxiliar_contable,
                                          monto,
                                          tipo)
                          values
                                      (
                                          _comprobante_contable_id,
                                          _regla_contable.codigo_contable,
                                          _regla_contable.auxiliar_contable,
                                          _monto_contabilizacion,
                                          _regla_contable.tipo_movimiento);


          if _regla_contable.tipo_movimiento = 'D' then

            _total_debe = _total_debe + _monto_contabilizacion;
          else
            _total_haber = _total_haber + _monto_contabilizacion;
          end if;

          RAISE NOTICE 'Monto debe - Monto haber despues suma % - %', _total_debe, _total_haber;

         _monto_contabilizacion = 0;
       end if;

    end loop;


  RAISE NOTICE 'Monto debe - Monto haber % - %', _total_debe, _total_haber;

  if  _total_debe = 0 and
      _total_haber = 0 then

      delete from comprobante_contable where id = _comprobante_contable_id;
  else
        update 
                comprobante_contable 
        set 
                total_debe = _total_debe, 
                total_haber = _total_haber
        where 
                id = _comprobante_contable_id;

  end if;

   return true;

 end;

 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
