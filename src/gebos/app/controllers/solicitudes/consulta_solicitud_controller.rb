# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::ConsultaSolicitudController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaSolicitudController < FormTabsController

  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :estado_change]
  
  layout 'form_basic'

  def index
    @estado_list = Estado.find(:all, :order=>'nombre')    
    @sector_list = Sector.find(:all, :conditions =>"activo=true", :order=>'nombre')    
    @estatus = Estatus.find(:all, :conditions => "id < 20000", :order=>'nombre')
    @oficina_list=[]
    @programa_list=Programa.find(:all, :conditions =>"activo=true",:order=>'nombre')
    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
        CASE
            WHEN mon.id = par.moneda_id THEN 
            '1'::text
            ELSE '0'::text
        END AS no_va
   FROM moneda mon,parametro_general par 
   where mon.activo=true order by no_va desc, nombre;"
    @moneda_list=Moneda.find_by_sql(sentencia)
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
  
  def estado_change
    estado(params[:estado_id])
    render :update do |page|
      page.replace_html 'select-oficina', :partial => 'estado_select'      
      page.show 'select-oficina'
    end
  end

  def view
    @solicitud = Solicitud.find(params[:id].to_i)
    @cliente = Cliente.find(@solicitud.cliente_id)
  end

  def list

    @condition ="solicitud_id > 0 "
    params['sort'] = "numero" unless params['sort']
    
    # nuevos filtros agregados el 27/05/2013
    unless params[:programa_id].nil? 
      unless params[:programa_id][0].to_s==''      
      programa = Programa.find(params[:programa_id][0].to_s)
      @condition << " and programa_id  = #{params[:programa_id][0]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.programa_igual')} '#{programa.nombre}'"
    end
    end
    
    
    if (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s!='')        

        fecha =format_fecha_conversion(params[:fecha_desde])
        fecha_hasta =format_fecha_conversion(params[:fecha_hasta])        
        @condition << "and (fecha_solicitud >= '#{fecha}'"
        @condition << " and fecha_solicitud <= '#{fecha_hasta}')"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_solicitud_desde')} '#{params[:fecha_desde].to_s}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_solicitud_hasta')} '#{params[:fecha_hasta].to_s}'"                    
                         
    
    # casos especiales    
    elsif (params[:fecha_desde].to_s=='' && params[:fecha_hasta].to_s!='')
        
        fecha_hasta =format_fecha_conversion(params[:fecha_hasta])        
        @condition << " and fecha_solicitud <= '#{fecha_hasta}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_solicitud_hasta')} '#{params[:fecha_hasta].to_s}'"                                    
        
    
    
    elsif (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s=='') 
        
        fecha =format_fecha_conversion(params[:fecha_desde])
        @condition << "and fecha_solicitud >= '#{fecha}'"                    
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_solicitud_desde')} '#{params[:fecha_desde].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                    
        
    
    end
    # fin nuevos filtros agregados el 27/05/2013
    
    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''      
      estado = Estado.find(params[:estado_id][0].to_s)
      @condition << " and estado_id  = #{params[:estado_id][0]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{estado.nombre}'"
    end
    end

    unless params[:moneda_id].nil? 
      unless params[:moneda_id][0].to_s==''      
      moneda = Moneda.find(params[:moneda_id][0].to_s)
      @condition << " and moneda_id  = #{params[:moneda_id][0]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.moneda_igual')} '#{moneda.nombre}'"
    end
    end
    
    unless params[:oficina_id].nil? 
      unless params[:oficina_id][0].to_s==''      
      oficina = Oficina.find(params[:oficina_id][0].to_s)
      @condition << " and oficina_id = #{params[:oficina_id][0].to_s} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.oficina_igual')} '#{oficina.nombre}'"
    end
    end

    unless params[:sector_id].nil? 
      unless params[:sector_id][0].to_s==''      
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      @condition << " and sector_id = #{params[:sector_id][0]} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
    end
    end

    unless params[:sub_sector_id][0].blank?
      sub_sector_id = params[:sub_sector_id][0].to_s
      sub_sector = SubSector.find(sub_sector_id)
      @condition << " and sub_sector_id = #{params[:sub_sector_id][0]} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{sub_sector.nombre}'"
    end

    unless params[:rubro_id][0].blank?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      @condition << " and rubro_id = " + rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
    end
    
    unless params[:sub_rubro_id][0].blank?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      @condition << " and sub_rubro_id = " + sub_rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{sub_rubro.nombre}'"
    end

    unless params[:actividad_id][0].blank?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      @condition << " and actividad_id = " + actividad_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
    end

    unless params[:numero].blank?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    unless params[:identificacion].blank?
      @condition << " AND UPPER(cedula_rif) LIKE UPPER('#{params[:tipo].upcase}#{params[:identificacion].strip}') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:tipo].upcase}#{params[:identificacion]}'"
    end

    unless params[:nombre].blank?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end

    unless params[:estatus_id][0].blank?
      estatus_id = params[:estatus_id][0].to_s
      estatus = Estatus.find(estatus_id)
      @condition << " and estatus = '#{estatus.nombre}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{estatus.nombre}'"
    end
    
    @list = ViewListSolicitud.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.consulta')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.solicitudes')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.solicitudes')
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1300'
  end
  
  def estado(id)
    if id.to_i > 0
      @oficina_list = Oficina.find(:all, :conditions=>['ciudad_id in (select id from ciudad where estado_id = ?)', id], :order=>'nombre')
    else
      @oficina_list = []
    end
  end

  def sector_fill(sector_id)
    if sector_id > 0
      @sector_list = Sector.find(:all,:conditions =>"activo=true",:order=>'nombre')
    else
      @sector_list = []
    end
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id], :order => "nombre")
    else
      @sub_sector_list = []
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id], :order => "nombre")
    else
      @rubro_list = []
    end
    sub_rubro_fill(nil)
  end
  
  def sub_rubro_fill(id)
    unless id.nil?
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    actividad(nil)
  end
  
  def actividad(id)
    unless id.nil?
      @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end

end
