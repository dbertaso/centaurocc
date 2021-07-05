# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::GeneracionTablaController
# descripción: Migración a Rails 3
#

class Finanzas::GeneracionTablaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:generar_tabla]

  layout 'form_basic'

  def index
    @sector = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    @estado_select = Estado.find(:all, :order=>'nombre')
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
    sub_sector_fill(0)
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def list
    params['sort'] = "fecha_liquidacion" unless params['sort']
    condition = "estatus_id in (10060) "
    logger.info "Primer Parametros ==========> #{params[:sub_sector_id][0].to_s}"    

    logger.info "Parametros estado ==========> #{params.inspect}"
    estado_id = params[:estado]

    unless params[:estado].nil? 
      unless params[:estado][:id].to_s==''
        condition += " and estado_id = #{params[:estado][:id]}"       
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(params[:estado][:id]).nombre}'" 
      end
    end

     

    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''
        condition += " and sector_id = #{params[:sector_id][0]}"   
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(params[:sector_id][0]).nombre}'"     
      end
    end
    

    
    unless params[:sub_sector_id].nil? 
      unless params[:sub_sector_id][0].to_s==''
        condition += " and sub_sector_id = #{params[:sub_sector_id][0]}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{SubSector.find(params[:sub_sector_id][0]).nombre}'"
      end
    end
    

    
    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''
        condition += " and rubro_id = #{params[:rubro_id][0]}"   
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(params[:rubro_id][0]).nombre}'"
      end
    end
    

    
    unless params[:sub_rubro_id].nil?
      unless params[:sub_rubro_id][0].to_s==''
        condition += " and sub_rubro_id = #{params[:sub_rubro_id][0]}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(params[:sub_rubro_id][0]).nombre}'"
      end
    end
    

    
    unless params[:actividad_id].nil? 
      unless params[:actividad_id][0].to_s==''
        condition += " and actividad_id = #{params[:actividad_id][0]}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(params[:actividad_id][0]).nombre}'"
      end
    end
    

    
    unless params[:solicitud].nil? || params[:solicitud].empty?
      condition += " and nro_tramite = #{params[:solicitud]}"        
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:solicitud]}'"
    end
    

    
    unless params[:nombre].nil? || params[:nombre].empty?
      condition += " and upper(beneficiario) like UPPER('%#{params[:nombre]}%')"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_beneficiario')} '#{params[:nombre]}'"  
    end
    

    
    unless params[:cedula].nil? || params[:cedula].empty?
      condition += " and cedula_rif like '%#{params[:tipo]+params[:cedula]}%'"        
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo]+params[:cedula]}'"
    end
      
    unless params[:moneda_id][0].blank?
      moneda = Moneda.find(params[:moneda_id][0])
      condition += " AND moneda_id = '#{params[:moneda_id][0].to_i}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    end
    

    logger.info "Condiciones de la consulta: ----> final" << condition.to_s

    
    @list = ViewGeneracionTabla.search(condition, params[:page], params['sort'])    
    @total=@list.count
    form_list

  end

  

  def generar_tabla

    logger.info "Parametros =====> " << params.inspect

    ids = params[:prestamos_id]
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

    errores = ""
    prestamo = Prestamo.find(:first)

    prestamos = Prestamo.find(:all, :conditions=>["id in (#{ids[0,ids.to_s.length - 1]})"])
    prestamos.each do |i|
      errores << prestamo.validar(i,params["fecha_liquidacion_#{i.id}"], params["numero_cheque_#{i.id}"])
    end

    if errores.length > 0
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.html_safe << "</UL></p>".html_safe
        page.<< "varEnviado=false;$('button_save').disabled=false"        
        page.<< "window.scrollTo(0,0);"
        page.show 'errorExplanation'
      end
      return false
    end

    id = prestamo.registrar_cheque(params, session[:id])
    id=id.split(',')
    logger.info "IDS =====> " << id.class.to_s << " id " << id.to_s
    if !id.empty? || id.length > 0

      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.hide 'errorExplanation'
        id.each {|i|
          page.remove "row_#{i}"
        }
        page.<< 'document.getElementById("prestamos_id").value = "";document.getElementById("prestamos_id").value = "";'
        page.replace_html 'message', "#{I18n.t('Sistema.Body.General.tabla_amortizacion_se_ha_generado_con_exito')}"
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        numeros = ''
        logger.debug "aqui es " <<  id.nil?.to_s
        if id.nil?
          id.each {|i|
            prestamo = prestamo.find(i.to_i)
            numeros += prestamo.numero.to_s + ' ' unless prestamo.nil?
          }
        else
          numeros=I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.debe_colocar_fecha_registro')
        end
        #page.<< 'document.getElementById("prestamos_id").value = "";document.getElementById("prestamos_id").value = "";'
        page.<< "varEnviado=false;$('button_save').disabled=false"        
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.error_en_generacion_tabla_amortizacion')}</h2><p><UL>".html_safe << numeros.html_safe
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
            datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>"
            resultado << datos.html_safe
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
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>"
          elsif solicitud.entidad_financiera_id == 1 && solicitud.tipo_cliente_id != 1
            nombre = 'BIV_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>"
          elsif solicitud.entidad_financiera_id == 150 && solicitud.tipo_cliente_id == 1
            nombre = 'BANFOANDES_LIQUIDACION_COOPERATIVA_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.Vistas.General.cooperativa')}</td><td align='center'>#{cuenta_matriz}</td>"
          else
            nombre = 'BANFOANDES_LIQUIDACION_NATURAL_' << format_fecha_inv(fecha)+"-"+format_hora_corta_militar(fecha)
            datos = "<tr class='#{clase}'><td align='center'>#{solicitud.entidad_financiera}</td><td align='center'>#{I18n.t('Sistema.Body.General.persona_natural')}</td><td align='center'>#{cuenta_matriz}</td>"
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
      datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>"
    end

    resultado << datos.html_safe
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
            datos << "<td align='center'>#{cont}</td><td align='center'>#{format_fm(monto)}</td><td align='center'><a target='_blank' href='#{request.protocol}#{request.host.to_s}:#{request.port.to_s}/documentos/finanzas/liquidacion/#{nombre}.txt'>#{I18n.t('Sistema.Body.General.descargue_aqui')}</a></td></tr>"
            resultado << datos.html_safe
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

    resultado << datos.html_safe
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

  def sub_sector_fill(sector_id)
    @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id], :order => 'nombre')
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def rubro_fill(sub_sector_id)
    @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id], :order => 'nombre')
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def sub_rubro_fill(rubro_id)
    @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', rubro_id], :order => 'nombre')
    actividad_fill(0)
  end

  def actividad_fill(sub_rubro_id)
    @actividad_list = Actividad.find(:all, :conditions=>['activo=true and sub_rubro_id = ?', sub_rubro_id], :order => 'nombre')
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
    @width_layout = '1400'
  end

end
