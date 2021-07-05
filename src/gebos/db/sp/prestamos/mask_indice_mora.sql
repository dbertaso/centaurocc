CREATE OR REPLACE FUNCTION mask_indice_mora(_factor1 numeric, _factor2 numeric)
  RETURNS varchar AS
$BODY$
/*
PROPOSITO: alcanzar facilmente atributos de cliente que pueden estar en las tablas EMPRESA o PERSONA.
PARAMETROS: info_request : [nombre, cedula_rif]
*/
declare
	_resultado varchar = 'INI';
begin 

if _factor2 = 0 then
_resultado = 0;
else
_resultado = _factor1 / _factor2;
end if;


	return _resultado;

 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 

