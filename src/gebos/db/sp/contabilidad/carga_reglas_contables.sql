create or replace function carga_reglas_contables() returns void as $$

declare

  _estatus text[] := '{"V","E","L","D","K","J"}';

  _transacciones text[] := '{"CASTIGADO",
                              "PAGO CUOTA",
                              "ABONO",
                              "PASE LITIGIO",
                              "PASE VIGENTE",
                              "PASE VENCIDO",
                              "CANCELACION PRESTAMO",
                              "DEVENGO INTERES ORDINARIO",
                              "DEVENGO INTERES DIFERIDO"}';

  _codigos_contables text[] := '{"01-10101010311301100",
                                 "01-10101010211299100",
                                 "01-31001010013105101",
                                 "01-10202030013305001",
                                 "01-10202030013205101",
                                 "01-10202030013405101",
                                 "01-10201020014301100",
                                 "01-20205020027599000",
                                 "01-30303010351301105",
                                 "01-31002060013101011",
                                 "01-30303020114301100",
                                 "01-31002060013101009",
                                 "01-31002060013101006",
                                 "01-30303020114301100"}';

  _descripcion_codigos text[] := '{"Bancos",
                                   "Patrimonio BCV",
                                   "Cobro capital cuota vigente",
                                   "Rendimientos por cobrar vigente",
                                   "Cobro capital vencidos",
                                   "Cobro capital reestructurados",
                                   "Cobro capital litigio",
                                   "Devengo intereses diferidos",
                                   "Intereses ordinarios créditos directos e intereses de mora",
                                   "Capital línea crédito bancoex",
                                   "Rend. Por cobrar Línea crédito bancoex",
                                   "Capital línea crédito banfoandes",
                                   "Intereses Ordinarios línea crédito banfoandes",
                                   "Rend. Por cobrar líneas crédito banfoandes Agric. e Ind."}';

  _montos text[] := '{"MP","MC", "IO", "ID","IM","MG","MD"}';

  _tipo_movimiento text[] := '{"D","H","H","D","H","D","D"}';

  _fuente_recursos_id integer[3] := '{1,2,3}';


  _transaccion character varying;
  _estado character varying;

  _secuencia integer := 0;

  /* Códigos Contables Cuentas Bancarias */

  _codigo_cuenta_banco character varying(20) := '01-10101010311301100';

  /* Código Contable Cuenta Bcv Patrimonio */

  _codigo_bcv_patrimonio character varying(20) := '01-10101010211299100';

  /* Auxiliares Cuentas Recaudadoras */

  _auxiliar_biv character varying(7) := '-100609';
  _auxiliar_banfoandes character varying(7) := '-100610';
  _auxiliar_mercantil character varying(7) := '-100608';
  _auxiliar_bcv character varying(7) := '-100602';
  _auxiliar_devengo_diferidos character varying(7) := '-800000';
  _auxiliar_linea_bancoex character varying(7) := '-100504';
  _auxiliar_linea_banfoandes character varying(7) := '-100017';

  /* Códigos contables para capital, intereses, mora, intereses diferidos */

  _codigo_capital_vigente character varying(20) := '01-31001010013105101';
  _codigo_capital_vencido character varying(20) := '01-10202030013305001';
  _codigo_capital_reestructurados character varying(20) := '01-10202030013205101';
  _codigo_capital_litigio character varying(20) := '01-10202030013405101';


  _codigo_rendim_vigente character varying(20) := '01-10201020014301100';
  _codigo_devengo_diferidos character varying(20) := '01-20205020027599000';
  _codigo_intereses_ordinarios character varying(20) := '01-30303010351301105';

  /* Códigos Contables Líneas de Crédito */

   _codigo_capital_linea_crédito_bancoex character varying(20) := '01-31002060013101011';
   _codigo_redimiento_cobrar_bancoex character varying(20) := '01-30303020114301100';

   _codigo_capital_linea_banfoandes character varying(20) := '01-31002060013101009';
   _codigo_intereses_linea_banfoandes character varying(20) := '01-31002060013101006';
   _codigo_rendimiento_cobrar_linea_banfoandes character varying(20) := '01-30303020114301100';

   _fin_codigo character varying(4) := '0000';

   /* Cursor de Sector Economico */

   _cur_sector_economico refcursor;
   _sector_economico sector_economico%rowtype;

   _fuente_recursos integer;
   _tipo_monto char(2);
   _tipo_movim char(1);


 begin

  /*
  -----------------------------------------------------------------
  Eliminación de registros en las tablas de Comprobante Contable,
  Asiento Contable, Regla Contable y Cuenta Contable para proceder
  a crear las nuevas cuentas contables y reglas contables
  -----------------------------------------------------------------
  */

  delete from asiento_contable;
  delete from comprobante_contable;
  delete from regla_contable;
  delete from cuenta_contable;

  /* Se inicializan las secuencias de los id de las tablas borradas */

  perform setval('asiento_contable_id_seq',1,true);
  perform setval('comprobante_contable_id_seq',1,true);
  perform setval('regla_contable_id_seq',1,true);
  perform setval('cuenta_contable_id_seq',1,true);

  /*
  --------------------------------------------------------
  Inserción de los nuevos códigos contables en la tabla
  cuenta contable
  --------------------------------------------------------
  */

  for i in 1..14 loop

    insert
    into cuenta_contable
                         (codigo,
                          nombre)
                 values
                         (_codigos_contables[i],
                          _descripcion_codigos[i]);

  end loop;

  /*
  --------------------------------------------------
  Recorrido del arreglo de las transacciones para
  comienzo de la inserción de las reglas contables
  --------------------------------------------------
  */

  for j in 1..9 loop

    _transaccion := _transacciones[j];

    if  _transaccion = 'CASTIGADO'    then
    end if;

    if _transaccion = 'PAGO CUOTA' then

      for y in 1..3 loop

        _estado = _estatus[y];

        if _estado = 'E' then

          begin

            /* Creación de cursor de sectores ecónomicos */

            open
                _cur_sector_economico
            for
                select
                       *
                from
                       sector_economico
                where
                       sector_economico.id < 1000
                order by
                       sector_economico.id;

            /* recorrido cursor sector_economico */

            loop

              fetch _cur_sector_economico INTO _sector_economico;
              exit when not found;

              _secuencia = 0;

              for d in 1..1 loop

                for n in 1..5 loop

                  _secuencia = _secuencia + 1;

                  if n = 1 then

                   _fuente_recursos = _fuente_recursos_id[d]::integer;
                   _tipo_monto = _montos[n];
                   _tipo_movim = _tipo_movimiento[n];

                   perform insert_regla_contable(_transaccion,
                                         _fuente_recursos,
                                         _sector_economico.id,
                                         _estado,
                                         _secuencia,
                                         _tipo_movim,
                                         _codigo_cuenta_banco,
                                         _auxiliar_biv,
                                         _fin_codigo,
                                         _tipo_monto,
                                         'R',
                                         1,
                                         'N');

                   _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                       _fuente_recursos,
                                       _sector_economico.id,
                                       _estado,
                                       _secuencia,
                                       _tipo_movim,
                                       _codigo_cuenta_banco,
                                       _auxiliar_banfoandes,
                                       _fin_codigo,
                                       _tipo_monto,
                                       'R',
                                       182,
                                       'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                       _fuente_recursos,
                                       _sector_economico.id,
                                       _estado,
                                       _secuencia,
                                       _tipo_movim,
                                       _codigo_cuenta_banco,
                                       _auxiliar_mercantil,
                                       _fin_codigo,
                                       _tipo_monto,
                                       'R',
                                       16,
                                      'N');
                  end if;

                  if n = 2 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                         _fuente_recursos,
                                         _sector_economico.id,
                                         _estado,
                                         _secuencia,
                                         _tipo_movim,
                                         _codigo_capital_vencido,
                                         '0',
                                         _fin_codigo,
                                         _tipo_monto,
                                         'R',
                                         null,
                                         'N');
                  end if;

                  if n = 3 or n = 5 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                    _transaccion,
                                                    _fuente_recursos,
                                                    _sector_economico.id,
                                                    _estado,
                                                    _secuencia,
                                                    _tipo_movim,
                                                    _codigo_intereses_ordinarios,
                                                    '-000000',
                                                    _fin_codigo,
                                                    _tipo_monto,
                                                    'R',
                                                    null,
                                                    'N');
                  end if;

                  if n = 4 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'D',
                                                 _codigo_devengo_diferidos,
                                                 '-800000',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'H',
                                                 _codigo_rendim_vigente,
                                                 '0',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                end loop;   ---> for n in 1..5 loop

              end loop;     ---> for d in 1..1 loop

            end loop;       ---> Fin loop sector economico

          close  _cur_sector_economico;

          end;             ---> fin del Bloque

        end if;            ---> if _estado = 'E' then

        if _estado = 'V' then

          /* Creación de cursor de sectores ecónomicos */

          begin

            open
                  _cur_sector_economico
            for
                  select
                         *
                  from
                       sector_economico
                  where
                       sector_economico.id < 1000
                  order by
                       sector_economico.id;


            /* recorrido cursor sector_economico */

            loop

              fetch _cur_sector_economico INTO _sector_economico;
              exit when not found;

              _secuencia = 0;

              for d in 1..1 loop

                for n in 1..5 loop

                  _secuencia = _secuencia + 1;

                  if n = 1 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                    _transaccion,
                                                    _fuente_recursos,
                                                    _sector_economico.id,
                                                    _estado,
                                                    _secuencia,
                                                    _tipo_movim,
                                                    _codigo_cuenta_banco,
                                                    _auxiliar_biv,
                                                    _fin_codigo,
                                                    _tipo_monto,
                                                    'R',
                                                    1,
                                                    'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(
                                                    _transaccion,
                                                    _fuente_recursos,
                                                    _sector_economico.id,
                                                    _estado,
                                                    _secuencia,
                                                    _tipo_movim,
                                                    _codigo_cuenta_banco,
                                                    _auxiliar_banfoandes,
                                                    _fin_codigo,
                                                    _tipo_monto,
                                                    'R',
                                                    182,
                                                    'N');

                    perform insert_regla_contable(
                                                    _transaccion,
                                                    _fuente_recursos,
                                                    _sector_economico.id,
                                                    _estado,
                                                    _secuencia,
                                                    _tipo_movim,
                                                    _codigo_cuenta_banco,
                                                    _auxiliar_mercantil,
                                                    _fin_codigo,
                                                    _tipo_monto,
                                                    'R',
                                                    16,
                                                    'N');
                  end if;

                  if n = 2 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_capital_vigente,
                                                 '0',
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                  if n = 3 or n = 5 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_intereses_ordinarios,
                                                 '-000000',
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                  if n = 4 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'D',
                                                 _codigo_devengo_diferidos,
                                                 '-800000',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'H',
                                                 _codigo_rendim_vigente,
                                                 '0',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                end loop;     ---> for n in 1..5 loop

              end loop;       ---> for d in 1..1 loop

            end loop;         ---> loop cursor sector economico

            close _cur_sector_economico;

          end;              ---> Fin del Bloque

        end if;             --->  if _estado = 'V' then


        if _estado = 'L' then

          /* Creación de cursor de sectores ecónomicos */

          begin

            open
                  _cur_sector_economico
            for
                  select
                         *
                  from
                         sector_economico
                  where
                         sector_economico.id < 1000
                  order by
                         sector_economico.id;


            /* recorrido cursor sector_economico */

            loop

              fetch _cur_sector_economico INTO _sector_economico;
              exit when not found;

              _secuencia = 0;

              for d in 1..1 loop

                for n in 1..5 loop

                  _secuencia = _secuencia + 1;

                  if n = 1 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_cuenta_banco,
                                                 _auxiliar_biv,
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 1,
                                                 'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_cuenta_banco,
                                                 _auxiliar_banfoandes,
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 182,
                                                 'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_cuenta_banco,
                                                 _auxiliar_mercantil,
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 16,
                                                 'N');
                  end if;

                  if n = 2 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable( _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_capital_litigio,
                                                  '0',
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  null,
                                                  'N');
                  end if;

                  if n =  3 or n = 5 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 _tipo_movim,
                                                 _codigo_intereses_ordinarios,
                                                 '-000000',
                                                 _fin_codigo,
                                                 _tipo_monto,
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                  if n =  4 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'D',
                                                 _codigo_devengo_diferidos,
                                                 '-800000',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(_transaccion,
                                                 _fuente_recursos,
                                                 _sector_economico.id,
                                                 _estado,
                                                 _secuencia,
                                                 'H',
                                                 _codigo_rendim_vigente,
                                                 '0',
                                                 _fin_codigo,
                                                 'ID',
                                                 'R',
                                                 null,
                                                 'N');
                  end if;

                end loop;       ---> for n in 1..5 loop

              end loop;         ---> for d in 1..1 loop

            end loop;           ---> Recorrido cursor sector economico

            close _cur_sector_economico;

          end;                  ---> Fin del Bloque

        end if;                 ---> if _estado = 'L' then

        if _estado =  'J' then
        end if;

        if _estado =  'K' then

          /* Creación de cursor de sectores ecónomicos */

          begin
            open
                _cur_sector_economico
            for
                select
                       *
                from
                       sector_economico
                where
                       sector_economico.id < 1000
                order by
                       sector_economico.id;


            /* recorrido cursor sector_economico */

            loop

              fetch _cur_sector_economico INTO _sector_economico;
              exit when not found;

              _secuencia = 0;

              for d in 1..1 loop

                for n in 1..5 loop

                  _secuencia = _secuencia + 1;


                  if n = 1 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_cuenta_banco,
                                                  _auxiliar_biv,
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  1,
                                                  'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_cuenta_banco,
                                                  _auxiliar_banfoandes,
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  182,
                                                  'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_cuenta_banco,
                                                  _auxiliar_mercantil,
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  16,
                                                  'N');
                  end if;

                  if n = 2 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_capital_vencido,
                                                  '0',
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  null,
                                                  'N');

                  end if;

                  if n = 3 or n = 5 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  _tipo_movim,
                                                  _codigo_intereses_ordinarios,
                                                  '-000000',
                                                  _fin_codigo,
                                                  _tipo_monto,
                                                  'R',
                                                  null,
                                                  'N');

                  end if;

                  if n = 4 then

                    _fuente_recursos = _fuente_recursos_id[d]::integer;
                    _tipo_monto = _montos[n];
                    _tipo_movim = _tipo_movimiento[n];

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  'D',
                                                  _codigo_devengo_diferidos,
                                                  '-800000',
                                                  _fin_codigo,
                                                  'ID',
                                                  'R',
                                                  null,
                                                  'N');

                    _secuencia = _secuencia + 1;

                    perform insert_regla_contable(
                                                  _transaccion,
                                                  _fuente_recursos,
                                                  _sector_economico.id,
                                                  _estado,
                                                  _secuencia,
                                                  'H',
                                                  _codigo_rendim_vigente,
                                                  '0',
                                                  _fin_codigo,
                                                  'ID',
                                                  'R',
                                                  null,
                                                  'N');
                  end if;

                end loop;       ---> for n in 1..5 loop

              end loop;         ---> for d in 1..1 loop

            end loop;           ---> Fin recorrido cursor sector_economico

            close _cur_sector_economico;

          end;                  ---> Fin del Bloque

        end if;                 ---> if _estado =  'K' then

      end loop;                 ---> for y in 1..3 loop

    end if;                     ---> if 'PAGO CUOTA' then

    if _transaccion =  'ABONO' then
    end if;


    if _transaccion = 'PASE LITIGIO' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          _secuencia = _secuencia + 1;


          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'D',
                                        _codigo_capital_vencido,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                        null,
                                        'N');

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        _fuente_recursos,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'H',
                                        _codigo_capital_litigio,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                         null,
                                        'N');

          _secuencia = _secuencia + 1;

        end loop;     ---> fin recorrido cursor sector_economico

        close  _cur_sector_economico;

      end;            ---> Fin Bloque

    end if;           ---> if _transaccion = 'PASE LITIGIO' then

    if _transaccion = 'PASE VIGENTE' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          _secuencia = _secuencia + 1;


          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'D',
                                        _codigo_capital_vencido,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                        null,
                                        'N');

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        _fuente_recursos,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'H',
                                        _codigo_capital_vigente,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                         null,
                                        'N');

          _secuencia = _secuencia + 1;

        end loop;       ---> Fin Recorrido Cursor Sector Economico

        close  _cur_sector_economico;

      end;              ---> Fin del Bloque

    end if;             ---> if _transaccion = 'PASE VIGENTE' then

    if _transaccion = 'PASE VENCIDO' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          _secuencia = _secuencia + 1;


          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'D',
                                        _codigo_capital_vigente,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                        null,
                                        'N');

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        _fuente_recursos,
                                        _sector_economico.id,
                                        'P',
                                        _secuencia,
                                        'H',
                                        _codigo_capital_vigente,
                                        '0',
                                        _fin_codigo,
                                        'MC',
                                        'R',
                                         null,
                                        'N');



        end loop;     ---> Fin del recorrido del cursor

        close  _cur_sector_economico;

      end;            ---> Fin del Bloque

    end if;           ---> if _transaccion = 'PASE VENCIDO' then

    if _transaccion =  'CANCELACION PRESTAMO' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          for d in 1..1 loop

            for n in 1..5 loop

              _secuencia = _secuencia + 1;

              if n = 1 then

                _fuente_recursos = _fuente_recursos_id[d]::integer;
                _tipo_monto = _montos[n];
                _tipo_movim = _tipo_movimiento[n];

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              _tipo_movim,
                                              _codigo_cuenta_banco,
                                              _auxiliar_biv,
                                              _fin_codigo,
                                              _tipo_monto,
                                              'R',
                                              1,
                                              'N');

                _secuencia = _secuencia + 1;

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              _tipo_movim,
                                              _codigo_cuenta_banco,
                                              _auxiliar_banfoandes,
                                              _fin_codigo,
                                              _tipo_monto,
                                              'R',
                                              182,
                                              'N');

                _secuencia = _secuencia + 1;

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              _tipo_movim,
                                              _codigo_cuenta_banco,
                                              _auxiliar_mercantil,
                                              _fin_codigo,
                                              _tipo_monto,
                                              'R',
                                              16,
                                              'N');
              end if;

              if n = 2 then

                _fuente_recursos = _fuente_recursos_id[d]::integer;
                _tipo_monto = _montos[n];
                _tipo_movim = _tipo_movimiento[n];

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              _tipo_movim,
                                              _codigo_capital_vencido,
                                              '0',
                                              _fin_codigo,
                                              _tipo_monto,
                                              'R',
                                              null,
                                              'N');
              end if;

              if n = 3 or n = 5 then

                _fuente_recursos = _fuente_recursos_id[d]::integer;
                _tipo_monto = _montos[n];
                _tipo_movim = _tipo_movimiento[n];

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              _tipo_movim,
                                              _codigo_intereses_ordinarios,
                                              '-000000',
                                              _fin_codigo,
                                              _tipo_monto,
                                              'R',
                                              null,
                                              'N');
              end if;


              if n = 4 then

                _fuente_recursos = _fuente_recursos_id[d]::integer;
                _tipo_monto = _montos[n];
                _tipo_movim = _tipo_movimiento[n];

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              'D',
                                              _codigo_devengo_diferidos,
                                              '-800000',
                                              _fin_codigo,
                                              'ID',
                                              'R',
                                              null,
                                              'N');

                _secuencia = _secuencia + 1;

                perform insert_regla_contable(
                                              _transaccion,
                                              _fuente_recursos,
                                              _sector_economico.id,
                                              'C',
                                              _secuencia,
                                              'H',
                                              _codigo_rendim_vigente,
                                              '0',
                                              _fin_codigo,
                                              'ID',
                                              'R',
                                              null,
                                              'N');
              end if;

            end loop;         ---> for d in 1..1 loop

          end loop;           ---> for n in 1..5 loop

        end loop;             ---> Fin del recorrido del cursor sector_economico

        close  _cur_sector_economico;

      end;                    ---> Fin del Bloque

    end if;                   ---> if _transaccion =  'CANCELACION PRESTAMO' then

    if _transaccion =  'DEVENGO INTERES ORDINARIO' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'D',
                                        _secuencia,
                                        'H',
                                        _codigo_intereses_ordinarios,
                                        '-000000',
                                        _fin_codigo,
                                        'IO',
                                        'R',
                                        null,
                                        'N');

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'D',
                                        _secuencia,
                                        'D',
                                        _codigo_rendim_vigente,
                                        '0',
                                        _fin_codigo,
                                        'IO',
                                        'R',
                                        null,
                                        'N');

        end loop;         ---> Fin del recorrido del cursos

        close  _cur_sector_economico;

      end;                ---> Fin del Bloque

    end if;               ---> if _transaccion =  'DEVENGO INTERES ORDINARIO' then

    if _transaccion = 'DEVENGO INTERES DIFERIDO' then

      begin

        /* Creación de cursor de sectores ecónomicos */

        open
            _cur_sector_economico
        for
            select
                   *
            from
                   sector_economico
            where
                   sector_economico.id < 1000
            order by
                   sector_economico.id;

        /* recorrido cursor sector_economico */

        loop

          fetch _cur_sector_economico INTO _sector_economico;
          exit when not found;

          _secuencia = 0;

          _secuencia = _secuencia + 1;

          perform insert_regla_contable(
                                        _transaccion,
                                        1,
                                        _sector_economico.id,
                                        'D',
                                        _secuencia,
                                        'H',
                                        _codigo_devengo_diferidos,
                                        '-800000',
                                        _fin_codigo,
                                        'ID',
                                        'R',
                                        null,
                                        'N');

            _secuencia = _secuencia + 1;

            perform insert_regla_contable(
                                          _transaccion,
                                          1,
                                          _sector_economico.id,
                                          'D',
                                          _secuencia,
                                          'D',
                                          _codigo_rendim_vigente,
                                          '0',
                                          _fin_codigo,
                                          'ID',
                                          'R',
                                          null,
                                          'N');

        end loop;       ---> Fin recorrido del cursor

        close  _cur_sector_economico;

      end;              ---> Fin del Bloque

    end if;             ---> if _transaccion = 'DEVENGO INTERES DIFERIDO' then

   end loop;            ---> for j in 1..9 loop

   --incluir loop de transacciones, estatus, y incrementar secuencia.
   --dividir debe y haber.

   --Separar Bandes Directo y Lineas de Crédito

   for i in 1..3 loop

     raise notice 'El estatus es ==========> % ', _estatus[i];

   end loop;

   for i in 1..9 loop

     _transaccion = _transacciones[i];
     raise notice 'La transaccion es ==========> % ', _transaccion;

   end loop;

 end;

$$
language plpgsql;

