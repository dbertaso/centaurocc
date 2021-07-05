-- Function: calcular_saldo_insoluto(integer, date, boolean)

-- DROP FUNCTION calcular_saldo_insoluto(integer, date, boolean);

CREATE OR REPLACE FUNCTION calcular_saldo_insoluto_dos(p_prestamo_id integer, p_fecha_evento date, p_proyeccion boolean)
  RETURNS boolean AS
$BODY$

  declare


    _prestamo prestamo%rowtype;

    _plan_pago_cuota plan_pago_cuota%rowtype;
    _cur_plan_pago_cuota refcursor;
    _plan_pago plan_pago%rowtype;
    _saldo_insoluto numeric(16,2) = 0;
    _saldo_capitales numeric(16,2) = 0;
    _capital_pagado numeric(16,2) = 0;

  begin

    select
    into
           _prestamo *
    from
           prestamo
    where
           id = p_prestamo_id;

    select
    into
           _plan_pago *
    from
           plan_pago
    where
           prestamo_id = _prestamo.id and
           activo      = true;


    /*
    ------------------------------------------
    Apertura del cursor de cuotas no pagadas
    ------------------------------------------
    */

    open _cur_plan_pago_cuota 
    for
         select *
         from
                  plan_pago_cuota
         where
                  estatus_pago <> 'T' and
                  tipo_cuota    = 'C'    and
                  plan_pago_id  = _plan_pago.id;

    /*
    -------------------------------------------
    Recorrido del cursor _cur_plan_pago_cuota
    -------------------------------------------
    */

    loop

      fetch
            _cur_plan_pago_cuota
      INTO
            _plan_pago_cuota;
      exit when not found;

        _saldo_insoluto = _saldo_insoluto + _plan_pago_cuota.amortizado + _plan_pago_cuota.cuota_extra;
        _capital_pagado = _capital_pagado + _plan_pago_cuota.amortizado + _plan_pago_cuota.cuota_extra;

      end loop;

      if _saldo_insoluto isnull then

         _saldo_insoluto = 0;
      else

        if _capital_pagado isnull then

          update
                 prestamo
          set
                 saldo_insoluto = _prestamo.monto_liquidado
          where
                 id = p_prestamo_id;
          else

            update
                   prestamo
            set
                   saldo_insoluto = _saldo_insoluto
            where
                   id = p_prestamo_id;
         end if;

       end if;

       --raise notice 'saldo_insoluto1590753231860000000000000000 ____________% ', _saldo_insoluto;

    return true;

  end;

$BODY$
LANGUAGE 'plpgsql' VOLATILE;
