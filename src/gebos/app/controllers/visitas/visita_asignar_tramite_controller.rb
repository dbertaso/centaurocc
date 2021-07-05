# encoding: utf-8
#
# autor: Luis Rojas
# clase: Visitas::VisitaAsignarTramiteController
# descripción: Migración a Rails 3
#
class Visitas::VisitaAsignarTramiteController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:municipio_change, :save_reasignar, :save_asignar, :save_re_asignar_maxivo]

 layout 'form_basic'

  def index
    oficina = Oficina.find(session[:oficina])
    @municipio = Municipio.find(:all, :conditions=>['estado_id = ?', oficina.municipio.estado_id], :order => 'nombre')
    @usuario_list = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', oficina.id], :order=>'primer_nombre, primer_apellido')
  end

  def list
    @condition ="estatus_id in (10100, 10110) and oficina_id = #{session[:oficina]}"
    params['sort'] = "numero" unless params['sort']

    unless params[:usuario_id][0].blank?
      usuario_id = params[:usuario_id][0].to_s
      usuario = Usuario.find(usuario_id)
      @condition << " and usuario_pre_evaluacion = '#{usuario.nombre_usuario}'"
      @form_search_expression << "Usuario es igual '#{usuario.primer_nombre << " " << usuario.primer_apellido}'"
    end
    
    unless params[:municipio_id][0].blank?
      municipio_id =params[:municipio_id][0].to_s
      municipio = Municipio.find(municipio_id)
      @condition << " and municipio_id = " + municipio_id
      @form_search_expression << "Municipio es igual '#{municipio.nombre}'"
    end

    unless params[:parroquia_id][0].blank?
      parroquia = Parroquia.find(params[:parroquia_id][0].to_s)
      @condition << " and parroquia_id = " + params[:parroquia_id][0].to_s
      @form_search_expression << "Parroquia es igual '#{parroquia.nombre}'"
    end

    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "Número igual '#{params[:numero]}'"
    end

    unless params[:unidad_produccion].nil? ||  params[:unidad_produccion].empty?
      @condition << " AND lower(unidad_produccion) LIKE lower('%#{params[:unidad_produccion].strip}%') "
      @form_search_expression << "Unidad de Producción contenga '#{params[:unidad_produccion]}'"
    end
    
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " AND lower(cedula_rif) LIKE lower('%#{params[:tipo]+params[:identificacion].strip}%') "
      @form_search_expression << "Rif o Cédula contenga '#{params[:tipo]+params[:identificacion]}'"
    end
    
    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "Nombre o Apellido contenga '#{params[:nombre]}'"
    end
    unless params[:viable].nil? || params[:viable].empty?
      @condition << " and decision_final = #{params[:viable]}"
      @form_search_expression << "Viable igual 'No Viable'"
    end

    
    @list = ViewSolicitudPreEvaluacion.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end
	
  def re_asignar_maxiva
    estatus_id = 10100
    @solicitud = Solicitud.find(:all, :conditions=>["estatus_id = ? and oficina_id = #{session[:oficina]}", estatus_id])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and oficina_id = ?', session[:oficina]], :order=>'primer_nombre, primer_apellido')
    @control_asignacion = ControlAsignacion.new
  end

  def save_re_asignar_maxivo
    solicitud_id = params[:solicitudes]
    unless solicitud_id.nil?
      solicitud_id = solicitud_id.split(',')
      solicitud_id.each { |s|
        @solicitud = Solicitud.find(s)
        unless params[:control_asignacion][:usuario_id].nil? || params[:control_asignacion][:usuario_id].to_s.empty?
          if params[:control_asignacion][:observacion].nil? || params[:control_asignacion][:observacion].to_s.empty?
            render :update do |page|
               page.alert "#{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
            end
            return
          end
          usuario = Usuario.find(params[:control_asignacion][:usuario_id])
          unless (@solicitud.usuario_pre_evaluacion == usuario.nombre_usuario)
            @solicitud.update_asignar(params[:control_asignacion])
            if @solicitud.errors.messages.length > 0
              render :update do |page|
                 page.alert "#{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
              end
              return
            end
          end
        else
          render :update do |page|
             page.alert "#{I18n.t('Sistema.Body.Vistas.General.tecnico')} #{I18n.t('Sistema.Body.Vistas.General.a')} #{I18n.t('Sistema.Body.Vistas.General.asignar')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
          end
          return
        end
      }
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.General.los_tramites_se_han_asignado_correctamente')
        page.redirect_to :action=>'re_asignar_maxiva', :popup=>params[:popup]
      end
    else
      render :update do |page|
         page.alert I18n.t('Sistema.Body.Modelos.Errores.debe_seleccionar_tramite')
      end
      return
    end
  end

  def save_reasignar
    @solicitud = Solicitud.find(params[:id])
    form_save_new @solicitud, :value=>@solicitud.update_asignar(params[:control_asignacion])
  end

  def edit
    @solicitud = Solicitud.find(params[:id])
    @control_asignacion = ControlAsignacion.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id], :order=>'id desc')
  end

  def reasignar
    @solicitud = Solicitud.find(params[:id])
    @control_asignacion = ControlAsignacion.new
    @usuario = Usuario.find(:first, :conditions=>['nombre_usuario = ?',@solicitud.usuario_pre_evaluacion])
    @usuario_select = Usuario.find(:all, :conditions=>['activo = true and cedula in (select cedula from tecnico_campo where activo = true) and nombre_usuario <> ? and oficina_id = ?', @solicitud.usuario_pre_evaluacion, session[:oficina]], :order=>'primer_nombre, primer_apellido')
    @control = ControlAsignacion.find(:all,:conditions=>['solicitud_id = ?',@solicitud.id],:order=>'id desc')
  end

  def municipio_change
    @parroquia_list = Parroquia.find_all_by_municipio_id(params[:municipio_id], :order=>'nombre')
    render :update do |page|
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  protected
  def common
    super
    @form_title = 'Re-asignación de Técnico de Campo'
    @form_title_record = 'Trámites'
    @form_title_records = 'Trámites'
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end 
  
end
