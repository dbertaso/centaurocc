-- Function: registro_contable(character varying, character varying, integer, integer, character varying, integer, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, date, date, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character)
/*
DROP FUNCTION registro_contable(p_codigo_transaccion character varying,
                                             p_modalidad character varying,
                                             p_fuente_recursos_id integer,
                                             p_sector_economico_id integer,
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

CREATE OR REPLACE FUNCTION registro_contable(p_codigo_transaccion character varying,
                                             p_modalidad character varying,
                                             p_fuente_recursos_id integer,
                                             p_sector_economico_id integer,
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
                                             p_transaccion_id integer)
  RETURNS boolean AS
$BODY$

 declare

   _prestamo prestamo%rowtype;
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
   _cur_regla_contable refcursor;
   _regla_contable regla_contable%rowtype;
   _referencia character varying;
   _codigo_contable character varying;
   _monto_contabilizacion double precision;

 begin

   _referencia = ' ';

   if p_modalidad = 'D'             and
      p_monto_ingreso_intereses = 0 and
      p_interes_diferido = 0        then

      return true;
   end if;

   RAISE NOTICE 'Interes ordinario =======> % ', p_monto_ingreso_intereses;
   RAISE NOTICE 'Interes diferido  =======> % ', p_interes_diferido;

   select
   into
            _prestamo *
   from
            prestamo
   where
            prestamo.id = p_prestamo_id;

   raise notice 'Tipo Transaccion ========>, %', p_tipo_transaccion;
   raise notice 'Prestamo Numero  ========>, %', p_prestamo;
   raise notice 'Nombre Cliente   ========>, %', p_nombre;
   raise notice 'Nombre del Banco ========>, %', p_banco;
   raise notice 'Voucher Numero   ========>, %', p_voucher;

   if p_modalidad = 'D' then

    _referencia = p_tipo_transaccion;

   else

    _referencia = p_tipo_transaccion || ' del ' || 'prestamo nro. ' || p_prestamo || ' de ' || p_nombre || ' en el banco ' || p_banco || ' con voucher nro. ' || p_voucher;

    RAISE NOTICE 'REFERENCIA DE COMPROBANTE ==========> %', _referencia;

   end if;

   if p_factura_id > 0 then
     _factura_id = p_factura_id;
   end if;

   begin
     _transaccion_id = currval('transaccion_id_seq');
     exception when others then

     _transaccion_id = 0;

   end;

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
                                codigo_transaccion,
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
                                p_fecha_comprobante,
                                false,
                                p_prestamo_id,
                                p_codigo_transaccion,
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
   -------------------------------------------------------------
   Se registra el asiento contable de banco cuando la modalidad
   de pago no es cuenta recaudadora ni cobranza automática
   -------------------------------------------------------------
   */

   if p_modalidad <> 'R' and
      p_modalidad <> 'A' and
      p_modalidad <> 'D' then


     /*
     ------------------------------------
     Registro contable cuenta de bancos
     ------------------------------------
     */

     RAISE NOTICE 'PASO POR p_modalidad <> R and p_modalidad <> A and p_modalidad <> D';

     if p_monto_pago > 0 then

         select
         into
                _regla_contable *
         from
                regla_contable
         where
                regla_contable.codigo_transaccion = p_codigo_transaccion and
                regla_contable.fuente_recursos_id = p_fuente_recursos_id and
                regla_contable.sector_economico_id = p_sector_economico_id and
                regla_contable.entidad_financiera_id = p_entidad_financiera_id and
                regla_contable.reestructurado = p_reestructurado;

         if not found then

            if _regla_contable.auxiliar_contable = '0' then
                _codigo_contable = _regla_contable.codigo_contable || '-' || _prestamo.codigo_contable || '0000';
            else
                _codigo_contable = _regla_contable.codigo_contable || _regla_contable.auxiliar_contable || _regla_contable.fin_codigo;
            end if;

            insert into asiento_contable (
                                            comprobante_contable_id,
                                            codigo_contable,
                                            monto,
                                            tipo)
                            values
                                        (
                                            _comprobante_contable_id,
                                            _cuenta_contable,
                                            p_monto_pago,
                                            _regla_contable.tipo_movimiento);

             if _regla_contable.tipo_movimiento then

                _total_debe = _total_debe + p_monto_pago;
             else
                _total_haber = _total_haber + p_monto_pago;
             end if;
             
        end if;   --------> Fin if not found then

     end if;      --------> Fin if p_monto_pago > 0 then

   end if;        --------> Fin if p_modalidad <> 'R' and p_modalidad <> 'A' and p_modalidad <> 'D' then

   /*
   ---------------------------------------------------------
   Se registra el asiento contablede banco si la modalidad
   de pago es cuenta recaudadora.
   ---------------------------------------------------------
   */

   if p_modalidad = 'R' then

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
                regla_contable.codigo_transaccion = p_codigo_transaccion and
                regla_contable.fuente_recursos_id = p_fuente_recursos_id and
                regla_contable.sector_economico_id = p_sector_economico_id and
                regla_contable.modalidad_pago = p_modalidad and
                regla_contable.entidad_financiera_id = p_entidad_financiera_id and
                regla_contable.reestructurado = p_reestructurado;

         if found then

            if _regla_contable.auxiliar_contable = '0' then
                _codigo_contable = _regla_contable.codigo_contable || '-' || _prestamo.codigo_contable || '0000';
            else
                _codigo_contable = _regla_contable.codigo_contable || _regla_contable.auxiliar_contable || _regla_contable.fin_codigo;
            end if;


            insert into asiento_contable (
                                            comprobante_contable_id,
                                            codigo_contable,
                                            monto,
                                            tipo)
                            values
                                        (
                                            _comprobante_contable_id,
                                            _codigo_contable,
                                            p_monto_pago,
                                            _regla_contable.tipo_movimiento);

             if _regla_contable.tipo_movimiento = 'D' then

                _total_debe = _total_debe + p_monto_pago;
             else
                _total_haber = _total_haber + p_monto_pago;
             end if;
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

    RAISE NOTICE 'REGLA CONTABLE codigo transaccion ==================> %', p_codigo_transaccion;
    RAISE NOTICE 'REGLA CONTABLE fuente recursos    ==================> %', p_fuente_recursos_id;
    RAISE NOTICE 'REGLA CONTABLE sector economico   ==================> %', p_sector_economico_id;
    RAISE NOTICE 'REGLA CONTABLE estatus            ==================> %', p_estatus;
    RAISE NOTICE 'REGLA CONTABLE p_modalidad        ==================> %', p_modalidad;
    RAISE NOTICE 'REGLA CONTABLE p_reestructurado   ==================> %', p_reestructurado;

    if p_modalidad = 'R' or
       p_modalidad = 'A' or
       p_modalidad = 'D' then

       RAISE NOTICE 'PASO POR p_modalidad = R and p_modalidad = A and p_modalidad = D';

        open
            _cur_regla_contable
        for
            select
                    *
            from
                    regla_contable
            where
                    regla_contable.codigo_transaccion = p_codigo_transaccion and
                    regla_contable.fuente_recursos_id = p_fuente_recursos_id and
                    regla_contable.sector_economico_id = p_sector_economico_id and
                    regla_contable.estatus = p_estatus and
                    regla_contable.modalidad_pago = p_modalidad and
                    regla_contable.reestructurado = p_reestructurado and
                    regla_contable.entidad_financiera_id is null
            order by
                    regla_contable.secuencia;
    else

        open
            _cur_regla_contable
        for
            select
                    *
            from
                    regla_contable
            where
                    regla_contable.codigo_transaccion = p_codigo_transaccion and
                    regla_contable.fuente_recursos_id = p_fuente_recursos_id and
                    regla_contable.estatus = p_estatus and
                    regla_contable.sector_economico_id = p_sector_economico_id and
                    regla_contable.reestructurado = p_reestructurado and
                    regla_contable.entidad_financiera_id is null
            order by
                    regla_contable.secuencia;

    end if;

    loop

        fetch _cur_regla_contable INTO _regla_contable;
            exit when not found;


        RAISE NOTICE 'ENTRO EN EL LOOP DEL CURSOR DE LOS ASIENTOS CONTABLE';

        RAISE NOTICE 'PARAMETRO MONTO CAPITAL CUOTA %', p_monto_capital_cuota;
        RAISE NOTICE 'PARAMETRO MONTO INGRESO INTERESES %', p_monto_ingreso_intereses;
        RAISE NOTICE 'PARAMETRO MONTO INTERES DIFERIDO %', p_interes_diferido;
        RAISE NOTICE 'PARAMETRO MONTO INGRESO MORA %', p_ingreso_mora;
        RAISE NOTICE 'PARAMETRO MONTO MONTO GASTO %', p_monto_gasto;

        if _regla_contable.tipo_monto = 'MC' THEN
            _monto_contabilizacion := p_monto_capital_cuota;
        end if;

        if _regla_contable.tipo_monto = 'IO' THEN
            _monto_contabilizacion := p_monto_ingreso_intereses;
      end if;

        if _regla_contable.tipo_monto = 'ID' THEN
            _monto_contabilizacion := p_interes_diferido;
      end if;

        if _regla_contable.tipo_monto = 'IM' THEN
            _monto_contabilizacion := p_ingreso_mora;
       end if;

        if _regla_contable.tipo_monto = 'MD'  OR _regla_contable.tipo_monto = 'MP' THEN
            _monto_contabilizacion := p_monto_pago;
       end if;

        if _regla_contable.tipo_monto = 'MG' THEN
            _monto_contabilizacion := p_monto_gasto;
        end if;

        if _regla_contable.tipo_monto = 'MS' THEN
            _monto_contabilizacion := p_monto_sras;
        end if;
        
        if _regla_contable.tipo_monto = 'ME' THEN
          _monto_contabilizacion := p_monto_excedente;
        end if;

        RAISE NOTICE 'TIPO DE MONTO             =============> %', _regla_contable.tipo_monto;

        if _regla_contable.auxiliar_contable = '0' then
            _codigo_contable = _regla_contable.codigo_contable;
        else
            _codigo_contable = _regla_contable.codigo_contable || _regla_contable.auxiliar_contable;
        end if;

        if _monto_contabilizacion > 0 then

            insert into asiento_contable (
                                            comprobante_contable_id,
                                            codigo_contable,
                                            monto,
                                            tipo)
                            values
                                        (
                                            _comprobante_contable_id,
                                            _codigo_contable,
                                            _monto_contabilizacion,
                                            _regla_contable.tipo_movimiento);


             if _regla_contable.tipo_movimiento = 'D' then

                _total_debe = _total_debe + _monto_contabilizacion;
             else
                _total_haber = _total_haber + _monto_contabilizacion;
             end if;

       end if;

  end loop;


   update comprobante_contable set total_debe = _total_debe, total_haber = _total_haber
     where id = _comprobante_contable_id;

   if _total_debe = 0 and
      _total_haber = 0 then

      delete from comprobante_contable where id = _comprobante_contable_id;
   end if;

   return true;

 end;

 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
