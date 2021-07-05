/*****************************************************************************************************

 Función calcula el interés devengado a fin de mes o al vencimiento de cuota
 dado.
 Params:
 @p_prestamo_id		Identificador del préstamo
 @p_fecha_evento	Fecha a la que se realiza el cálculo
 @p_tipo_interés       	Tipo de devengo a calcular ('O' Ordinario - 'D' Diferido)

 Desarrollado posr: Alexander Belisario

*****************************************************************************************************/
-- Function: calcular_interes_devengado(integer, date, character)

-- DROP FUNCTION calcular_interes_devengado(integer, date, character);

-- Function: calcular_interes_devengado(integer, date, character)

-- DROP FUNCTION calcular_interes_devengado(integer, date, character);

CREATE OR REPLACE FUNCTION calcular_interes_devengado(p_prestamo_id integer, p_fecha_evento date, p_tipo_interes character)
  RETURNS boolean AS
$BODY$
declare

  _prestamo prestamo%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _cur_plan_pago_cuota refcursor;

  _cuota_siguiente plan_pago_cuota%rowtype;

  _interes_causado plan_pago_cuota.causado_no_devengado%type;

  _interes_devengado_mes plan_pago_cuota.interes_ord_devengado_mes%type;
  _fecha_devengado plan_pago_cuota.fecha_ord_devengado%type;
  _fecha_fin_mes date;
  _prop_dif numeric(5,2);
  _interes_devengado_acum plan_pago_cuota.interes_ord_devengado_acum%type;
  _frecuencia_pago integer = 0;

begin
        raise info '[GEBOS] calcular_interes_devengado {p_prestamo_id: %, p_fecha_evento: %, p_tipo_interes: %', p_prestamo_id, p_fecha_evento, p_tipo_interes;
	/*
	----------------------
	Paso 1: Lectura del prestamo
	----------------------
	*/

	select
	  into _prestamo *
	from
	  prestamo
	where
	  prestamo.id = p_prestamo_id;

	if not found then
          raise debug '[GEBOS] calcular_interes_devengado: Préstamo % no encontrado', p_prestamo_id;
          return 0;
	end if;

        if _prestamo.ultimo_desembolso != 0 then
          raise debug '[GEBOS] calcular_interes_devengado: Préstamo % en espera de último desembolso', p_prestamo_id;
          return 0;
        end if;

        if _prestamo.frecuencia_pago = 0 then
          _frecuencia_pago = _prestamo.plazo;
        else
          _frecuencia_pago = _prestamo.frecuencia_pago;
        end if;

	/*
	----------------------
	paso 2: Lectura del plan_pago
	----------------------
	*/
	select
	  into _plan_pago *
	from
	  plan_pago
	where
	  plan_pago.prestamo_id = _prestamo.id and activo = true;

	if not found then
          raise debug '[GEBOS] calcular_interes_devengado: Plan_Pago no encontrado';
          return 0;
	end if;

	/*
	----------------------
	paso 3: Lectura de cuotas plan_pago_cuota
	(Cuota anterior y siguiente a la del evento)
	----------------------
	*/

	  select into _cuota_siguiente *
	  from
	    plan_pago_cuota
	  where
	    plan_pago_id = _plan_pago.id
	    and fecha >= p_fecha_evento
	    and fecha - p_fecha_evento <=30 * _frecuencia_pago
	  order by fecha
	  limit 1;

	if not found then
          raise debug '[GEBOS] calcular_interes_devengado: Plan_Pago_Cuota no encontrado (plan_pago_id = %)', _plan_pago.id;
          return 0;
	end if;

	if _cuota_siguiente.tipo_cuota = 'M' then
          raise debug '[GEBOS] calcular_interes_devengado: Cuota muerta (plan_pago_cuota_id = %)', _cuota_siguiente.id;
          return 0;
	end if;

       _fecha_fin_mes = last_day(p_fecha_evento);

   _prop_dif = 0.00;
   if _cuota_siguiente.tipo_cuota = 'G' then
     if (_cuota_siguiente.interes_corriente + _cuota_siguiente.interes_diferido) <> 0 then
       _prop_dif = _cuota_siguiente.interes_diferido / (_cuota_siguiente.interes_corriente + _cuota_siguiente.interes_diferido);
     else
        _prop_dif = 0;
     end if;
   end if;

   -- Evalúo fecha_evento. Procede en caso de ser fin de mes (cierra el dia anterior)
   if (p_fecha_evento = _fecha_fin_mes ) then
        raise debug '[GEBOS] calcular_interes_devengado: Devengo por cierre de mes';

        if p_tipo_interes = 'O' then

          raise debug '[GEBOS] calcular_interes_devengado: Devengo de intereses ordinarios';
          -- Devengo de Intereses ordinarios
          _interes_causado = _cuota_siguiente.causado_no_devengado; --(A)
          _interes_devengado_mes = _cuota_siguiente.interes_ord_devengado_mes; -- (B)
          _fecha_devengado = _cuota_siguiente.fecha_ord_devengado; -- (C)
          _interes_devengado_acum = _cuota_siguiente.interes_ord_devengado_acum; -- (D)

          update plan_pago_cuota
          set
            interes_ord_devengado_mes = _interes_causado - interes_ord_devengado_acum -- (B = A - D)
          where
            id = _cuota_siguiente.id;

          update plan_pago_cuota
          set
            interes_ord_devengado_acum = interes_ord_devengado_mes + interes_ord_devengado_acum -- (D = B + D)
          where
            id = _cuota_siguiente.id;

          update plan_pago_cuota
          set
            fecha_ord_devengado = p_fecha_evento
          where
            id = _cuota_siguiente.id;

	  if _cuota_siguiente.tipo_cuota = 'G' then

	    update plan_pago_cuota
	    set
	      interes_dif_devengado_mes = interes_ord_devengado_mes * _prop_dif
	    where
	      id = _cuota_siguiente.id;

	  end if;


        end if;
   end if;

   --Fecha de vencimiento de la cuota. Calculo último tramo por diferencia
   if (p_fecha_evento = _cuota_siguiente.fecha) then
        raise debug '[GEBOS] calcular_interes_devengado: Devengo previo vencimiento de cuota';
        if p_tipo_interes = 'O' then
          if _cuota_siguiente.tipo_cuota = 'G' then
              raise debug '[GEBOS] calcular_interes_devengado: Devengo de intereses diferidos';
              --Ajuste por req 02Ago2010. Se totaliza el interes corriente + interes diferido
              --_interes_causado = _cuota_siguiente.interes_corriente;
              _interes_causado = _cuota_siguiente.interes_diferido;
              _interes_devengado_acum = _cuota_siguiente.interes_ord_devengado_acum;
              _interes_devengado_mes = _interes_causado - _interes_devengado_acum;
              _fecha_devengado = _cuota_siguiente.fecha_ord_devengado;
               -- (D)
          else
              raise debug '[GEBOS] calcular_interes_devengado: Devengo de intereses ordinarios';
              --Ajuste por req 02Ago2010. Se totaliza el interes corriente + interes diferido
              --_interes_causado = _cuota_siguiente.interes_corriente;
              _interes_causado = _cuota_siguiente.interes_corriente;
              _interes_devengado_acum = _cuota_siguiente.interes_ord_devengado_acum;
              _interes_devengado_mes = _interes_causado - _interes_devengado_acum;
              _fecha_devengado = _cuota_siguiente.fecha_ord_devengado;
               -- (D)
          end if;

          update plan_pago_cuota
          set
            interes_ord_devengado_mes = _interes_devengado_mes
          where
            id = _cuota_siguiente.id;

          update plan_pago_cuota
          set
            interes_ord_devengado_acum = interes_ord_devengado_mes + interes_ord_devengado_acum
          where
            id = _cuota_siguiente.id;

          update plan_pago_cuota
          set
            fecha_ord_devengado = _cuota_siguiente.fecha
          where
            id = _cuota_siguiente.id;

	  if _cuota_siguiente.tipo_cuota = 'G' then

	    update plan_pago_cuota
	    set
	      interes_dif_devengado_mes = interes_ord_devengado_mes * _prop_dif
	    where
	      id = _cuota_siguiente.id;

	  end if;

          --Ajuste de devengo. Requerimiento del 04-01-2010
          if _interes_devengado_mes < 0 then
            update plan_pago_cuota
            set
              ajuste_devengo = _interes_devengado_mes
            where
              id = _cuota_siguiente.id;
          end if;

        end if;
   end if;
   raise info '[GEBOS] calcular_interes_devengado finalizado';
   return true;
end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION calcular_interes_devengado(integer, date, character) OWNER TO cartera;

