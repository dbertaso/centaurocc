-- Function: recalculocuotasintermediado(bigint)

-- DROP FUNCTION recalculocuotasintermediado(bigint);

-- select recalculocuotasintermediado(9999)

CREATE OR REPLACE FUNCTION recalculocuotasintermediado(pnumero bigint)
  RETURNS boolean AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  /* variables para manejo de calculos de intereses */

  _interes_foncrei decimal(16,2);
  _interes_intermediario decimal(16,2);
  _new_interes_foncrei decimal(16,2);
  _new_interes_intermediado decimal(16,2);
  
  _interes_total decimal(16,2);
  _nueva_cuota decimal(16,2);
  _porc_foncrei double precision;
  _porc_intermediado double precision;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_plan_pago_cuota refcursor;
  _cur_plan_pago refcursor;
  _cur_desembolso refcursor;
  _cur_prestamo refcursor;
 

begin

	/*
	-------------------------------------------------------------------------------
	Crea cursor de rechazos
	-------------------------------------------------------------------------------
	*/


	if pnumero = 9999 then

		open _cur_prestamo for

			select 
				 *
			from
				prestamo
			where
				estatus in ('V','E','P') and
				intermediado = true;
		loop

			fetch _cur_prestamo INTO _prestamo;
			exit when not found;

			select into _solicitud * from solicitud where solicitud.id = _prestamo.solicitud_id;

			if found then

				select into _programa * from programa where programa.id = _solicitud.programa_id;

				if not found then
					return false;
				end if;
				
			end if;

			
			open _cur_plan_pago for
		
				select 
					 *
				from
					plan_pago
				where
					plan_pago.prestamo_id	= _prestamo.id and
					plan_pago.activo	= true;

			loop

				fetch _cur_plan_pago INTO _plan_pago;
				exit when not found;
		
				open _cur_plan_pago_cuota for 

					select 
						*
					from
						plan_pago_cuota
					where
						plan_pago_cuota.plan_pago_id = _plan_pago.id and
						plan_pago_cuota.tipo_cuota <> 'M' and
						plan_pago_cuota.interes_foncrei > 0
					order by
						plan_pago_cuota.tipo_cuota,
						plan_pago_cuota.numero;

				loop

					fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
					exit when not found;

					/* Calculo para reconstruir las cuotas intermediadas */

					_porc_foncrei = _programa.porcentaje_tasa_foncrei;
					_porc_intermediado = _programa.porcentaje_tasa_intermediario;
					_interes_foncrei = _plan_pago_cuota.interes_foncrei;
					_interes_intermediario = _plan_pago_cuota.interes_intermediario;
					_interes_total = _interes_foncrei + _interes_intermediario;

					_new_interes_foncrei = (_interes_total * _porc_foncrei) / 100;
					_new_interes_intermediado = _interes_total - _new_interes_foncrei;
					_nueva_cuota = _plan_pago_cuota.amortizado + _interes_total;

					raise notice '-----------------------------------------------------------------';
					raise notice 'numero prestamo ------------------>%', _prestamo.numero;
					raise notice 'numero cuota --------------------->%', _plan_pago_cuota.numero;
					raise notice 'Procentaje Foncrei --------------->%', _porc_foncrei;
					raise notice 'Porcentaje Intermediado ---------->%', _porc_intermediado;
					raise notice 'Interes Total -------------------->%', _interes_total;
					raise notice 'Interes Foncrei ------------------>%', _new_interes_foncrei;
					raise notice 'Interes Total -------------------->%', _interes_total;
					raise notice 'Interes Foncrei ------------------>%', _new_interes_foncrei;
					raise notice 'Interes Intermediado ------------->%', _new_interes_intermediado;
					raise notice 'Nueva Cuota ---------------------->%', _nueva_cuota;
					raise notice 'Programa ------------------------->%', _programa.nombre;

					
					update 
						plan_pago_cuota
					set
						interes_corriente = _interes_total,
						valor_cuota = _nueva_cuota,
						interes_foncrei = _new_interes_foncrei,
						interes_intermediario = _new_interes_intermediado
					where
						id = _plan_pago_cuota.id;
					
					
				end loop;
			
				close _cur_plan_pago_cuota;

			end loop;

			close _cur_plan_pago;

			
		end loop;

		close _cur_prestamo;

	else
	
		select 
			into _prestamo * 
		from 
			prestamo
		where
			prestamo.numero = pnumero and
			estatus in ('V','E','P') and
			intermediado = true;

	
		if found then

			select into _solicitud * from solicitud where solicitud.id = _prestamo.solicitud_id;

			if found then

				select into _programa * from programa where programa.id = _solicitud.programa_id;

				if not found then
					return false;
				end if;
				
			end if;

			select into _plan_pago * 
			from 
					plan_pago
			where
			
					plan_pago.prestamo_id	= _prestamo.id and
					plan_pago.activo	= true;

			if found then
			
				open _cur_plan_pago_cuota for 

					select 
						*
					from
						plan_pago_cuota
					where
						plan_pago_cuota.plan_pago_id = _plan_pago.id and
						plan_pago_cuota.tipo_cuota <> 'M' and
						plan_pago_cuota.interes_foncrei > 0
					order by
						plan_pago_cuota.tipo_cuota,
						plan_pago_cuota.numero;

					loop

						fetch _cur_plan_pago_cuota INTO _plan_pago_cuota;
						exit when not found;

						
						/* Calculo para reconstruir las cuotas intermediadas */

						_porc_foncrei = _programa.porcentaje_tasa_foncrei;
						_porc_intermediado = _programa.porcentaje_tasa_intermediario;
						_interes_foncrei = _plan_pago_cuota.interes_foncrei;
						_interes_intermediario = _plan_pago_cuota.interes_intermediario;
						_interes_total = _interes_foncrei + _interes_intermediario;

						_new_interes_foncrei = (_interes_total * _porc_foncrei) / 100;
						_new_interes_intermediado = _interes_total - _new_interes_foncrei;
						_nueva_cuota = _plan_pago_cuota.amortizado + _interes_total;

						raise notice '-----------------------------------------------------------------';
						raise notice 'numero prestamo ------------------>%', _prestamo.numero;
						raise notice 'numero cuota --------------------->%', _plan_pago_cuota.numero;
						raise notice 'Procentaje Foncrei --------------->%', _porc_foncrei;
						raise notice 'Porcentaje Intermediado ---------->%', _porc_intermediado;
						raise notice 'Interes Total -------------------->%', _interes_total;
						raise notice 'Interes Foncrei ------------------>%', _new_interes_foncrei;
						raise notice 'Interes Total -------------------->%', _interes_total;
						raise notice 'Interes Foncrei ------------------>%', _new_interes_foncrei;
						raise notice 'Interes Intermediado ------------->%', _new_interes_intermediado;
						raise notice 'Nueva Cuota ---------------------->%', _nueva_cuota;
						raise notice 'Programa ------------------------->%', _programa.nombre;


						
						update 
							plan_pago_cuota
						set
							interes_corriente = _interes_total,
							valor_cuota = _nueva_cuota,
							interes_foncrei = _new_interes_foncrei,
							interes_intermediario = _new_interes_intermediado
						where
							id = _plan_pago_cuota.id;
						
						
					end loop;
				
				close _cur_plan_pago_cuota;
				
			end if;
		end if;
		
	end if;

  return true;
 
end;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION recalculocuotasintermediado(bigint) OWNER TO cartera;
