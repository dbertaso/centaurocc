create or replace function calcular_interes_gracia_devengado(
  p_prestamo_id integer,
  p_fecha_evento date,
  p_proyeccion bool) returns bool as $$
declare  
  _prestamo prestamo%rowtype;
  _parametro_general parametro_general%rowtype;
  _desembolso desembolso%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _plan_pago_cuota_anterior plan_pago_cuota%rowtype;
  _monto_devengado decimal(16,2) = 0;
  _dias_devengados integer = 0;
  _fecha date;
  _base_calculo_intereses integer = 0;
  _saldo_insoluto numeric;
  _cur_desembolso refcursor;
  _fecha_base date;
  _fecha_fin_mes date;
  _frecuencia integer;
  _monto_devengado_diferido_mes decimal(16,2) = 0;
begin

  select into _parametro_general * from parametro_general limit 1;
  select into _prestamo * from prestamo
    where id = p_prestamo_id;


 --raise notice 'NUMERO PRESTAMO_____________________________%',_prestamo.numero;

  _base_calculo_intereses = _prestamo.base_calculo_intereses;
  _fecha_base := _prestamo.fecha_base;
  _fecha_fin_mes := last_day(p_fecha_evento);
  raise notice 'Fecha_liquidacion ======> %', _prestamo.fecha_liquidacion;

  _fecha = _prestamo.fecha_liquidacion;
  _frecuencia = _prestamo.frecuencia_pago;

  if _prestamo.ultimo_desembolso = 1 then

     if _parametro_general.dia_facturacion = 'V' then

        if _prestamo.fecha_base IS NULL then

            _fecha_base = agregar_dias(_prestamo.fecha_liquidacion, (_prestamo.frecuencia_pago * 30));
        else
            _fecha_base = agregar_meses(_fecha, _frecuencia);

        end if;

     end if;

   else


        if _prestamo.fecha_base IS NULL then

            if _parametro_general.dia_facturacion = 'V' then

                _fecha_base = agregar_dias(_prestamo.fecha_liquidacion, (_prestamo.frecuencia_pago * 30));
             else
                _fecha_base = agregar_meses(_fecha, _frecuencia);


            end if;

         end if;


  end if;

 -- Recupera las cuotas menores a la fecha actual y que no esten pagadas
  open 
        _cur_desembolso 
  for 
        select 
                * 
        from 
                desembolso 
        where 
                desembolso.prestamo_id  = _prestamo.id and 
                desembolso.realizado    = true;
  loop

  fetch 
        _cur_desembolso 
  INTO 
        _desembolso;

  exit when not found;

  raise notice 'FECHA BASE ======> %', _fecha_base;
  raise notice 'FECHA EVENTO ======> %', p_fecha_evento;

  if  _fecha_base >= p_fecha_evento then

    if _desembolso.fecha_devengado is null then

        _fecha := _desembolso.fecha_realizacion;
    else
        _fecha := _desembolso.fecha_devengado;
    end if;

    raise notice 'FECHA ======> %', _fecha;

    if p_fecha_evento = _fecha_base then
        _fecha_fin_mes := _fecha_base;
    end if;

    if _fecha_fin_mes = p_fecha_evento then

        if _desembolso.fecha_realizacion <= _fecha_fin_mes then

                raise notice 'FECHA REALIZACION ======> %', _desembolso.fecha_realizacion;
                raise notice 'FECHA FIN MES ======> %', _fecha_fin_mes;

                _dias_devengados = (p_fecha_evento - _fecha)-1;

                 raise notice 'DIAS DEVENGADOS ======> %', _dias_devengados;

            if _dias_devengados > 0 then

                _monto_devengado = (((_desembolso.tasa/100)/_base_calculo_intereses)*(_desembolso.monto))*_dias_devengados;

                if _prestamo.porcentaje_diferimiento > 0 then

                  if _monto_devengado > 0 then

                    _monto_devengado_diferido_mes = _monto_devengado * (_prestamo.porcentaje_diferimiento / 100);
                   end if;
                end if;

                raise notice 'MONTO DEVENGADO ======> %', _monto_devengado;
                raise notice 'MONTO DEVENGADO DIFERIDO MES =====> %', _monto_devengado_diferido_mes;

                update
                        desembolso
                set
                        interes_devengado_mes = _monto_devengado,
                        interes_dif_gracia_devengado_mes = _monto_devengado_diferido_mes,
                        fecha_devengado = _fecha_fin_mes,
                        interes_devengado_acum = interes_devengado_acum + _monto_devengado
                where
                        desembolso.id = _desembolso.id;

            end if;

         end if;

    end if;

  end if;

end loop;

close _cur_desembolso;

   return true;

end;

$$ language 'plpgsql' volatile;