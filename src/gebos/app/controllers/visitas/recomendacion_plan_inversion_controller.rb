# encoding: utf-8 
class Visitas::RecomendacionPlanInversionController < FormTabsController

 layout 'form_basic'


  def index
    @visitas = SeguimientoVisita.find(params[:id])
    @solicitud = @visitas.solicitud
  end

  def list
    solicitud_id = params[:solicitud_id]
    visita_id = params[:id]
    @tipo = params[:tipo]
    @visitas = SeguimientoVisita.find(visita_id)
    @prestamo=Prestamo.find_by_solicitud_id(solicitud_id)
    msg_error=""

    if @tipo == 'B'
      if (@prestamo.monto_banco_fm == @prestamo.monto_liquidado_fm)
        msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.no_existen_items')
        render :update do |page|
          page.alert msg_error
        end
        return false
      else
        # controlando el nro de desembolso el cual debe mostrar el list
        nro_desembolsos = Desembolso.find(:all, :conditions=>"solicitud_id =#{solicitud_id} and confirmado = true",:order=>"numero desc limit 1" )
        if nro_desembolsos.empty?
          #numero_desembolsos = 1
          numero_desembolsos_anterior = 1
        else
          #numero_desembolsos = nro_desembolsos[0].numero.to_i + 1
          numero_desembolsos_anterior = nro_desembolsos[0].detalles[0].plan_inversion.numero_desembolso.to_i + 1

          logger.debug "numero desembolso >>>>>>>>>> " << numero_desembolsos_anterior.to_s
          ##### Comparando el nro de desembolso contra el plan de inversión
          
          arreglo_numero_desembolso = PlanInversion.find(:all,:conditions=>"tipo_item='B' and solicitud_id =#{solicitud_id} and numero_desembolso >= #{numero_desembolsos_anterior}",:group=>"numero_desembolso",:select=>"numero_desembolso",:order=>"numero_desembolso",:limit=>1)

          logger.debug "Consulta >>>>>> " << arreglo_numero_desembolso.inspect.to_s

          if arreglo_numero_desembolso[0].nil?
             numero_desembolsos = 0
          else
             numero_desembolsos = arreglo_numero_desembolso[0].numero_desembolso
          end
        end
        ####
        desembolsos_solicitudes = Desembolso.find(:all, :conditions=>"solicitud_id =#{solicitud_id} and realizado = false and seguimiento_visita_id < #{visita_id}",:order=>"numero desc limit 1" )
        if desembolsos_solicitudes.empty?
            # En caso de que no exista desembolsos pendientes, validamos la fecha de registro del desembolso contra los días del cronograma de desembolso
            # Busco el nro del desembolso a recomendar chequeando contra el último anterior sumándole uno y la fecha de registro de ese desembolso
            desembolsos_anteriores = Desembolso.find(:all, :conditions=>"solicitud_id =#{solicitud_id} and confirmado = true",:order=>"numero desc limit 1" )
            logger.debug "VALIDANDO CONTRA CRONOGRAMA DESEMBOLSOS ANTERIORES " << desembolsos_anteriores.inspect
            fecha_registro_desembolso_anterior = desembolsos_anteriores[0].fecha_valor
            logger.debug "fecha_registro_desembolso_anterior ===> " << desembolsos_anteriores[0].fecha_registro.to_s
            logger.debug desembolsos_anteriores[0].fecha_registro.class.name
            if desembolsos_anteriores.empty?
                numero_desembolso = 1
            else
                numero_desembolso = desembolsos_anteriores[0].numero.to_i + 1
            end
            logger.debug "NUMERO DE DESEMBOLSO ===> " << numero_desembolso.to_s
            # Busco el rubro de la solicitud
            solicitud = Solicitud.find(solicitud_id)
            rubro_id = solicitud.rubro_id
            logger.debug "RUBRO ===> " << rubro_id.to_s
            # Busco en el cronograma de desembolso por el rubro y por el nro de desembolso
            cronograma_desembolso = CronogramaDesembolso.find_by_numero_desembolso_and_rubro_id(numero_desembolso,rubro_id)
            unless cronograma_desembolso.nil?
                tiempo = cronograma_desembolso.dias
                # Obtengo la fecha disponible del desembolso
                unless tiempo.to_i == 0
                    fecha_disponible_desembolso = (fecha_registro_desembolso_anterior + tiempo).strftime(I18n.t('time.formats.gebos_short2'))
                else
                    fecha_disponible_desembolso = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
                end
            else
                tiempo = 0
                fecha_disponible_desembolso = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
            end    
            logger.debug "TIEMPO PARA DISPONIBILIDAD ===> " << tiempo.to_s
            logger.debug "FECHA DISPONIBLE === " << fecha_disponible_desembolso.to_s

            # Convierto la fecha disponible para el mensaje
            fecha_mensaje = (fecha_disponible_desembolso.to_s).split("-")
            fecha_mensaje = (fecha_mensaje[0]+"/"+fecha_mensaje[1]+"/"+fecha_mensaje[2])

            # Obtengo la fecha de Hoy
            fecha_hoy = Time.now.strftime(I18n.t('time.formats.gebos_short2'))
            logger.debug "FECHA DE HOY ===> " << fecha_hoy.to_s
            # Comparo Las Fechas para efectuar la validación
            if (fecha_hoy.to_date - fecha_disponible_desembolso.to_date) < 0
                msg_error << "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.error_recomendar_plan_inversion')} #{numero_desembolso.to_s}, #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.debe_esperar_hasta_el_dia')} #{fecha_mensaje} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.segun_cronograma')}"
                render :update do |page|
                    page.alert msg_error
                end
                return false
            else
              # Continúo con el proceso
              @observacion = Desembolso.find_by_seguimiento_visita_id(visita_id)
              if @observacion
                  @observacion = @observacion.observacion
              end
              @plan_inversion = PlanInversion.find_by_sql("select id, solicitud_id, estado_nombre,oficina_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, partida_nombre, item_nombre,
              unidad_medida_id, numero_desembolso, costo_real, cantidad, monto_financiamiento , monto_desembolsado, seriales, marcas, tipo_item, cantidad_por_hectarea, costo_minimo, costo_maximo,
              case when id in (select plan_inversion_id from desembolso_detalle as dd,desembolso as d where dd.desembolso_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
              and d.seguimiento_visita_id=#{visita_id}) then 'checked' else '' end as marcado, (select dd.monto from desembolso_detalle as dd, desembolso as d where dd.desembolso_id=d.id and
              dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id} and d.seguimiento_visita_id=#{visita_id})as monto_enviado,
              case when (pd.monto_financiamiento <= pd.monto_desembolsado) then 'disabled' else '' end as disponible,
              case when (pd.monto_financiamiento = pd.monto_desembolsado) then 'true'
              when id in (select plan_inversion_id from desembolso_detalle as dd,desembolso as d where dd.desembolso_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
              and d.seguimiento_visita_id=#{visita_id}) then 'true' else 'false' end as inhabilitado,monto_financiamiento
              from plan_inversion as pd where solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso = #{numero_desembolsos} order by estado_nombre,oficina_nombre,sector_nombre,sub_sector_nombre,rubro_nombre,partida_nombre,item_nombre,tipo_item")
              @total_monto_financiamiento = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso = #{numero_desembolsos}")
              @total_monto_desembolsado = PlanInversion.sum(:monto_desembolsado, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso = #{numero_desembolsos}")
              unless  @total_monto_financiamiento 
                @total_monto_financiamiento = 0 
              end
              unless @total_monto_desembolsado 
                @total_monto_desembolsado = 0 
              end
        
              @total_monto_x_desembolsar = (@total_monto_financiamiento - @total_monto_desembolsado)
              @plan = @plan_inversion[0]
            end
        else
          msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.error_recomendar_plan_inversion_existe_desembolso')
          render :update do |page|
            page.alert msg_error
          end
          return false
        end
      end
    elsif @tipo == 'I'
      if (@prestamo.monto_insumos_fm == @prestamo.monto_despachado_fm)
        msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.no_existen_items_insumo')
        render :update do |page|
          page.alert msg_error
        end
        return false
      else
        #anterior despachos_solicitudes = OrdenDespacho.find(:all, :conditions=>"solicitud_id =#{solicitud_id} and fecha_cierre is not null and seguimiento_visita_id < #{visita_id}",:order=>"numero desc limit 1" )

        #eliminado el 4/9/2013 despachos_solicitudes = OrdenDespacho.find(:all, :conditions=>"solicitud_id =#{solicitud_id}  and seguimiento_visita_id < #{visita_id} and estatus_id <> 20040  and estatus_id <> 20030",:order=>"numero desc limit 1" )
        
        #cambio realizado N° 1 el 4/9/2013
        despachos_solicitudes = OrdenDespacho.find(:all, :conditions=>"solicitud_id =#{solicitud_id}  and seguimiento_visita_id < #{visita_id} and estatus_id <> 20040  and estatus_id <> 20030" )
        #fin cambio realizado N° 1 el 4/9/2013

        if despachos_solicitudes.empty?
          @observacion = OrdenDespacho.find_by_seguimiento_visita_id(visita_id)
          if @observacion
            @observacion = @observacion.observacion
          end
          @plan_inversion = PlanInversion.find_by_sql("select id, solicitud_id, estado_nombre,oficina_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, partida_nombre, item_nombre,
          unidad_medida_id, numero_desembolso, costo_real, cantidad, monto_financiamiento , monto_desembolsado, seriales, marcas, tipo_item, cantidad_por_hectarea, costo_minimo, costo_maximo,
          case when id in (select plan_inversion_id from orden_despacho_detalle as dd, orden_despacho as d where dd.orden_despacho_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
          and d.seguimiento_visita_id=#{visita_id}) then 'checked' else '' end as marcado, (select monto_recomendado from orden_despacho_detalle as dd, orden_despacho as d where dd.orden_despacho_id=d.id
          and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id} and d.seguimiento_visita_id=#{visita_id})as monto_enviado,
          case when (pd.monto_financiamiento <= pd.monto_desembolsado) then 'disabled' else '' end as disponible,
          case when (pd.monto_financiamiento = pd.monto_desembolsado) then 'true'
               when id in (select plan_inversion_id from desembolso_detalle as dd,desembolso as d where dd.desembolso_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
               and d.seguimiento_visita_id=#{visita_id}) then 'true' else 'false' end as inhabilitado,monto_financiamiento
          from plan_inversion as pd where solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1 order by estado_nombre,oficina_nombre,sector_nombre,sub_sector_nombre,rubro_nombre,partida_nombre,item_nombre,tipo_item")
          @total_monto_financiamiento = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1")
          @total_monto_desembolsado = PlanInversion.sum(:monto_desembolsado, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1")
          unless  @total_monto_financiamiento
            @total_monto_financiamiento = 0
          end
          unless @total_monto_desembolsado
            @total_monto_desembolsado = 0
          end
          @total_monto_x_desembolsar = (@total_monto_financiamiento - @total_monto_desembolsado)
          @plan = @plan_inversion[0]
        else
          #cambio realizado N° 2 el 4/9/2013
          unless verificacion_ordenes(despachos_solicitudes)
              @observacion = OrdenDespacho.find_by_seguimiento_visita_id(visita_id)
              if @observacion
                @observacion = @observacion.observacion
              end
              @plan_inversion = PlanInversion.find_by_sql("select id, solicitud_id, estado_nombre,oficina_nombre, sector_nombre, sub_sector_nombre, rubro_nombre, partida_nombre, item_nombre,
              unidad_medida_id, numero_desembolso, costo_real, cantidad, monto_financiamiento , monto_desembolsado, seriales, marcas, tipo_item, cantidad_por_hectarea, costo_minimo, costo_maximo,
              case when id in (select plan_inversion_id from orden_despacho_detalle as dd, orden_despacho as d where dd.orden_despacho_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
              and d.seguimiento_visita_id=#{visita_id}) then 'checked' else '' end as marcado, (select monto_recomendado from orden_despacho_detalle as dd, orden_despacho as d where dd.orden_despacho_id=d.id
              and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id} and d.seguimiento_visita_id=#{visita_id})as monto_enviado,
              case when (pd.monto_financiamiento <= pd.monto_desembolsado) then 'disabled' else '' end as disponible,
              case when (pd.monto_financiamiento = pd.monto_desembolsado) then 'true'
                   when id in (select plan_inversion_id from desembolso_detalle as dd,desembolso as d where dd.desembolso_id=d.id and dd.plan_inversion_id=pd.id and d.solicitud_id=#{solicitud_id}
                   and d.seguimiento_visita_id=#{visita_id}) then 'true' else 'false' end as inhabilitado,monto_financiamiento
              from plan_inversion as pd where solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1 order by estado_nombre,oficina_nombre,sector_nombre,sub_sector_nombre,rubro_nombre,partida_nombre,item_nombre,tipo_item")
              @total_monto_financiamiento = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1")
              @total_monto_desembolsado = PlanInversion.sum(:monto_desembolsado, :conditions=>"solicitud_id = #{solicitud_id} and tipo_item = '#{params[:tipo]}' and numero_desembolso > 1")
              unless  @total_monto_financiamiento
                @total_monto_financiamiento = 0
              end
              unless @total_monto_desembolsado
                @total_monto_desembolsado = 0
              end
              @total_monto_x_desembolsar = (@total_monto_financiamiento - @total_monto_desembolsado)
              @plan = @plan_inversion[0]          
          else
              #fin cambio realizado N° 2 el 4/9/2013
              msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.error_recomendar_plan_insumo')
              render :update do |page|
                page.alert msg_error
              end
              return false
          end #end perteneciente al cambio N° 2 el 4/9/2013
        end
      end
    else
        msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.debe_seleccionar_item')
        render :update do |page|
          page.alert msg_error
        end
        return false
    end
    logger.info "============+ Plan Inversion List:"<< @plan_inversion.inspect
    form_list
  end

  #cambio realizado N° 3 el 4/9/2013
  def verificacion_ordenes(ordenes)
  
  ordenes.each{|orden|
      if OrdenDespachoDetalle.sum(:cantidad,:conditions=>"orden_despacho_id=#{orden.id}")!=OrdenDespachoDetalle.sum(:cantidad_facturacion,:conditions=>"orden_despacho_id=#{orden.id}")  
        return true
      end
  }
  return false
  end
  #fin cambio realizado N° 3 el 4/9/2013

  def save_edit

    items = params[:plan_inversion_id]
    item = params[:plan_inversion_id]
    tipo = params[:tipo]
    visita_id = params[:id]
    observacion = params[:observacion]
    logger.debug "===============> OBSERVACION"
    logger.debug params[:observacion].to_s
    @visitas = SeguimientoVisita.find(visita_id)

    solicitud = @visitas.solicitud
    prestamo_id = solicitud.prestamos[0].id
    solicitud_id = solicitud.id
    fecha_valor = Time.now
    estado_id = solicitud.unidad_produccion.ciudad.estado_id

    sucede = true
    msg_error =""
    if (item.length == 0)
      msg_error << I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.debe_selecciona_almenos_un_item')
      render :update do |page|
         page.alert msg_error
         page<< "document.getElementById('button_save').disabled = false"
      end
      return false

    end
    item = item.split(',')
    item.each { |i|
      plan = PlanInversion.find(i)
      logger.debug "Item nro. "<< plan.id.to_s
      monto_recomendado = params[:"monto_recomendado_#{plan.id}"].to_f
      monto_x_desembolsar = plan.monto_financiamiento.to_f - plan.monto_desembolsado.to_f

      if  monto_recomendado >  monto_x_desembolsar
          msg_error << "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.monto_recomendado')} '#{plan.item_nombre}' #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Errores.es_mayor_monto_desembolsar')}"
          sucede = false

      end
    }

    if sucede == true
      if tipo == 'B'
        desembolso = Desembolso.find_by_seguimiento_visita_id(visita_id)
        unless desembolso.nil?
          ActiveRecord::Base.connection.execute("delete from desembolso_detalle where desembolso_id = #{desembolso.id}")
          ActiveRecord::Base.connection.execute("delete from desembolso where id = #{desembolso.id}")
          
          #agregado el 5/9/2013
          
          #aqui debe colocar toda la información para generar el desembolso
          desembolsos_solicitudes = Desembolso.find(:all, :conditions=>"solicitud_id =#{solicitud_id}",:order=>"numero desc limit 1" )
          if desembolsos_solicitudes.empty?
            numero = 1
          else
            numero = desembolsos_solicitudes[0].numero.to_i + 1
          end
          # Buscando información relacionada a la cuenta bancaria
          @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['activo = true and cliente_id = ?',solicitud.cliente.id])
          if @cuenta_bancaria == nil
            modalidad = "C"
            cta_entidad_financiera_id = nil
            cta_tipo = nil
            cta_numero = nil
          else
            modalidad = "T"
            cta_entidad_financiera_id = @cuenta_bancaria.entidad_financiera_id
            cta_tipo = @cuenta_bancaria.tipo
            cta_numero = @cuenta_bancaria.numero
          end

          # Crea un nuevo registro en la tabla desembolso
          Desembolso.create(
            :solicitud_id =>solicitud_id,
            :prestamo_id=>prestamo_id,
            :usuario_id=>@usuario.id,
            :entidad_financiera_id=>cta_entidad_financiera_id,
            :tipo_cuenta=>cta_tipo,
            :numero_cuenta=>cta_numero,
            :seguimiento_visita_id=>@visitas.id,
            :monto=>0,
            :numero=>numero,
            :realizado=>false,
            :confirmado=>false,
            :observacion=>observacion,
            :modalidad=>modalidad
            )
          
          #fin agregado el 5/9/2013
          
        else
          #aqui debe colocar toda la información para generar el desembolso
          desembolsos_solicitudes = Desembolso.find(:all, :conditions=>"solicitud_id =#{solicitud_id}",:order=>"numero desc limit 1" )
          if desembolsos_solicitudes.empty?
            numero = 1
          else
            numero = desembolsos_solicitudes[0].numero.to_i + 1
          end
          # Buscando información relacionada a la cuenta bancaria
          @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['activo = true and cliente_id = ?',solicitud.cliente.id])
          if @cuenta_bancaria == nil
            modalidad = "C"
            cta_entidad_financiera_id = nil
            cta_tipo = nil
            cta_numero = nil
          else
            modalidad = "T"
            cta_entidad_financiera_id = @cuenta_bancaria.entidad_financiera_id
            cta_tipo = @cuenta_bancaria.tipo
            cta_numero = @cuenta_bancaria.numero
          end

          # Crea un nuevo registro en la tabla desembolso
          Desembolso.create(
            :solicitud_id =>solicitud_id,
            :prestamo_id=>prestamo_id,
            :usuario_id=>@usuario.id,
            :entidad_financiera_id=>cta_entidad_financiera_id,
            :tipo_cuenta=>cta_tipo,
            :numero_cuenta=>cta_numero,
            :seguimiento_visita_id=>@visitas.id,
            :monto=>0,
            :numero=>numero,
            :realizado=>false,
            :confirmado=>false,
            :observacion=>observacion,
            :modalidad=>modalidad
            )
        end
        #desembolso_detalle
        success = true
        desembolso = Desembolso.find_by_seguimiento_visita_id(visita_id)
        # ojo el unless es nuevo
        unless desembolso.nil?
        desembolso.observacion = observacion
        desembolso.save
        end
        if solicitud.sub_sector.nemonico=="VE"
          success &&=desembolso.generar_detalle_desembolso_v(items, @usuario) unless desembolso.nil?
        else
          success &&=desembolso.generar_detalle_desembolso_g(items, params, @usuario) unless desembolso.nil?
        end

        if success
          total_items = DesembolsoDetalle.count(:conditions=>"desembolso_id = #{desembolso.id}") unless desembolso.nil?
          monto_des="0,00"
          monto_des=desembolso.monto_fm  unless desembolso.nil?          

          render :update do |page|
            if total_items == 1
              mensaje = "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.se_ha_recomendado_plan_inversion_un_item')} #{monto_des} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.complemento_un_item')}" 
            else
              mensaje = "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.se_ha_recomendado_plan_inversion_total_item')} #{total_items} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.de_tipo_banco')} #{monto_des} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.complemento_un_item')}" 
            end
            page.replace_html 'messages',mensaje
            page.show 'messages'
            page.<< "window.scrollTo(0,0);"
          end
        else
          render :update do |page|
             page.hide 'messages'
             page.alert desembolso.errors.full_messages.to_s
             page<< "document.getElementById('button_save').disabled = false"
          end
          return false
        end

      else
       
        despacho = OrdenDespacho.find_by_seguimiento_visita_id(visita_id)
        unless despacho.nil?
          ActiveRecord::Base.connection.execute("delete from orden_despacho_detalle where orden_despacho_id = #{despacho.id}")
          ActiveRecord::Base.connection.execute("delete from orden_despacho where id = #{despacho.id}")      
          
          #agregado el 5/9/2013
          
          # aqui se debe colocar toda la información para generar la orden de despacho
            total_despachos = OrdenDespacho.count()
            if total_despachos == 0
              correlativo = 1
            else
              correlativo = total_despachos.to_i + 1
            end
            numero = solicitud.numero.to_s<<'-'<<solicitud.prestamos[0].numero.to_s<<'-'<<fecha_valor.strftime('%Y')<<'-'<<'%04d' % correlativo

            # Crea un nuevo registro en la tabla Orden Despacho
            OrdenDespacho.create(
              :solicitud_id =>solicitud_id,
              :prestamo_id=>prestamo_id,
              :usuario_id=>@usuario.id,
              :fecha_orden_despacho=>fecha_valor.strftime(I18n.t('time.formats.gebos_short2')),
              :seguimiento_visita_id=>@visitas.id,
              :estatus_id=>20000,
              :monto=>0,
              :numero=>numero,
              :estado_id=>estado_id,
              :realizado=>true,
              :observacion=>observacion
              )      
          
          #fin agregado el 5/9/2013
              
        else  
          
            # aqui se debe colocar toda la información para generar la orden de despacho
            total_despachos = OrdenDespacho.count()
            if total_despachos == 0
              correlativo = 1
            else
              correlativo = total_despachos.to_i + 1
            end
            numero = solicitud.numero.to_s<<'-'<<solicitud.prestamos[0].numero.to_s<<'-'<<fecha_valor.strftime('%Y')<<'-'<<'%04d' % correlativo

            # Crea un nuevo registro en la tabla Orden Despacho
            OrdenDespacho.create(
              :solicitud_id =>solicitud_id,
              :prestamo_id=>prestamo_id,
              :usuario_id=>@usuario.id,
              :fecha_orden_despacho=>fecha_valor.strftime('%d/%m/%Y'),
              :seguimiento_visita_id=>@visitas.id,
              :estatus_id=>20000,
              :monto=>0,
              :numero=>numero,
              :estado_id=>estado_id,
              :realizado=>true,
              :observacion=>observacion
              )      
        
        end
        #orden_despacho_detalle
        success = true
        despacho = OrdenDespacho.find_by_seguimiento_visita_id(visita_id)
        # ojo el unless es nuevo
        unless despacho.nil?
        despacho.observacion = observacion
        despacho.save
        end

        if solicitud.sub_sector.nemonico=="VE"
          success &&=despacho.generar_detalle_despacho_v(items) unless despacho.nil?
        else
          success &&=despacho.generar_detalle_despacho_g(items, params) unless despacho.nil?
        end

        if success
          total_items = OrdenDespachoDetalle.count(:conditions=>"orden_despacho_id = #{despacho.id}") unless despacho.nil?
          monto_item="0,00"
          monto_item=despacho.monto_fm  unless despacho.nil?          
          render :update do |page|
            if total_items == 1
              mensaje = "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.se_ha_recomendado_plan_inversion_un_item_insumo')} #{monto_item} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.complemento_un_item')}"
            else
              mensaje = "#{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.se_ha_recomendado_plan_inversion_total_item')} #{total_items} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.de_tipo_insumo')} #{monto_item} #{I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.Messages.complemento_un_item')}"
            end
            page.replace_html 'messages',mensaje
            page.show 'messages'
            #page.redirect_to :action=>'index', :id=>@visitas.id, :popup=>params[:popup]
          end

        else
          render :update do |page|
             page.hide 'messages'
             page.alert despacho.errors.full_messages.to_s
             page<< "document.getElementById('button_save').disabled = false"
          end
          return false
        end

      end
    else

      render :update do |page|
         page.alert msg_error
         page<< "document.getElementById('button_save').disabled = false"
      end
      return false
    end
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    render :update do |page|
      page.redirect_to :action=>'index', :id=>@visitas.id, :popup=>params[:popup]
    end
  end

  protected
  def common
    super
    @visita = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.RecomendacionPlanInversion.FormTitles.form_title_records')
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '1080'
    @full_info = "#{@visita.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visita.solicitud.numero} (#{@visita.solicitud.nombre})"

    end


end

