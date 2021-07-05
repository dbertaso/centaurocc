-- Function: eliminaprestamosmigracion(bigint)

-- DROP FUNCTION eliminaprestamosmigracion(bigint);

CREATE OR REPLACE FUNCTION ejecutar_pago_arrime(p_usuario_id integer, p_boleta_id integer)
  RETURNS boolean AS
$BODY$
declare

  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _boleta_arrime boleta_arrime%rowtype;
  _cuenta_bancaria cuenta_bancaria%rowtype;
  _programa programa%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_desembolso refcursor;
  _cur_prestamo refcursor;
  _cheques character varying[];
  _numero_voucher character varying;
  _factura_id integer = 0;



begin

    /*
    -------------------------------------------------------------------
    Creación de cursor de préstamos con boletas de arrime confirmadas
    -------------------------------------------------------------------
    */

    open
        _cur_prestamo
    for
        select
                *
        from
                prestamo
        where

                fecha_instruccion_pago is not null and
                instruccion_pago = true;

    /*
    ---------------------
    Recorrido del cursor
    ---------------------
    */

    loop

      fetch
            _cur_prestamo
      INTO
            _prestamo;

      exit when not found;

      /*
      -----------------------------------------------------
      Lectura de la solicitud relacionada con el préstamo
      -----------------------------------------------------
      */

      select
      into
            _solicitud *
      from
            solicitud
      where
            solicitud.id = _prestamo.solicitud_id;

      /*
      ------------------------------------
      Selección de la entidad financiera
      ------------------------------------
      */

      select
      into
            _cuenta_bancaria *
      from
            cuenta_bancaria
      where
            cuenta_bancaria.cliente_id = _solicitud.cliente_id
      limit 1;

      /*
      ---------------------------------
      Lectura de la boleta de arrime
      ---------------------------------
      */

      select
      into
            _boleta_arrime *
      from
            boleta_arrime
      where
            id           = p_boleta_id and
            solicitud_id = _solicitud.id and
            confirmacion = true and
            estatus IS NULL;

      if found then

        /*
        ----------------------------
        Se ejecuta función de pago
        ----------------------------
        */

        perform iniciar_transaccion(_prestamo.id, p_usuario_id, 'p_pago_arrime', 'L', 'Pago por Arrime para el prÃ©stamo NÃºmero '||_prestamo.numero, _boleta_arrime.valor_arrime);

        raise notice 'Ejecutó iniciar transaccion  % ', _prestamo.numero;

        raise notice 'Valor del Arrime =======> %', _boleta_arrime.valor_arrime;

        _factura_id = ejecutar_pago(_solicitud.cliente_id,
                                   _cheques,
                                   _prestamo.id,
                                   'A',
                                   _boleta_arrime.valor_arrime,
                                   _solicitud.oficina_id,
                                   _boleta_arrime.fecha_confirmacion,
                                   current_date,
                                   _boleta_arrime.guia_movilizacion,
                                   _boleta_arrime.valor_arrime,
                                   _boleta_arrime.silo_id,
                                   true,
                                   false,
                                   false,
                                   false,
                                   false,
                                   'Pago por Arrime',
                                   'Pre cierre de Cartera',
                                   false,
                                   0,
                                   'R'
        );

        raise notice 'Ejecutó ejecutar pago  % % ', _prestamo.numero, _factura_id;

        if _factura_id > 0 then

          update
                 prestamo
          set
                 instruccion_pago = false
          where
                 prestamo.id = _prestamo.id;

        end if;

      end if;

       perform iniciar_transaccion(_prestamo.id, p_usuario_id, 'p_dummy', 'L', 'Transaccion Dummy de Préstamo Número '||_prestamo.numero, 0);

    end loop;

    close _cur_prestamo;

  return true;

end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
