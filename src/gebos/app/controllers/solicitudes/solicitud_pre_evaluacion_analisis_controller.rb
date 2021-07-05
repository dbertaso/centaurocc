# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionAnalisisController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionAnalisisController < FormTabsController

 layout 'form_basic'

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @municipio = Municipio.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :order => 'nombre')
    @unidad_produccion = UnidadProduccion.find(:all, :order => 'unidad_produccion')
    #@sector_economico = SectorEconomico.find(:all, :conditions=>['activo = true and id <> 1000'], :order=>'descripcion')
  end

  def list
    @condition ="(const_id = 'ST0003' or const_id = 'ST0004' or const_id = 'ST0028')"
    usuario_rol = Usuario.find_by_sql("select * from usuario_rol where rol_id = 11 and usuario_id = #{@usuario.id}")
    unless usuario_rol.length > 0 || @usuario.super_usuario
      @condition << " and usuario_pre_evaluacion = '#{@usuario.nombre_usuario}'"
    end
    params['sort'] = "numero" unless params['sort']
    logger.info "condiciones " + @condition
    unless params[:sector_economico_id].to_s.nil? || params[:sector_economico_id].to_s.empty?
      sector_economico_id = params[:sector_economico_id].to_s
      sector = SectorEconomico.find(sector_economico_id)
      @condition << " and (cliente_numero in (select id from empresa where sector_economico_id = #{params[:sector_economico_id]}) or cliente_numero in (select id from persona where sector_economico_id = #{params[:sector_economico_id]}))"
      @form_search_expression << "Sector Económico es igual '#{sector.descripcion}'"
    end
    
    unless params[:estado_id].to_s.nil? || params[:estado_id].to_s.empty?
      estado_id =params[:estado_id].to_s
      estado = Estado.find(estado_id)
      @condition << " and estado_id = " + estado_id
      @form_search_expression << "Estado es igual '#{estado.nombre}'"
    end

      unless params[:sector_id].to_s.nil? || params[:sector_id].to_s.empty?
        sector_id =params[:sector_id].to_s
        sector = Sector.find(sector_id)
        @condition << " and sector_id = " + sector_id
        @form_search_expression << "Sector es igual '#{sector.nombre}'"
      end

      unless params[:municipio_id].to_s.nil? || params[:municipio_id].to_s.empty?
        municipio_id =params[:municipio_id].to_s
        municipio = Municipio.find(municipio_id)
        @condition << " and municipio_id = " + municipio_id
        @form_search_expression << "municipio es igual '#{municipio.nombre}'"
      end
            
      unless params[:unidad_produccion].nil? || params[:unidad_produccion].empty?
        @condition << " AND UPPER(unidad_produccion) LIKE UPPER('%#{params[:unidad_produccion].strip}%')"
        @form_search_expression << "Unidad de Producci&oacute;n contenga '#{params[:unidad_produccion]}'"
      end
      
    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "Número igual '#{params[:numero]}'"
    end
    
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " AND UPPER(cedula_rif) LIKE UPPER('%#{params[:tipo]+params[:identificacion].strip}%') "
      @form_search_expression << "Rif o Cédula contenga '#{params[:tipo]+params[:identificacion]}'"
    end
    
    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "Apellido / Empresa contenga '#{params[:nombre]}'"
    end

    #@total = ViewSolicitudPreEvaluacion.count(:conditions=>@condition)
    #@pages, @list = paginate(:solicitud, :class_name => 'ViewSolicitudPreEvaluacion',
     #:per_page => @records_by_page,
     #:conditions => @condition,
     #:select=>'*',
     #:order_by => params['sort'])
    @list = ViewSolicitudPreEvaluacion.search(conditions, params[:page], params['sort'])
    @total=@list.count
     

    form_list
  end

    def view
      @solicitud = Solicitud.find(params[:id])
      
      #list_edit
    end
    
  def edit
    @solicitud = Solicitud.find(params[:id])
    @registro =  RegistroMercantil.find_by_unidad_produccion_id(@solicitud.unidad_produccion_id, :order => "fecha_registro desc")
    @tenencia = TenenciaUnidadProduccion.find_by_id(@registro.tenencia_unidad_produccion_id)
    @documento = TipoDocumento.find_by_id(@registro.tipo_documento_id)

    list_edit
  end

  def list_edit
    @condition = 'solicitud_id = ' + @solicitud.id.to_s
    
    @list = SolicitudAspectosEvaluar.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end

  def new
    @solicitud = Solicitud.find(params[:solicitud_id])
    @aspectos_resguardo_institucional_select = AspectosResguardoInstitucional.find(:all,:conditions=>['id not in (select aspectos_resguardo_institucional_id from solicitud_aspectos_evaluar where solicitud_id = ?)', @solicitud.id], :order=>'nombre')
    @solicitud_aspectos_evaluar = SolicitudAspectosEvaluar.new
    render :update do |page|
      page.form_reset
      page.replace_html 'form_new', :partial => 'form'
      page.hide 'button_new'
      page.show 'form_new'
    end
  end

  def cancel
    render :update do |page|
      page.form_reset
      page.show 'button_new'
      page.hide 'form_new'
    end
  end

  def save_new
    @item = SolicitudAspectosEvaluar.new(params[:solicitud_aspectos_evaluar])
    @item.solicitud_id = params[:id]
    @item.save
    unless @item.errors.length > 0
      render :update do |page|
        page.hide 'error'
        page.hide 'form_new'
        page.insert_html :top, 'list_body' , :partial => 'row_edit', :locals => { :even_odd => 0 }
        page.visual_effect :highlight, "row_#{@item.id}", :duration => 0.6
        page.show 'button_new'
        page.replace_html 'message', 'Se asignó el aspecto a evaluar con éxito'
        page.show 'message'
      end
    else
      render :update do |page|
        page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL><LI>Aspecto a Evaluar es requerido.</LI>'
        page.show 'errorExplanation'
      end
    end
  end

  def delete
    @solicitud_aspectos_evaluar = SolicitudAspectosEvaluar.find(params[:id])
    form_delete @solicitud_aspectos_evaluar
  end

  def avanzar
    solicitud = Solicitud.find(params[:id])
    solicitud.avanzar_pre_evaluacion(@usuario.id)
    if solicitud.errors.length > 0
      message = '<h2>Ha ocurrido un error</h2><p><UL>'
      solicitud.errors.each { |e|
        message << "<LI>#{e[1]}</LI>"
      }
      message << '</UL><p>'
      render :update do |page|
        page.replace_html 'errorExplanation',message
        page.show 'errorExplanation'
      end
    else
      render :update do |page|
        page.remove "row_#{solicitud.id}"
        page.hide 'errorExplanation'
        page.replace_html 'message', "La Solicitud Número #{solicitud.numero} fue Enviada a las unidades de apoyo con Exito."
        page.show 'message'
      end
    end
  end
  
  protected
  def common
    super
    @form_title = 'Análisis del Financiamiento'
    @form_title_record = 'Solicitudes'
    @form_title_records = 'Solicitudes'
    @form_entity = 'El Aspecto'
    #@form_identity_field = 'numero'
    @width_layout = '960'
  end 
  
end
