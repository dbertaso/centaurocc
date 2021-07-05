CREATE OR REPLACE FUNCTION leyenda_estatus(_estatus varchar)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: Traducir la inicial del estatus por su correcto texto [e.g. V = Vigente]
PARAMETROS: _estatus : [En Solicitud = S, Liquidando = L, Liquidado Q,  Vigente = V, Vencido = E, Litigio = L, Cancelado = C, Por Vencerse = P, F = Cancelado por Reestructuración Financiera, A = Cancelado por Reestructuración Administrativa]
*/
declare
	_resultado varchar = 'INI';
begin 

	if _estatus = 'S' then 
		_resultado = 'En Solicitud';
	end if;
	if _estatus = 'L' then 
		_resultado = 'Liquidando';
	end if;
	if _estatus = 'Q' then 
		_resultado = 'Liquidado';
	end if;
	if _estatus = 'V' then 
		_resultado = 'Vigente';
	end if;
	if _estatus = 'E' then 
		_resultado = 'Vencido';
	end if;
 	if _estatus = 'L' then 
		_resultado = 'Litigio';
	end if;
	if _estatus = 'C' then 
		_resultado = 'Cancelado';
	end if;
	if _estatus = 'P' then 
		_resultado = 'Por Vencerse';
	end if;
	if _estatus = 'F' then 
		_resultado = 'Cancelado por Reestructuracion Financiera';
	end if;
	if _estatus = 'A' then 
		_resultado = 'Cancelado por Reestructuracion Administrativa';
	end if;
        if _estatus = 'K' then 
		_resultado = 'Castigado';
	end if;
        if _estatus = 'J' then 
		_resultado = 'En Consultoría Jurídica';
	end if;
        if _estatus = 'H' then 
		_resultado = 'Demorado';
	end if;
	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION leyenda_estatus(_estatus varchar) OWNER TO cartera;

