-- Function: apertura_comite()

-- DROP FUNCTION apertura_comite();

CREATE OR REPLACE FUNCTION apertura_comite(p_numero_comite character varying, p_comite_id integer, p_tipo char, p_oficina_id integer)
  RETURNS bool AS
$BODY$
declare
  
  _rechazos rechazos%rowtype;
  _solicitud solicitud%rowtype;
  _prestamo prestamo%rowtype;
  _programa programa%rowtype;
  _presupuesto_pidan presupuesto_pidan%rowtype;
  _plan_pago plan_pago%rowtype;
  _plan_pago_cuota plan_pago_cuota%rowtype;
  _desembolso desembolso%rowtype;
  _fecha_proceso_next date;

  -- Cursor para recorrer los programas sociales y efectuar el cierre diario de cartera
  _cur_solicitudes refcursor;
  _cur_desembolso refcursor;
  _cur_view_total_compromiso refcursor;
 

begin

  /*
  -------------------------------------------------------------------------
  Actualizar solicitudes con numero de comité y id del comité e insertar
  registro correspondiente en la tabla comite_decision_historico
  
   ************************ COMITE NACIONAL ***********************
  -------------------------------------------------------------------------
  */
  
  if p_tipo = 'N' then
  
    open _cur_solicitudes for
      select
              *
      from
              solicitud
      where
              estatus_id=10034 and 
              comite_estadal_id is not null and 
              ( comite_id IS NULL or decision_comite_nacional='D' );
              
  
      loop

        fetch _cur_solicitudes INTO _solicitud;
        exit when not found;
        
          update 
                  solicitud
          set
                  numero_comite_nacional = p_numero_comite,
                  comite_id = p_comite_id,
                  decision_comite_nacional = null,
                  comentario_comite_nacional = null
          where
                  id = _solicitud.id;
                  
          insert
          into
                  comite_decision_historico
                                              (solicitud_id,
                                               comite_id,
                                               tipo_comite,
                                               oficina_id)
                              values
                                              (_solicitud.id,
                                               p_comite_id,
                                               'n',
                                               _solicitud.oficina_id);
        
      end loop;
      
      close _cur_solicitudes;
              
  end if;
  
  /*
  -------------------------------------------------------------------------
  Actualizar solicitudes con numero de comité y id del comité e insertar
  registro correspondiente en la tabla comite_decision_historico
  
   ************************* COMITE ESTADAL ***********************
  -------------------------------------------------------------------------
  */
    
  if p_tipo = 'E' then
  
    open _cur_solicitudes for
      select
              *
      from
              solicitud
      where
              estatus_id=10033 and 
              oficina_id=p_oficina_id and 
              ( comite_id IS NULL or decision_comite_estadal='D' );
              
      loop

        fetch _cur_solicitudes INTO _solicitud;
        exit when not found;
        
          update 
                  solicitud
          set
                  numero_comite_estadal = p_numero_comite,
                  comite_estadal_id = p_comite_id,
                  decision_comite_estadal = null,
                  comentario_comite_estadal = null
          where
                  id = _solicitud.id;
                  
          insert
          into
                  comite_decision_historico
                                              (solicitud_id,
                                               comite_id,
                                               tipo_comite,
                                               oficina_id)
                              values
                                              (_solicitud.id,
                                               p_comite_id,
                                               'e',
                                               _solicitud.oficina_id);
        
      end loop;
      
      close _cur_solicitudes;
              
  end if;
  
  return true;
 
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

