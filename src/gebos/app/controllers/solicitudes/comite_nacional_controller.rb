# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::ComiteNacionalController
# descripción: Migración a Rails 3
#


class Solicitudes::ComiteNacionalController < FormTabsController

skip_before_filter :set_charset, :only=>[:new_reversar,:new_observar,:hide_reversar,:reversar,:decision_comite_nacional, :rubro_search, :subsector_search, :sub_rubro_change, :rubro_change, :sub_sector_change,:sector_change]

  layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
    fill_filtros
  end

  def decision_comite
    ComiteNacional.decision_comite(params,@usuario.id)
    decision_comite_nacional
  end

  def new_reversar
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|
      page.replace_html "diferir_#{@solicitud.id}", :partial=>'new_reversar'
      page.show "diferir_#{@solicitud.id}"
    end
  end

  def new_observar
    @solicitud = Solicitud.find(params[:id])
    @control_solicitud = ControlSolicitud.find_all_by_solicitud_id(@solicitud.id, :order =>'id DESC')

    render :update do |page|
      page.replace_html "diferir_#{@solicitud.id}", :partial=>'new_observar'
      page.show "diferir_#{@solicitud.id}"
    end
  end

  def hide_reversar
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|
      page.hide "diferir_#{@solicitud.id}"
    end
  end

  def reversar
    if params[:control_solicitud][:comentario].to_s.strip != ""
      solicitud = Solicitud.find(params[:id])

      estatus_id_inicial = solicitud.estatus_id
      fecha_evento = Time.now
      configuracion_reverso = ConfiguracionReverso.find_by_estatus_origen_id(estatus_id_inicial)
      estatus_id_final               = configuracion_reverso.estatus_destino_id
      solicitud.estatus_id           = estatus_id_final
      solicitud.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")

      if (params[:control_solicitud][:comentario].length < 400)
        comite_id                         = solicitud.comite_id
        comite_estadal_id                 = solicitud.comite_estadal_id
        solicitud.numero_comite_estadal   = nil
        solicitud.numero_comite_nacional  = nil
        solicitud.decision_comite_nacional= nil
        solicitud.decision_comite_estadal = nil
        solicitud.comite_id               = nil
        solicitud.comite_estadal_id       = nil
        solicitud.fecha_aprobacion        = nil
        solicitud.monto_aprobado          = 0
        solicitud.save

        Comite.eliminar_comite(comite_id,comite_estadal_id)

        ControlSolicitud.create(
          :solicitud_id=>solicitud.id,
          :estatus_id=>estatus_id_final,
          :usuario_id=>@usuario.id,
          :fecha => fecha_evento,
          :estatus_origen_id => estatus_id_inicial,
          :comentario => params[:control_solicitud][:comentario],
          :accion => 'Reversar'
        )

        render :update do |page|
          page.remove "row_#{solicitud.id}"
          page.hide 'error'
          page.replace_html 'message', params[:mensaje_exito]
          page.hide "diferir_#{solicitud.id}"
          page.show 'message'
        end

      else
        render :update do |page|
          page.replace_html "errorCustomizado_#{solicitud.id}","<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.General.campo')} #{I18n.t('errors.messages.too_long.other',:count=>400)}</LI>".html_safe
          page.<< "varEnviado=false;document.getElementById('button_save').disabled=false; "
          page.show "errorCustomizado_#{solicitud.id}"
          #page.show "errorCustomizado_#{solicitud.id}"
        end
      end

    else
      solicitud = Solicitud.find(params[:id])
      render :update do |page|
        page.replace_html "errorCustomizado_#{solicitud.id}","<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.General.campo')} #{I18n.t('Sistema.Body.Modelos.Errores.observacion_es_requerido')}</LI>".html_safe
        page.<< "varEnviado=false;document.getElementById('button_save').disabled=false; "
        page.show "errorCustomizado_#{solicitud.id}"
        #page.show "errorCustomizado_#{solicitud.id}"
      end
    end
  end

  def list
    @condition =" solicitud.estatus_id = 10034 "
    conditions = " where " << @condition
    params['sort'] = "numero" unless params['sort']
    
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''
          estado_id = params[:estado_id][0].to_s
          estado = Estado.find(estado_id)
          conditions = " #{conditions}  AND estado.id = " + estado_id      
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{estado.nombre}'"
      end
    end

    unless params[:sector_id].nil? 
      unless params[:sector_id][0].to_s==''
          sector_id = params[:sector_id][0].to_s
          sector = Sector.find(sector_id)
          conditions = " #{conditions}  AND  sector.id = " + sector_id
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
      end
    end

    unless params[:sub_sector_id].nil? 
      unless params[:sub_sector_id][0].to_s==''
          subsector_id = params[:sub_sector_id][0].to_s
          subsector = SubSector.find(subsector_id)
          conditions = " #{conditions}  AND  sub_sector.id = " + subsector_id
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{subsector.nombre}'"
      end
    end

    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''
          rubro_id = params[:rubro_id][0].to_s
          rubro = Rubro.find(rubro_id)
          conditions = " #{conditions}  AND  rubro.id = " + rubro_id
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
      end
    end
    
    unless params[:sub_rubro_id].nil? 
      unless params[:sub_rubro_id][0].to_s==''
          sub_rubro_id = params[:sub_rubro_id][0].to_s
          sub_rubro = SubRubro.find(sub_rubro_id)
          conditions = "#{conditions} and solicitud.sub_rubro_id = " + sub_rubro_id
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{sub_rubro.nombre}'"
      end
    end

    unless params[:actividad_id].nil? 
      unless params[:actividad_id][0].to_s==''
          actividad_id = params[:actividad_id][0].to_s
          actividad = Actividad.find(actividad_id)
          conditions = "#{conditions} and solicitud.actividad_id = " + actividad_id
		      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
      end
    end

    #MODIFICANDO PARA FILTRAR POR MAS DE UN NUMERO DE TRAMITE A.S.

    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero IN ( '#{params[:numero].split(',').join("','")}')"      
	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_igual')} '#{params[:numero]}'"
    end
    
    unless params[:moneda_id][0].blank?
      moneda = Moneda.find(params[:moneda_id][0])
      @condition << " AND solicitud.moneda_id = '#{params[:moneda_id][0].to_i}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    end

    unless params[:nro_sesion].nil? || params[:nro_sesion].empty?
      conditions = "#{conditions} AND solicitud.numero_comite_nacional =  '#{params[:nro_sesion].to_s}' "      
	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_sesion')} '#{params[:nro_sesion]}'"
    end

    conditions_per = " #{conditions}"
    conditions_emp = " #{conditions}"

    unless params[:nombre].nil? || params[:nombre].empty?
      conditions_per = " #{conditions_per} AND LOWER((primer_nombre || ' ' || primer_apellido)) LIKE '%#{params[:nombre].strip.downcase}%'"
      conditions_emp = " #{conditions_emp} AND LOWER(empresa.nombre) LIKE '%#{params[:nombre].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions_per = " #{conditions_per}  AND LOWER(CAST(cedula as varchar)) LIKE  '%#{params[:identificacion].strip.downcase}%' "
      conditions_emp = " #{conditions_emp}  AND LOWER(rif) LIKE  '%#{params[:identificacion].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:identificacion]}'"
    end

    sql = " (SELECT distinct solicitud.id,solicitud.numero as numero_helper, CAST(cedula as varchar) as identificacion, numero_comite_estadal,"
    sql += " (primer_nombre || ' ' || primer_apellido) AS nombre, fecha_solicitud as fecha, estado.nombre as estado,comite.vigente "
    sql += " FROM solicitud "
    sql += " INNER JOIN cliente INNER JOIN persona ON cliente.persona_id = persona.id ON solicitud.cliente_id = cliente.id "
    sql += " INNER JOIN rubro  ON solicitud.rubro_id = rubro.id"
    sql += " INNER JOIN sub_sector ON rubro.sub_sector_id = sub_sector.id"
    sql += " INNER JOIN sector ON sub_sector.sector_id = sector.id"
    sql += " INNER JOIN oficina ON solicitud.oficina_id=oficina.id "
    sql += " INNER JOIN ciudad on ciudad.id=oficina.ciudad_id "
    sql += " INNER JOIN estado ON ciudad.estado_id = estado.id "
    sql += " LEFT JOIN comite ON solicitud.comite_id=comite.id  #{conditions_per}"
    sql += " UNION "
    sql += " SELECT distinct solicitud.id,solicitud.numero as numero_helper, rif as identificacion,numero_comite_estadal,"
    sql += " empresa.nombre AS nombre, fecha_solicitud as fecha,estado.nombre as estado,comite.vigente "
    sql += " FROM solicitud "
    sql += " INNER JOIN cliente INNER JOIN empresa ON cliente.empresa_id = empresa.id ON solicitud.cliente_id = cliente.id "
    sql += " INNER JOIN rubro  ON solicitud.rubro_id = rubro.id"
    sql += " INNER JOIN sub_sector ON rubro.sub_sector_id = sub_sector.id"
    sql += " INNER JOIN sector ON sub_sector.sector_id = sector.id"
    sql += " INNER JOIN oficina ON solicitud.oficina_id=oficina.id "
    sql += " INNER JOIN ciudad on ciudad.id=oficina.ciudad_id "
    sql += " INNER JOIN estado ON ciudad.estado_id = estado.id "
    sql += " LEFT JOIN comite ON solicitud.comite_id=comite.id #{conditions_emp}"
    sql += " ) as solicitud_helper "

    joins = " INNER JOIN #{sql} ON solicitud.id = solicitud_helper.id 
              INNER JOIN sector ON sector.id = solicitud.sector_id
              INNER JOIN sub_sector ON sub_sector.id = solicitud.sub_sector_id
              INNER JOIN rubro ON rubro.id = solicitud.rubro_id
            "
    
    
    @list = Solicitud.search_especial(@condition, params[:page], params[:sort], 'solicitud.*', joins)
    @total=@list.count

      
    form_list
  end
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page.show 'sub-sector-select'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def sub_rubro_change
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end


  def subsector_search
    @rubro = []
    if !params[:id].nil? && !params[:id].empty?
      @subsector = SubSector.find(:all, :conditions=>["activo=true and sector_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre")
      render :update do |page|
        page.replace_html 'subsector-search', :partial => 'subsector_search'
        page.replace_html 'rubro-search', :partial => 'rubro_search'
        page.show 'tr_subsector_search'
      end
    else
      render :update do |page|
        page.hide 'tr_subsector_search'
      end
    end
  end

  def rubro_search
    if !params[:id].nil? && !params[:id].empty?
      @rubro = Rubro.find(:all, :conditions=>["activo=true and sub_sector_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
      render :update do |page|
        page.replace_html 'rubro-search', :partial => 'rubro_search'
        page.show 'rubro_search_tr'
      end
    else
      render :update do |page|
        page.hide 'rubro_search_tr'
      end
    end
  end

  def decision_comite_nacional
    render :update do |page|      
      page.<< "window.scrollTo(0,0);"      
    end
  end

  def resumen_comite_solicitud
    @solicitud       = Solicitud.find(params[:solicitud_id])
    @unidad_negocio  = UnidadNegocio.find(:all,:conditions=>['solicitud_id=?',@solicitud.id],:include=>:tenencia_unidad_produccion,:order=>"nombre")
    @unidad_produccion_vocacion_tierra = UnidadProduccionVocacionTierra.find(:all,:conditions=>['solicitud_id=?',@solicitud.id],:include=>[:vocacion_tierra])
    @width_layout='1000'
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Vistas.General.instancias') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.aprobacion') << " - " << I18n.t('Sistema.Body.Vistas.General.comite') << " " << I18n.t('Sistema.Body.Vistas.General.nacional')
    @form_title_record   = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.solicitudes')
    @form_title_records  = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.solicitudes')
    @form_entity         = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout        = '1200'
    @records_by_page      = 1000
  end

  def fill_filtros
    @programa     = Programa.find(:all, :conditions=>"activo = true",:order=>'nombre')
    @sector       = Sector.find(:all, :conditions=>"activo = true",:order=>'nombre')
    @estado       = Estado.find(:all, :order=>'nombre')
    sub_sector_fill(0)
  end
  
  def sector_fill(sector_id)
    if sector_id > 0
      @sector_list = Sector.find(:all,:conditions=>"activo = true", :order=>'nombre')
      @sub_sector_list = []
      @rubro_list = []
      @sub_rubro_list =[]
      @actividad_list =[]
    else
      @sector_list = []
      @sub_sector_list = []
      @rubro_list = []
      @sub_rubro_list =[]
      @actividad_list =[]
    end
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo = true and sector_id = ?', sector_id], :order=>'nombre')
      @rubro_list = []
      @sub_rubro_list =[]
      @actividad_list =[]
    else
      @sub_sector_list = []
      @rubro_list = []
      @sub_rubro_list =[]
      @actividad_list =[]
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['activo = true and sub_sector_id = ?', sub_sector_id], :order=>'nombre')
      @sub_rubro_list =[]
      @actividad_list =[]
    else
      @rubro_list = []
      @sub_rubro_list =[]
      @actividad_list =[]
    end
    sub_rubro_fill(nil)
  end
  
  def sub_rubro_fill(id)
    if id.to_i > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
      @actividad_list =[]
    else
      @sub_rubro_list =[]
      @actividad_list =[]
    end
    actividad(nil)
  end
  
  def actividad(id)
    if id.to_i > 0
      @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end

end
