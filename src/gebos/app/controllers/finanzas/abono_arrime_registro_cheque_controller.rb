# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::AbonoArrimeRegistroChequeController
# descripción: Migración a Rails 3
#


class Finanzas::AbonoArrimeRegistroChequeController < FormTabsController

 layout 'form_basic'

skip_before_filter :set_charset, :only=>[:generar_tabla, :sub_sector_search, :sector_search, :rubro_search, :sub_rubro_search]

  def index
    @sector_select = Sector.find(:all, :conditions=>"activo=true", :order=>'nombre')
    @estado_select = Estado.find(:all, :order=>'nombre')
    @sub_sector_select = []
    @rubro_select = []
    @sub_rubro_select =[]
    @actividad_select=[]
  end

   def list
    params['sort'] = "fecha_valor" unless params['sort']
    condition = "estatus_excedente = 30060 and numero_cuenta is null "

    unless params[:estado][:id]==''        
        condition << " and estado_id = #{params[:estado][:id]}"        
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(params[:estado][:id]).nombre}'"
    end
    

     
      unless params[:sector_id].nil?
        unless params[:sector_id][0].to_s==''
          condition << " and sector_id = #{params[:sector_id][0]}"        
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(params[:sector_id][0]).nombre}'"
        end      
      end
    
  
      unless params[:sub_sector_id].nil?
        unless params[:sub_sector_id][0].to_s==''
          condition << " and sub_sector_id = #{params[:sub_sector_id][0]}"        
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{SubSector.find(params[:sub_sector_id][0]).nombre.to_s}'"
        end        
      end
        
      unless params[:rubro_id].nil?
        unless params[:rubro_id][0].to_s==''
          condition << " and rubro_id = #{params[:rubro_id][0]}"        
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(params[:rubro_id][0]).nombre}'"
        end
      end
    

    
      unless params[:sub_rubro_id].nil?
        unless params[:sub_rubro_id][0].to_s==''
          condition << " and sub_rubro_id = #{params[:sub_rubro_id][0]}"
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(params[:sub_rubro_id][0]).nombre}'"
        end        
      end
    


    
      unless params[:actividad_id].nil?
        unless params[:actividad_id][0].to_s==''
          condition << " and actividad_id = #{params[:actividad_id][0]}"
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(params[:actividad_id][0]).nombre}'"
        end
      end
    



    if params[:solicitud]
      unless params[:solicitud].nil? || params[:solicitud].empty?
        condition << " and nro_tramite = #{params[:solicitud]}"        
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:solicitud]}'"
      end
    end

    if params[:nombre]
      unless params[:nombre].nil? || params[:nombre].empty?
        condition << " and upper(beneficiario) like UPPER('%#{params[:nombre]}%')"        
		    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_beneficiario')} '#{params[:nombre]}'"
      end
    end

    if params[:cedula]
      unless params[:cedula].nil? || params[:cedula].empty?
        condition << " and cedula_rif like '%#{params[:tipo]+params[:cedula]}%'"        
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo]+params[:cedula]}'"
      end
    end

    logger.info "Condiciones de la consulta: ----> " << condition.to_s

    
    @list = ViewExcedenteArrime.search(condition, params[:page], params['sort'])    
    @total=@list.count
    form_list

  end



  def list_view

     params['sort'] = "fecha_actual_estatus" unless params['sort']
    condition = "estatus_id in (10015, 10022)"

    if params[:estado]

      logger.info "Parametros ==========> #{params.inspect}"
      estado_id = params[:estado]

      unless estado_id[:id].nil? || estado_id[:id].empty?
        condition << " and estado_id = #{estado_id[:id]}"
        estado = Estado.find(estado_id[:id].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{estado.nombre}'"
      end
    end

     if params[:sector_id]
      logger.info "Parametros ==========> #{params.inspect}"
      sector_id = params[:sector_id]

      unless sector_id.nil? || sector_id.empty?
        condition << " and sector_id = #{sector_id}"
        sector = Sector.find(sector_id.to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
      end
    end

    if params[:sub_sector_id]

      logger.info "Parametros ==========> #{params.inspect}"
      unless params[:sub_sector_id].nil? || params[:sub_sector_id].empty?
        condition << " and sub_sector_id = #{params[:sub_sector_id]}"
        sub_sector= SubSector.find(params[:sub_sector_id].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{sub_sector.nombre.to_s}'"
      end
    end

    if params[:rubro_id]
      logger.info "Parametros ==========> #{params.inspect}"
      unless params[:rubro_id].nil? || params[:rubro_id].empty?
        condition << " and rubro_id = #{params[:rubro_id]}"
        rubro = Rubro.find(params[:rubro_id].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
      end
    end


    if params[:solicitud]
    unless params[:solicitud].nil? || params[:solicitud].empty?
      condition << " and numero_solicitud = #{params[:solicitud]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:solicitud]}'"
    end
    end
    if params[:nombre]
    unless params[:nombre].nil? || params[:nombre].empty?
      condition << " and upper(nombre) like UPPER('%#{params[:nombre]}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_beneficiario')} '#{params[:nombre]}'"
    end
    end
    if params[:cedula]
    unless params[:cedula].nil? || params[:cedula].empty?
      condition << " and cedula_rif like '%#{params[:cedula]}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:cedula]}'"
    end
    end
    logger.info "Condiciones de la consulta: ----> " << condition.to_s

    
    @list = ViewGeneracionTabla.search(condition, params[:page], params['sort'])    
    @total=@list.count
    form_list_view

  end

  def generar_tabla

    logger.info "Parametros =====> " << params.inspect

    ids = params[:orden_abono_excedente_arrime_id]
    if ids.nil? || ids.empty?
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><li>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.no_se_puede_registrar_cheque')}.</li></UL></p>".html_safe
        page.<< "window.scrollTo(0,0);"
        page.<< "varEnviado=false;$('button_save').disabled=false"
        page.show 'errorExplanation'
      end
      return false
    end

    ids = ids.gsub('%252C',',')

    errores = ""
    
    logger.debug "id " << ids.to_s
    
    orden_abono_excedente_arrimes = ViewExcedenteArrime.find(:all, :conditions=>["orden_abono_excedente_arrime_id in (#{ids[0,ids.to_s.length - 1]})"])
    orden_abono_excedente_arrimes.each do |i|
      logger.debug "REVISAR CAMPO FECHA  " << params["fecha_registro_cheque_#{i.orden_abono_excedente_arrime_id}"].to_s
      logger.debug "REVISAR CAMPO NUMERO  " << params["numero_cheque_#{i.orden_abono_excedente_arrime_id}"].to_s
      
      
      errores << i.validar(i,params["fecha_registro_cheque_#{i.orden_abono_excedente_arrime_id}"], params["numero_cheque_#{i.orden_abono_excedente_arrime_id}"])
    end

    if errores.length > 0
       render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.html_safe << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
       end
       return false
    end
    
    orden_abono_excedente_arrime = ViewExcedenteArrime.find(:first)
    id = orden_abono_excedente_arrime.registrar_cheque(params, session[:id])
    #PREPARANDO DATOS DEL MENSAJE PERSONALIZADO
    texto = "#{I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')}: "
    if id != "" || id.length > 1     
      cantidad = 0
      id.each {|i|
        orden = OrdenAbonoExcedenteArrime.find(i)
        texto = texto  << orden.solicitud.numero.to_s << ", "
        cantidad = cantidad +1 
      }
      texto = texto[0,(texto.length-2)]
      cantidad == 1 ? cantidad = cantidad.to_s << " #{I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')} " : cantidad = cantidad.to_s << " #{I18n.t('Sistema.Body.Modelos.Errores.tramites')} " 
    #FIN
    
    
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.hide 'errorExplanation'
        id.each {|i|
          page.remove "row_#{i}"
        }
        page.<< 'document.getElementById("orden_abono_excedente_arrime_id").value = "";document.getElementById("orden_abono_excedente_arrime_id").value = "";'
        page.replace_html 'message', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.la_informacion_de_los_cheques')} <a title='#{texto.to_s}' href='#'>".html_safe << cantidad.html_safe << "</a> #{I18n.t('Sistema.Body.Controladores.Mensaje.actualizacion')}".html_safe
        page.show 'message'
      end
    else
        render :update do |page|
        page.hide 'message'
        page.hide 'error'
        numeros = ''
        unless id.nil?
          id.each {|i|
            orden = OrdenAbonoExcedenteArrime.find(i)
            numeros += orden.solicitud.numero.to_s + ' ' unless orden.nil?
          }
        end
        page.<< 'document.getElementById("orden_abono_excedente_arrime_id").value = "";document.getElementById("orden_abono_excedente_arrime_id").value = "";'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_actualizacion_datos_cheque')}</h2><p><UL>".html_safe << numeros.html_safe
        page.show 'errorExplanation'
       end
    end
  end



  def generar_filtro
    view_liquidacion = ViewLiquidacion.find(:all,:conditions=>params[:filtro].gsub('true','false'),:order=>'tipo_cliente_id, numero_grupo')
    unless view_liquidacion.length > 0
      render :update do |page|      
         page.alert I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.no_se_puede_generar_archivo_sin_registro')
      end
      return
    end
    solicitudes = []
    resultado = []
    cont = 0
    monto = 0.0
    datos = ''
    nombre = ''
    clase = "lista0"
    tipo_cliente_id = 0
    cuenta_matriz = view_liquidacion[0].cuenta_matriz.to_s
    errores = []

    view_liquidacion.each { |solicitud|
      total_grupo = 0
      total_solicitudes = 0
      if solicitud.tipo_cliente_id == 23
        unless errores.include?(solicitud.numero_grupo)
          filtro = params[:filtro].gsub('true','false')
          filtro = filtro.gsub('(estatus_id = 11 or estatus_desembolso_id = 11 )','estatus_id > 10')
          grupo = Grupo.find(:first,:conditions=>"numero = #{solicitud.numero_grupo}")
          filtro << " and solicitud_id in (select id from solicitud where cliente_id in (select id from cliente where persona_id in (select persona_id from grupo_integrante where grupo_id = #{grupo.id} )))"
          total_solicitudes = ViewLiquidacion.count(:conditions=>filtro)
          total_grupo = GrupoIntegrante.count(:conditions=>"grupo_id = #{grupo.id}")
        else
          total_grupo = 1
        end
      end
      if total_grupo > total_solicitudes
        unless errores.include?(solicitud.numero_grupo)
          errores << solicitud.numero_grupo
        end
      else
        if solicitud.tipo_cliente_id == 1
          tipo_cliente = 1
        else
          tipo_cliente = 22
        end
        if tipo_cliente_id == tipo_cliente
          cont = cont + 1
          if solicitud.tipo_cliente_id == 22 || solicitud.tipo_cliente_id == 23
            monto = monto + solicitud.monto_solicitado
          else
            cronograma_desembolso = CronogramaDesembolso.find(:first,:conditions=>"solicitud_id = #{solicitud.solicitud_id}",:order=>'id')
            monto = monto + cronograma_desembolso.monto
          end
          solicitudes << solicitud.solicitud_id.to_s
        else
          unless tipo_cliente_id == 0
            datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>".html_safe
            resultado << datos
            if solicitud.entidad_financiera_id == 1
              generar_biv(nombre,solicitudes)
            else
              valores = [solicitud.cuenta_matriz,monto,cont]
              generar_bfa(nombre,solicitudes,valores)
            end
          end
          solicitudes = []
          solicitudes << solicitud.solicitud_id.to_s
          fecha = Time.now
          if solicitud.entidad_financiera_id == 1 && solicitud.tipo_cliente_id == 1
            nombre = 'BIV_LIQUIDACION_COOPERATIVA_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          elsif solicitud.entidad_financiera_id == 1 && solicitud.tipo_cliente_id != 1
            nombre = 'BIV_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          elsif solicitud.entidad_financiera_id == 150 && solicitud.tipo_cliente_id == 1
            nombre = 'BANFOANDES_LIQUIDACION_COOPERATIVA_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          else
            nombre = 'BANFOANDES_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          end
          if solicitud.tipo_cliente_id != 1
            tipo_cliente_id = 22
            monto = solicitud.monto_solicitado
          else
            tipo_cliente_id = 1
            cronograma_desembolso = CronogramaDesembolso.find(:first,:conditions=>"solicitud_id = #{solicitud.solicitud_id}",:order=>'id')
            monto = cronograma_desembolso.monto
          end
          cont = 1
          if clase == "lista0"
            clase = "lista1"
          else
            clase = "lista0"
          end
        end
      end
    }
    solicitud = view_liquidacion[0]
    if solicitud.entidad_financiera_id == 1
      generar_biv(nombre,solicitudes)
    else
      valores = [solicitud.cuenta_matriz,monto,cont]
      generar_bfa(nombre,solicitudes,valores)
    end
    if datos.length > 0
      datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>".html_safe
    end

    resultado << datos
    render :update do |page|
      page.redirect_to :action=>'resultado', :result=>resultado, :errores=>errores, :popup=>params[:popup]
    end
  end

  def generar_seleccion
    ids = params[:cuenta_id]
    if ids.include? ','
      ids = ids[0,ids.length - 1]
    end
    if ids.nil? || ids.empty?
      render :update do |page|         
         page.alert I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.no_se_puede_generar_archivo_sin_registro_debe_seleccionar')
      end
      return
    end
    view_liquidacion = ViewLiquidacion.find(:all,:conditions=>"solicitud_id in (#{ids})",:order=>'tipo_cliente_id, numero_grupo')
    solicitudes = []
    resultado = []
    cont = 0
    monto = 0.0
    datos = ''
    nombre = ''
    clase = "lista0"
    tipo_cliente_id = 0
    cuenta_matriz = view_liquidacion[0].cuenta_matriz.to_s
    errores = []

    view_liquidacion.each { |solicitud|
      total_grupo = 0
      total_solicitudes = 0
      if solicitud.tipo_cliente_id == 23
        unless errores.include?(solicitud.numero_grupo)
          grupo = Grupo.find(:first,:conditions=>"numero = #{solicitud.numero_grupo}")
          filtro = "solicitud_id in (#{ids}) and solicitud_id in (select id from solicitud where cliente_id in (select id from cliente where persona_id in (select persona_id from grupo_integrante where grupo_id = #{grupo.id} )))"
          total_solicitudes = ViewLiquidacion.count(:conditions=>filtro)
          total_grupo = GrupoIntegrante.count(:conditions=>"grupo_id = #{grupo.id}")
        else
          total_grupo = 1
        end
      end
      if total_grupo > total_solicitudes
        unless errores.include?(solicitud.numero_grupo)
          errores << solicitud.numero_grupo
        end
      else
        if solicitud.tipo_cliente_id == 1
          tipo_cliente = 1
        else
          tipo_cliente = 22
        end
        if tipo_cliente_id == tipo_cliente
          cont = cont + 1
          if solicitud.tipo_cliente_id == 22 || solicitud.tipo_cliente_id == 23
            monto = monto + solicitud.monto_solicitado
          else
            cronograma_desembolso = CronogramaDesembolso.find(:first,:conditions=>"solicitud_id = #{solicitud.solicitud_id}",:order=>'id')
            monto = monto + cronograma_desembolso.monto
          end
          solicitudes << solicitud.solicitud_id.to_s
        else
          unless tipo_cliente_id == 0
            datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>".html_safe
            resultado << datos
            if solicitud.entidad_financiera_id == 1
              generar_biv(nombre,solicitudes)
            else
              valores = [solicitud.cuenta_matriz,monto,cont]
              generar_bfa(nombre,solicitudes,valores)
            end
          end
          solicitudes = []
          solicitudes << solicitud.solicitud_id.to_s
          fecha = Time.now
          if solicitud.entidad_financiera_id == 1 && solicitud.tipo_cliente_id == 1
            nombre = 'BIV_LIQUIDACION_COOPERATIVA_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          elsif solicitud.entidad_financiera_id == 1 && solicitud.tipo_cliente_id != 1
            nombre = 'BIV_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          elsif solicitud.entidad_financiera_id == 150 && solicitud.tipo_cliente_id == 1
            nombre = 'BANFOANDES_LIQUIDACION_COOPERATIVA_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          else
            nombre = 'BANFOANDES_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>".html_safe
          end
          if solicitud.tipo_cliente_id != 1
            tipo_cliente_id = 22
            monto = solicitud.monto_solicitado
          else
            tipo_cliente_id = 1
            cronograma_desembolso = CronogramaDesembolso.find(:first,:conditions=>"solicitud_id = #{solicitud.solicitud_id}",:order=>'id')
            monto = cronograma_desembolso.monto
          end
          cont = 1
          if clase == "lista0"
            clase = "lista1"
          else
            clase = "lista0"
          end
        end
      end
    }
    solicitud = view_liquidacion[0]
    if solicitud.entidad_financiera_id == 1
      generar_biv(nombre,solicitudes)
    else
      valores = [solicitud.cuenta_matriz,monto,cont]
      generar_bfa(nombre,solicitudes,valores)
    end
    if datos.length > 0
      datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>".html_safe
    end

    resultado << datos
    render :update do |page|
      page.redirect_to :action=>'resultado', :errores=>errores, :result=>resultado, :popup=>params[:popup]
    end
  end

  def resultado
    @resultado = params[:result]
    unless params[:errores].nil?
      if params[:errores].length > 0
        numeros_grupos = ""
        @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.solicitudes_pertenecientes_al_grupo')} <b>".html_safe
        params[:errores].each {|numero|
          if numeros_grupos.length > 0
            numeros_grupos << ", " << numero.to_s
          else
            numeros_grupos = numero.to_s
          end
        }
        @feedback << numeros_grupos << "</b>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.no_se_incluira_archivo')}.</div>".html_safe
      end
    end

  end  
  
  

  def sector_search   

    if params[:id]!=""
      @sub_sector_select = SubSector.find(:all, :conditions => "activo=true and sector_id = #{params[:id].to_s} ", :order => "nombre")
      @rubro_select =[]
      @sub_rubro_select =[]
      @actividad_select = []
    else
      @sub_sector_select =[]
      @rubro_select =[]
      @sub_rubro_select =[]
      @actividad_select = []
    end      

    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
      page.replace_html 'rubro-search', :partial => 'rubro_search'
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end

  def sub_sector_search
    if params[:id]!=""
        sub_sector = SubSector.find(params[:id])
        @rubro_select = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{sub_sector.sector_id} and sub_sector_id = #{params[:id].to_s} and activo = true", :order=>"nombre")
        @sub_rubro_select =[]
        @actividad_select = []
    else
        @rubro_select =[]
        @sub_rubro_select =[]
        @actividad_select = []
    end   

    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'      
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end

  def rubro_search
    
    if params[:id]!=""
      @sub_rubro_select = SubRubro.find(:all, :conditions => "activo=true and rubro_id = #{params[:id].to_s} ", :order => "nombre")    
      @actividad_select = []
    else
      @sub_rubro_select =[]
      @actividad_select = []
    end
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'      
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end

  def sub_rubro_search

    if params[:id]!=""
    @actividad_select = Actividad.find(:all, :conditions => "activo=true and sub_rubro_id = #{params[:id].to_s} ", :order => "nombre")
    else
    @actividad_select = []
    end
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end



  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.registro') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.cheques')
    @form_title_record = I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ParametroGeneral.Separadores.solicitudes')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @records_by_page = 1000
    @width_layout = '1200'
  end

end
