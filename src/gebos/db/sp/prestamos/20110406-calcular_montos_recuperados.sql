-- Function: calcular_montos_recuperados(integer, date, boolean)

-- DROP FUNCTION calcular_montos_recuperados(integer, date, boolean);

CREATE OR REPLACE FUNCTION calcular_montos_recuperados(p_prestamo_id integer,
                                                       p_proyeccion boolean)
    RETURNS boolean AS

$BODY$

/*
-----------------------------------------------------------
Función que calcula y actualiza en el préstamo los montos
pagados (recuperados) de (interes ordinario + diferido),
capital y mora.
-----------------------------------------------------------
*/

declare


    _prestamo prestamo%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _cur_plan_pago_cuota refcursor;
    _plan_pago plan_pago%rowtype;
    _capital_pagado numeric(16,2) = 0;
    _interes_pagado numeric(16,2) = 0;
    _mora_pagada numeric(16,2) = 0;

begin

    /*
    ----------------------
    Lectura del préstamo
    ----------------------
    */

    select
    into
           _prestamo *
    from
           prestamo
    where
           prestamo.id = p_prestamo_id;

    /*
    -----------------------------------
    Lectura del plan pago relacionado
    con el préstamo
    -----------------------------------
    */

    select
    into
           _plan_pago *
    from
           plan_pago
    where
           prestamo_id = _prestamo.id and
           activo      = true;

    /*
    -------------------------------------
    Creación del cursor con las cuotas
    pagadas del préstamo
    -------------------------------------
    */

    open
         _cur_plan_pago_cuota
    for
         select
                *
         from
                plan_pago_cuota
         where
                tipo_cuota    in ('C','G')  and
                plan_pago_id  = _plan_pago.id;

    /*
    ------------------------------------
    Se inicia del recorrido del cursor
    ------------------------------------
    */

    loop

        fetch
              _cur_plan_pago_cuota
        INTO
              _plan_pago_cuota;
        exit when not found;

        _capital_pagado = _capital_pagado + _plan_pago_cuota.pago_capital + _plan_pago_cuota.monto_abono;
        _interes_pagado = _interes_pagado + _plan_pago_cuota.pago_interes_corriente + _plan_pago_cuota.pago_interes_diferido;
        _mora_pagada = _mora_pagada + _plan_pago_cuota.pago_interes_mora;

    end loop;


    /*
    ----------------------------------------------
    Actualización del prestamo con las variables
    calculadas durante el recorrido del cursor
    ----------------------------------------------
    */

    update
           prestamo
    set
           capital_pagado    = _capital_pagado,
           intereses_pagados = _interes_pagado,
           mora_pagada       = _mora_pagada + pago_mora_migracion
    where
           id = p_prestamo_id;

    return true;

end;

$BODY$
LANGUAGE 'plpgsql' VOLATILE;

