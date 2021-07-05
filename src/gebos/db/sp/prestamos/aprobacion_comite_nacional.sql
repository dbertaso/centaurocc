-- Function: aprobacion_comite_nacional()

-- DROP FUNCTION aprobacion_comite_nacional();

CREATE OR REPLACE FUNCTION aprobacion_comite_nacional(  p_solicitudes character varying[],
                                                          p_hay_items boolean,
                                                          p_tipo_decision char,
                                                          p_comentario text,
                                                          p_usuario_id integer)
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
  _unidad_produccion unidad_produccion%rowtype;
  _estado_id integer;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;
  _solicitud_id integer;
  _estatus_id_inicial integer;
  _estatus_id_final integer;
  _solicitud_fecha_aprobacion date;
  _solicitud_monto_aprobado numeric(16,2);
  _result integer = 0;
  
  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_solicitudes refcursor;
  _cur_desembolso refcursor;
  _cur_view_total_compromiso refcursor;
 

begin

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
  
  if p_hay_items = true then

    raise info 'Solicitudes ==========> %', p_solicitudes;
    raise info 'Array Lower ==========> %', array_lower(p_solicitudes,1);
    raise info 'Array Upper ==========> %', array_upper(p_solicitudes,1);  
    
    for i in array_lower(p_solicitudes,1) .. array_upper(p_solicitudes,1) 
      loop

        _solicitud_id = cast(p_solicitudes[i] as integer);
        
        raise notice 'Solicitud ID =============> %', _solicitud_id;
           
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
                solicitud.id = _solicitud_id;
                  
        if found then
        
          raise notice 'Encontró Solicitud';
          select 
          into 
                _unidad_produccion *
          from
                unidad_produccion
          where
                id = _solicitud.unidad_produccion_id;
                
          if not found then
            return 3;         --unidad de producción no existe
          end if;
            
          select
          into
                _estado_id estado_id
          from
                ciudad
          where
                id = _unidad_produccion.ciudad_id;
                  
          if not found then
          
            return 4;        --No existe ciudad asignada en unidad producción
          end if;
          
          _estatus_id_inicial = _solicitud.estatus_id;
          _estatus_id_final = _solicitud.estatus_id;
            
          /*
          -------------------------------------------------
          Lectura de la tabla configuracion_avance
          para determinar el próximo estatus del trámite
          -------------------------------------------------
          */
            
          if p_tipo_decision = 'A' then

            _estatus_id_final = 10040;
            _solicitud_fecha_aprobacion = current_timestamp;
            _solicitud_monto_aprobado = _solicitud.monto_solicitado;
            
          end if;
            
          if p_tipo_decision = 'R' then
          
            _estatus_id_final = 10035;
            _solicitud_fecha_aprobacion = null;
            _solicitud_monto_aprobado = 0;
            
            if _solicitud.por_inventario = true then
            
              update
                      catalogo 
              set 
                      solicitud_id = null, 
                      estatus = 'L' 
              where 
                      solicitud_id = _solicitud.id;
            else
            
              /*
              ----------------------------------------------------------
              Lectura de presupuesto_pidan para revertir el compromiso
              ----------------------------------------------------------
              */
            
              select
              into
                      _presupuesto_pidan *
              from 
                      presupuesto_pidan
              where
                      programa_id = _solicitud.programa_id and
                      estado_id = _estado_id and
                      rubro_id = _solicitud.rubro_id and
                      sub_rubro_id = _solicitud.sub_rubro_id;
                      
              if not found then
                return 5;     -- Registro de presupuesto pidan no existe
                raise notice 'No encontró el registro del pidan en nacional';
              end if;
            
              update
                      presupuesto_pidan
              set
                      compromiso = compromiso - _solicitud.monto_solicitado,
                      disponibilidad = disponibilidad + _solicitud.monto_solicitado
              where
                      id = _presupuesto_pidan.id;
                      
              /*
              --------------------------------------------------------------
              Llamada a la función que inserta registro en siga_compromiso
              --------------------------------------------------------------
              */
              
              perform generar_compromiso(_solicitud.id, 'R');
                                   
            end if;       ---> if _solicitud.por_inventario = true then
          
          end if;         ---> if p_tipo_decision = 'R' then
            
          if p_tipo_decision = 'D' then
          
            _solicitud_fecha_aprobacion = null;
            _solicitud_monto_aprobado = 0;
          end if;
            
          /*
          -------------------------------
          Actualización de la solicitud
          -------------------------------
          */
          
          update
                  solicitud
          set
                  decision_comite_nacional = p_tipo_decision,
                  comentario_comite_nacional = p_comentario,
                  estatus_id = _estatus_id_final,
                  fecha_aprobacion = _solicitud_fecha_aprobacion,
                  monto_aprobado = _solicitud_monto_aprobado
          where
                  id = _solicitud.id;
                    
          /*
          ---------------------------------------
          Lectura de comite_decision_historico
          ---------------------------------------
          */
          
          select
          into
                _cdh *
          from
                comite_decision_historico
          where
                solicitud_id = _solicitud_id and
                comite_id = _solicitud.comite_id;
                
          if not found then
          
            return 6;       --- No existe registro de comite historico
          end if;
            
          /*
          --------------------------------------------
          Actualización de comite_decision_historico
          --------------------------------------------
          */
          
          update
                  comite_decision_historico
          set
                  decision = p_tipo_decision,
                  comentario = p_comentario,
                  fecha_decision = _solicitud_fecha_aprobacion
          where
                  id = _cdh.id;
                    
          /*
          ----------------------------------------------
          Insertando un registro en control_solicitud
          ----------------------------------------------
          */
          
          if _solicitud_fecha_aprobacion is null then
          
            _solicitud_fecha_aprobacion = current_timestamp;
          
          end if;
                      
          insert
          into
                control_solicitud 
                      (solicitud_id,
                       estatus_id,
                       usuario_id,
                       fecha,
                       estatus_origen_id,
                       comentario,
                       accion)
                values
                       (_solicitud_id,
                        _estatus_id_final,
                        p_usuario_id,
                        _solicitud_fecha_aprobacion,
                        _estatus_id_inicial,
                        p_comentario,
                        'avanzar');
                  
        end if;             ---> if found then   solicitud
          
      end loop;
    
  end if;
  
  return 0;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

