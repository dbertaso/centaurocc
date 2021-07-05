# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionVisitaController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionVisitaController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:save_new_utm, :save_vocacion]

  def index
    list
  end

  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end
  
  def new
    @linderos_coordenadas = LinderosCoordenadas.new 
  end
  
  def save_new
    @solicitud = Solicitud.find(params[:id])
    @linderos_coordenadas = LinderosCoordenadas.new(params[:linderos_coordenadas],:value=> {:solicitud_id => @solicitud.id, :unidad_produccion_id => @solicitud.unidad_produccion_id })
    #EmpresaDireccion.validate
    form_save_new @linderos_coordenadas, 
      :value=>@linderos_coordenadas,
      :params=> {:solicitud_id => @solicitud.id, :unidad_produccion_id => @solicitud.unidad_produccion_id } 
  end
  
  def edit
    @linderos_coordenadas = LinderosCoordenadas.find_by_solicitud_id(params[:id], :order=>'id desc')
    @solicitud = Solicitud.find(params[:id])
    
    @unidad_produccion = UnidadProduccion.find(@solicitud.unidad_produccion_id)
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", @unidad_produccion.id])
    
    if @linderos_coordenadas == nil
      @linderos_coordenadas = LinderosCoordenadas.new
    end
    @linderos_coordenadas.lindero_norte = @unidad_produccion.lindero_norte
    @linderos_coordenadas.lindero_sur = @unidad_produccion.lindero_sur
    @linderos_coordenadas.lindero_este = @unidad_produccion.lindero_este
    @linderos_coordenadas.lindero_oeste = @unidad_produccion.lindero_oeste
    
    
    @vocacion_tierra = VocacionTierra.find_by_sql("select id,nombre as nombre,descripcion,activo, 
      	case when id in (select vocacion_tierra_id from unidad_produccion_vocacion_tierra 
      				where solicitud_id = #{@solicitud.id} and unidad_produccion_id = #{@solicitud.unidad_produccion_id} and seguimiento_visita_id=#{params[:seguimiento_visita_id]}) then 'checked' else '' end as marcado,

      	case when id in (select vocacion_tierra_id from unidad_produccion_vocacion_tierra 
      				where solicitud_id = #{@solicitud.id} and unidad_produccion_id = #{@solicitud.unidad_produccion_id} and seguimiento_visita_id=#{params[:seguimiento_visita_id]}) and upper(nombre) like '%OTRO%' 
      		then (select descripcion_otro from unidad_produccion_vocacion_tierra where solicitud_id = #{@solicitud.id} and unidad_produccion_id = #{@solicitud.unidad_produccion_id} and seguimiento_visita_id=#{params[:seguimiento_visita_id]} and vocacion_tierra_id = vc.id)  end as descripcion_otro 
      from vocacion_tierra vc where activo = true order by nombre")

  end
  
  def save_edit
    
    @solicitud = Solicitud.find(params[:id])
    @linderos_coordenadas = LinderosCoordenadas.new(params[:linderos_coordenadas])
    @linderos_coordenadas.solicitud_id = @solicitud.id
    @linderos_coordenadas.unidad_produccion_id = @solicitud.unidad_produccion_id
    @linderos_coordenadas.seguimiento_visita_id =  params[:seguimiento_visita_id]
      
    @unidad_produccion = UnidadProduccion.find(@solicitud.unidad_produccion_id)
    @unidad_produccion.lindero_norte = @linderos_coordenadas.lindero_norte
    @unidad_produccion.lindero_sur = @linderos_coordenadas.lindero_sur
    @unidad_produccion.lindero_este = @linderos_coordenadas.lindero_este
    @unidad_produccion.lindero_oeste = @linderos_coordenadas.lindero_oeste
    
    logger.debug "-------------------------------"
    logger.debug params[:unidad_produccion_vocacion_tierra].class.name
    params[:unidad_produccion_vocacion_tierra].each {|e|
      vocacion_tierra = VocacionTierra.new
      vocacion_tierra
    }
    
     
    if @linderos_coordenadas.save
      @unidad_produccion.save
      render :update do |page|
        message = "La informaci&oacute;n se actualiz&oacute; con éxito."
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end 
  end

  def save_new_utm
    errores = UtmUnidadProduccion.create_new(params[:utm_unidad_produccion], params[:unidad_produccion_id])
    if errores == true
      @unidad_produccion = UnidadProduccion.find(params[:unidad_produccion_id])
      @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", params[:unidad_produccion_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'linderos_coordenadas_utm', :partial => 'utm'
        page.replace_html 'message', "Datos Utm se Guardo con éxito"
        page.show 'linderos_coordenadas_utm'
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "document.getElementById('agregar_utm').style.display= '';"
      end
    end
  end

  def delete_utm
    logger.debug "------------------UP:" << params[:unidad_produccion_id]
    logger.debug "------------------utm:" << params[:id]
    UtmUnidadProduccion.delete(params[:id])
    @unidad_produccion = UnidadProduccion.find(params[:unidad_produccion_id])
    @utm_unidad_produccion_list = UtmUnidadProduccion.find(:all, :conditions=>["unidad_produccion_id = ?", params[:unidad_produccion_id]])   
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'linderos_coordenadas_utm', :partial => 'utm'
      page.replace_html 'message', "Se ha eliminado el registro con éxito"
      page.show 'linderos_coordenadas_utm'
      page.show 'message'
    end
  end
   
  def save_vocacion

    @solicitud = Solicitud.find(params[:solicitud_id])
    @unidad_produccion_vocacion = UnidadProduccionVocacionTierra.find(:all, :conditions=>['solicitud_id = ? and vocacion_tierra_id = ? and seguimiento_visita_id = ?', @solicitud.id, params[:id], params[:sv_id]])
      
    if @unidad_produccion_vocacion.blank?
      @unidad_produccion_vocacion = UnidadProduccionVocacionTierra.new
      @unidad_produccion_vocacion.solicitud_id = @solicitud.id
      @unidad_produccion_vocacion.unidad_produccion_id = @solicitud.unidad_produccion_id
      @unidad_produccion_vocacion.vocacion_tierra_id = params[:id]
      @unidad_produccion_vocacion.seguimiento_visita_id = params[:sv_id]
      @unidad_produccion_vocacion.save
      render :update do |page|
        message = "La vocacion de la tierra se modificó con éxito."
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      @unidad_produccion_vocacion[0].destroy
      render :update do |page|
        message = "La vocacion de la tierra se modificó con éxito."
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
    return false
  end
    
  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_entity = 'linderos_coordenadas'
    @form_identity_field = 'lindero_norte'
    @width_layout = '955'
  end
end