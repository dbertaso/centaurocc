CREATE OR REPLACE FUNCTION fix_ultima_cuota(p_plan_pago_id integer, p_monto double precision)
    RETURNS boolean AS
$BODY$

declare

        _cur_plan_pago_cuota_sumario refcursor;

  	_saldo_insoluto_check numeric(16,2) = 0;

 	_plan_pago_cuota_id_fix integer;

  	_plan_pago_cuota_diferencia numeric(16,2);

  	_plan_pago_cuota_nuevo_amortizado numeric(16,2);

  	_plan_pago_cuota_nuevo_interes numeric(16,2);

  	_plan_pago_cuota_nuevo_saldo_insoluto numeric(16,2);

  	_plan_pago_cuota_fixcuota  plan_pago_cuota%rowtype;

  	_plan_pago_cuota  plan_pago_cuota%rowtype;

begin


-- Método que trata la ultima cuota de la tabla de amortización ajustandola al cuadre

  -- Seleccionos los rows a operar ( los dos ultimos de la tabla de amortizacion )
  _plan_pago_cuota_id_fix = (SELECT (id) FROM plan_pago_cuota WHERE plan_pago_id = p_plan_pago_id ORDER BY id DESC limit 1);

  SELECT into _plan_pago_cuota_fixcuota * FROM plan_pago_cuota WHERE plan_pago_cuota.id = _plan_pago_cuota_id_fix;



  -- Recorro la columna amortizado del plan pago cuota
     open _cur_plan_pago_cuota_sumario for
		  select *
                   from
                   plan_pago_cuota
                   where
                    tipo_cuota = 'C'    and
                    plan_pago_id = p_plan_pago_id;


                   loop
                   fetch _cur_plan_pago_cuota_sumario INTO _plan_pago_cuota;
                   exit when not found;
		     _saldo_insoluto_check = _saldo_insoluto_check + _plan_pago_cuota.amortizado + _plan_pago_cuota.monto_abono;

                   end loop;
     close _cur_plan_pago_cuota_sumario;
  -- Monto liquidado --> p_monto_saldo_insoluto_check




  -- Busco la diferencia del teorico contra la sumatoria de las cuotas
  _plan_pago_cuota_diferencia = (p_monto - _saldo_insoluto_check);

  --raise notice '31861590 monto liquidado -----> %', p_monto;
 --raise notice 'diferencia -----> %', _plan_pago_cuota_diferencia;
  --raise notice 'interes corriente -----> %', _plan_pago_cuota_fixcuota.interes_corriente;
  --raise notice '_plan_pago_cuota_id_fix-----> %', _plan_pago_cuota_id_fix;


   if (_plan_pago_cuota_fixcuota.interes_corriente >= _plan_pago_cuota_diferencia)  then

 --  Traspaso el ajuste del interes al capital
  _plan_pago_cuota_nuevo_interes = _plan_pago_cuota_fixcuota.interes_corriente - _plan_pago_cuota_diferencia;
  _plan_pago_cuota_nuevo_amortizado = _plan_pago_cuota_fixcuota.amortizado + _plan_pago_cuota_diferencia;

 --  Actualizo los registros pertinentes

  UPDATE plan_pago_cuota SET amortizado = _plan_pago_cuota_nuevo_amortizado, interes_corriente = _plan_pago_cuota_nuevo_interes WHERE plan_pago_cuota.id = _plan_pago_cuota_id_fix;
  UPDATE plan_pago_cuota SET saldo_insoluto = _plan_pago_cuota_nuevo_amortizado WHERE plan_pago_cuota.id = _plan_pago_cuota_id_fix - 1;


  end if;

	return true;


end;


$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION fix_ultima_cuota(p_plan_pago_id integer, p_monto double precision) OWNER TO cartera;

