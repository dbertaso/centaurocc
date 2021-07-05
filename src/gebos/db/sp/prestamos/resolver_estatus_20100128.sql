-- Function: resolver_estatus(character varying)

-- DROP FUNCTION resolver_estatus(character varying);

CREATE OR REPLACE FUNCTION resolver_estatus(_estatus character varying)
  RETURNS character varying AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare

	_resultado varchar = 'INI';

begin


if _estatus = 'S' then
	_resultado =  'EN SOLICITUD';
end if;
if _estatus = 'L' then
	_resultado =  'LIQUIDADO';
end if;
if _estatus = 'H' then
	_resultado =  'VIGENTE - DEMORADO';
end if;
if _estatus = 'Q' then
	_resultado =  'LIQUIDADO PARCIAL';
end if;
if _estatus = 'V' then
	_resultado =  'VIGENTE';
end if;
if _estatus = 'E' then
	_resultado =  'VENCIDO';
end if;
if _estatus = 'L' then
	_resultado =  'LITIGIO';
end if;
if _estatus = 'C' then
	_resultado =  'CANCELADO';
end if;
if _estatus = 'F' then
	_resultado =  'CANCELADO POR REESTRUCTURACION FINANCIERA';
end if;
if _estatus = 'A' then
	_resultado =  'CANCELADO POR REESTRUCTURACION';
end if;
if _estatus = 'R' then
	_resultado =  'REESTRUCTURADO';
end if;

if _estatus = 'P' then
	_resultado =  'VIGENTE';
end if;




	return _resultado;


end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION resolver_estatus(character varying) OWNER TO cartera;

