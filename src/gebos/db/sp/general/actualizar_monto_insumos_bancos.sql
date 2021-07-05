
CREATE OR REPLACE FUNCTION ActualizarMontosInsumosBancos()
  RETURNS boolean AS
$BODY$
declare
  _solicitud solicitud%rowtype;
  _plan_inversion plan_inversion%rowtype;
  _prestamo prestamo%rowtype;
  _caracterizacion unidad_produccion_caracterizacion%rowtype;
  _prestamo_id integer = 0;
  _solicitud_id integer = 0;
  _plan_inversion_id integer = 0;
  _cur_solicitud refcursor;
  _sub_sector sub_sector%rowtype;
  _monto_banco numeric(16,2) = 0;
  _monto_insumos numeric(16,2) = 0;
  
begin

  /*
  ------------------------------
  Abriendo Cursor de solicitud
  ------------------------------
  */
  
 	open _cur_solicitud for

		select
			    *
		from
			solicitud
		where
			estatus_id > 10004;


		loop
		
      /*
      -----------------------------------
      Recorrido del cursor de préstamos
      -----------------------------------
      */
      
      fetch _cur_solicitud INTO _solicitud;
      exit when not found;
      
      /*
      ---------------------------------------------------
      Lectura de sub_sector para verificar si es vegetal
      ---------------------------------------------------
      */
      
      select
      into
            _sub_sector *
      from
            sub_sector
      where
            id = _solicitud.sub_sector_id;
            
      if found then
        
        if _sub_sector.nemonico = 'VE' then
          
          /*
          --------------------------------------------------------
          Lectura de plan de inversión para actualizar hectareas
          recomendadas en el trámite
          --------------------------------------------------------
          */
          
          select 
          into
                 _plan_inversion *
          from
                 plan_inversion
          where
                 plan_inversion.solicitud_id = _solicitud.id limit 1;
                 
                 
          if found then
          
            /*
            ------------------------------------------------
            Actualizacion en la solicitud de las hectaeras
            recomendadas
            ------------------------------------------------
            */
            
            update
                   solicitud
            set
                   hectareas_recomendadas = _plan_inversion.cantidad
            where
                   solicitud.id = _solicitud.id;
                   
            /*
            ------------------------------------------------------
            Actualizacion en la solicitud de la superficie
            aprovechable en la unidad_produccion_caracterizacion
            ------------------------------------------------------
            */
            
            update 
                  unidad_produccion_caracterizacion
            set
                  superficie_aprovechable = _plan_inversion.cantidad
            where 
                  solicitud_id = _solicitud.id and
                  unidad_produccion_id = _solicitud.unidad_produccion_id;
                   
          end if;
          
        end if;
        
        /*
        ----------------------------------------------------------
        Actualización Monto de insumos y banco en el préstamos
        ----------------------------------------------------------
        */
        
        /*
        ---------------------------
        Totalizando monto_insumos
        ---------------------------
        */
        
        select 
        into
              _monto_insumos sum(monto_financiamiento)
        from
              plan_inversion
        where
              plan_inversion.solicitud_id = _solicitud.id and
              plan_inversion.tipo_item = 'I';
              
        select 
        into
              _monto_banco sum(monto_financiamiento)
        from
              plan_inversion
        where
              plan_inversion.solicitud_id = _solicitud.id and
              plan_inversion.tipo_item = 'B';
              
        if _monto_insumos is null then
           _monto_insumos = 0;
        end if;
        
        if _monto_banco is null then
           _monto_banco = 0;
        end if;
        
        /*
        ----------------------------
        Actualización del préstamo
        ----------------------------
        */
        
        update
               prestamo
        set
               monto_banco = _monto_banco,
               monto_insumos = _monto_insumos
        where
               prestamo.solicitud_id = _solicitud.id;
           
      end if;
      
   end loop;
   
   return true;
   
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
