-- Function: calcular_interes_gracia_desembolso(bigint, bigint)

-- DROP FUNCTION calcular_interes_gracia_desembolso(bigint, bigint);

CREATE OR REPLACE FUNCTION calcular_interes_gracia_desembolso(p_prestamo_id integer, p_desembolso_id integer)
  RETURNS boolean AS
$BODY$

  declare

    _rechazos rechazos%rowtype;
    _solicitud solicitud%rowtype;
    _prestamo prestamo%rowtype;
    _parametro_general parametro_general%rowtype;
    _prestamo_tasa_historico prestamo_tasa_historico%rowtype;
    _programa programa%rowtype;
    _plan_pago plan_pago%rowtype;
    _plan_pago_cuota plan_pago_cuota%rowtype;
    _desembolso desembolso%rowtype;
    _comprobante_contable comprobante_contable%rowtype;
    _factura factura%rowtype;
    --_desembolso_pago desembolso_pago%rowtype;
    _fecha_proceso_next date;
    _estatus_prestamo varchar(1);
    _fecha_tope date = '01/01/1900';
    _dias_interes int;
    _interes_gracia decimal(16,2);
    _total_interes_gracia decimal(16,2);
    _dia smallint;
    _mes smallint;
    _year smallint;
    _fecha_inicio date;


    -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
    _cur_plan_pago_cuota refcursor;
    _cur_desembolso refcursor;
    _cur_desembolso_pago refcursor;

  begin

    _total_interes_gracia := 0;
    select into _parametro_general * from parametro_general limit 1;

    select into _prestamo * from prestamo where id = p_prestamo_id;

    if found then

        if _prestamo.ultimo_desembolso = 1 then

            select into _desembolso * from desembolso where desembolso.prestamo_id = _prestamo.id order by desembolso.id limit 1;

        end if;


        if _prestamo.ultimo_desembolso = 2 then

            select into _desembolso * from desembolso where desembolso.id = p_desembolso_id;

        end if;


        if found then

            raise notice 'Desembolso_id - Fecha Realizacion, %, %', _desembolso.id, _desembolso.fecha_realizacion;

            if _parametro_general.dia_facturacion = 'V' then

                _fecha_tope = agregar_dias(_desembolso.fecha_realizacion, (_prestamo.frecuencia_pago * 30));
            end if;

            if _parametro_general.dia_facturacion = 'F' then

                _fecha_tope = agregar_meses(_desembolso.fecha_realizacion, _prestamo.frecuencia_pago);
            end if;

            raise notice 'dia_facturacion , %', _parametro_general.dia_facturacion;

            if _parametro_general.dia_facturacion = 'C' then

               _dia = extract(day from _desembolso.fecha_realizacion);
               _mes = extract(month from _desembolso.fecha_realizacion);
               _year = extract(year from _desembolso.fecha_realizacion);

               raise notice 'dia, %', _dia;
               raise notice 'mes, %', _mes;
               raise notice 'ano, %', _year;

               if _dia = 29 or
                  _dia = 30 or
                  _dia = 31 then

                  _mes = _mes + 1;

                  --raise notice 'mes -----> %',_mes;

                  if _mes = 13 then
                     _mes = 01;
                     _year = _year + 1;
                  end if;

                end if;
                 -- raise notice 'year -----> %', _year;

                if _dia > 16 and _dia <= 28 then
                   _dia = 28;
                else
                   _dia = 16;
                end if;

                raise notice 'dia, %', _dia;
                raise notice 'mes, %', _mes;
                raise notice 'ano, %', _year;


                _fecha_inicio = date (_year || '-' || _mes || '-' || _dia);

                raise notice 'fecha inicio, %', _fecha_inicio;

                _fecha_tope = agregar_meses(_fecha_inicio, _prestamo.frecuencia_pago);

                raise notice 'Fecha Tope, %', _fecha_tope;

            end if;

        end if;

        update
              prestamo
        set
              fecha_base = _fecha_tope
        where
              id = _prestamo.id;

    end if;


    /*
    -------------------------
    Crea rowset de facturas
    -------------------------
    */

    select into
                 _desembolso *
    from
                 desembolso
    where
                 desembolso.id = p_desembolso_id and
                 desembolso.realizado = true;

    if found then

        /*
        --------------------------------
        Actualiza tasa del desembolso
        --------------------------------
        */

        update
                desembolso
        set
            tasa = _prestamo.tasa_vigente
        where
            prestamo_id = _prestamo.id and
            id = _desembolso.id;

        /*
        --------------------------------
        Abriendo cursor de desembolsos
        --------------------------------
        */

        open _cur_desembolso for

        select
              *
        from
              desembolso
        where
              desembolso.prestamo_id  = _prestamo.id
        order by
              desembolso.fecha_realizacion;

        /*
        --------------------------------------------------
        Comienzo del recorrido del cursor de desembolsos
        --------------------------------------------------
        */

        loop

          fetch _cur_desembolso INTO _desembolso;
          exit when not found;

          /*
          -----------------------------------------------------------
          Actualización de los intereses de gracia en el desembolso
          -----------------------------------------------------------
          */

          raise notice 'Fecha Tope - Fecha Realizacion - Dias Interes ===========>, %, %, % ', _fecha_tope, _desembolso.fecha_realizacion, _dias_interes;
          _dias_interes = (_fecha_tope - _desembolso.fecha_realizacion);
          _interes_gracia := ((_desembolso.monto * _desembolso.tasa) / 36000) * _dias_interes;

          raise notice 'Dias Interes - Interes Gracia, %, %', _dias_interes, _interes_gracia;

          raise notice 'Prestamo # - Fecha Base, %, %', _prestamo.numero, _fecha_tope;

          update
                desembolso
          set
                interes_gracia = _interes_gracia,
                tasa = _prestamo.tasa_vigente
          where
                id = _desembolso.id;


        /*
        -------------------------------------------------
        Fin del recorrido del cursor de plan_pago cuota
        -------------------------------------------------
        */

        end loop;

    /*
    -------------------------------
    Cerrando cursor de desembolso
    -------------------------------
    */

    close _cur_desembolso;


    end if;

    return true;

  end;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION calcular_interes_gracia_desembolso(bigint, bigint) OWNER TO cartera;
