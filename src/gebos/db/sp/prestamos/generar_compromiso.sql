-- Function: generar_compromiso()

-- DROP FUNCTION generar_compromiso();

CREATE OR REPLACE FUNCTION generar_compromiso(p_solicitud_id integer, 
                                               p_tipo_transaccion char)
  RETURNS integer AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _presupuesto_pidan presupuesto_pidan%rowtype;
  _configuracion_avance configuracion_avance%rowtype;
  _parametro parametro_general%rowtype;
  _cdh comite_decision_historico%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _actividad actividad%rowtype;
  _cliente cliente%rowtype;
  _persona persona%rowtype;
  _empresa empresa%rowtype;
  _estado_id integer;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;
  _solicitud_id integer;
  _estatus_id_inicial integer;
  _estatus_id_final integer;
  _solicitud_fecha_aprobacion date;
  _solicitud_monto_aprobado numeric(16,2);
  _nro_solicitud integer;
  _nombre_programa character varying(255);
  _plazo char;
  _nombre_beneficiario character varying(255);
  _cuenta_presupuestaria character varying(20) = 'Cuenta Inexistente';
  _rif_ci character varying(15);
  _fecha date;
    
  
  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_solicitudes refcursor;
  _cur_desembolso refcursor;
  _cur_view_total_compromiso refcursor;
 

begin

  _fecha = current_timestamp;
  /*
  ----------------------------------------------------
  Actualización de decisión en comité estadal
  ----------------------------------------------------
  */
  
  /*
  ------------------------------
  Lectura de parametro general
  ------------------------------
  */
  
  select
  into
        _parametro *
  from
        parametro_general
  where
        id = 1;
  
  if not found then
  
    return 1;   --- 'No existe Parámetro General'
  end if;
  
           
  /*
  ---------------------
  Lectura del Trámite
  ---------------------
  */

  select
  into
          _solicitud *
  from
          solicitud
  where
          solicitud.id = p_solicitud_id;
          
  if found then
  
    /*
    ----------------------
    Lectura del programa
    ----------------------
    */
    
    select 
    into 
          _programa *
    from
          programa
    where
          id = _solicitud.programa_id;
          
    if not found then
      return 7;         --programa no existe
    end if;
    
    /*
    ---------------------------------------------
    Lectura del plazo del ciclo en la actividad
    ---------------------------------------------
    */    
    
    select
    into
            _plazo plazo_ciclo
    from
           actividad
    where
            id = _solicitud.actividad_id;
            
    if not found then
    
      return 8;        --Plazo del ciclo en la actividad no existe
    end if;
    
    /*
    -----------------------------------------
    Lectura del cliente asociado al trámite
    -----------------------------------------
    */
    
    select
    into
          _cliente *
    from
          cliente
    where
          id = _solicitud.cliente_id;
          
    if not found then
    
      return 9;         ---> Cliente No existe
    end if;
    
    /*
    ----------------------------------------------
    Lectura del beneficiario asociado al trámite
    ----------------------------------------------
    */
    
    if _cliente."type" = 'ClienteEmpresa' then
    
      select
      into
              _empresa *
      from 
              empresa
      where
              id = _cliente.empresa_id;
      
      _rif_ci = _empresa.rif;
      _nombre_beneficiario = _empresa.nombre;
    else
    
      select
      into
              _persona *
      from
              persona
      where
              id = _cliente.persona_id;
              
      _rif_ci = _persona.cedula_nacionalidad || '-' || cast(_persona.cedula as character varying);
      _nombre_beneficiario = _persona.primer_nombre || ' ' || _persona.primer_apellido;
    
    end if;
    
    /*
    ----------------------------------
    Lectura de cuenta presupuestaria
    ----------------------------------
    */
    
    select
    into
            _cuenta_presupuestaria partida_presupuestaria.proyecto || '-' ||
                                    partida_presupuestaria.accion_especifica || '-' ||
                                    partida_presupuestaria.partida || '-' ||
                                    partida_presupuestaria.generica || '-' ||
                                    partida_presupuestaria.especifica || '-' ||
                                    partida_presupuestaria.sub_especifica
    from
          partida_presupuestaria
    where
          programa_id = _solicitud.programa_id and
          plazo_ciclo = _plazo;
          
    if not found then
    
      _cuenta_presupuestaria = 'Cuenta Inexistente';
      
    end if;
            
    /*
    ----------------------------------------------
    Insertando un registro en siga compromiso
    ----------------------------------------------
    */
    
    insert
    into
            siga_compromiso 
                  (fecha,
                   numero_solicitud,
                   nombre_programa,
                   cuenta_presupuestaria,
                   monto,
                   rif_ci,
                   nombre_beneficiario,
                   tipo_transaccion,
                   registrado)
            values
                 ( _fecha,
                  _solicitud.numero,
                  _programa.nombre,
                  _cuenta_presupuestaria,
                  _solicitud.monto_solicitado,
                  _rif_ci,
                  _nombre_beneficiario,
                  p_tipo_transaccion,
                  false);
            
  end if;             ---> if found then   solicitud

  
  return 0;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

