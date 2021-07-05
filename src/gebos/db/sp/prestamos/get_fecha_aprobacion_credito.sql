CREATE OR REPLACE FUNCTION get_fecha_aprobacion_credito(_solicitud_id integer)
  RETURNS date AS
$BODY$
/*
PROPOSITO: Desde prestamo alcanzar la fecha de aprobacion de un credito
PARAMETROS: info_request : [prestamo_id]
*/
declare
	_solicitud solicitud%rowtype;
	_resultado date = '1900-01-01';

begin 

/*
A criterio se busca la fecha de aprobacion del credito entre los campos de la solicitud
*/

SELECT INTO _solicitud * FROM solicitud WHERE id = _solicitud_id;



if (_solicitud.fecha_acta_comite is not null) then
_resultado = _solicitud_tabla.fecha_acta_comite;
end if;

if (_solicitud.fecha_acta_directorio is not null) then
_resultado = _solicitud_tabla.fecha_acta_directorio;
end if;


	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
ALTER FUNCTION get_fecha_aprobacion_credito(_solicitud_id integer) OWNER TO cartera;

