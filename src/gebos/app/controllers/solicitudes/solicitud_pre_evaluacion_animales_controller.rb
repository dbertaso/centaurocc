# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionAnalisisController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionAnimalesController < FormTabTabsController

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
   
    @solicitud = Solicitud.find(params[:id])
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @unidad_produccion_inventario_animales = UnidadProduccionInventarioAnimales.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])

  end
  
  def save_edit
    
    @solicitud = Solicitud.find(params[:id])
    @unidad_produccion_inventario_animales = UnidadProduccionInventarioAnimales.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])
    
    if @unidad_produccion_inventario_animales == nil
      @unidad_produccion_inventario_animales = UnidadProduccionInventarioAnimales.new(params[:unidad_produccion_inventario_animales])

      @unidad_produccion_inventario_animales.solicitud_id = @solicitud.id
      @unidad_produccion_inventario_animales.unidad_produccion_id = @solicitud.unidad_produccion_id
      @unidad_produccion_inventario_animales.seguimiento_visita_id =  params[:seguimiento_visita_id]
    else
      @unidad_produccion_inventario_animales.update_attributes(params[:unidad_produccion_inventario_animales])
    end  
        if @unidad_produccion_inventario_animales.save
          flash[:notice] = I18n.t('Sistema.Body.Vistas.General.se_actualizo_inventario_animales')
          render :update do |page|
            page.redirect_to :action=>'edit', :id=>@solicitud.id, :seguimiento_visita_id=>@unidad_produccion_inventario_animales.seguimiento_visita_id,  :popup=>params[:popup]
          end
        else
          render :update do |page|
            page.form_error
          end
        end
    
        
    #@linderos_coordenadas.save
    #render :update do |page|
    #  message = "La informaci&oacute;n se actualiz&oacute; con éxito."
    #  page.hide 'error'
    #  page.replace_html 'message', message
    #  page.show 'message'
    #end
  end

  
  def save_vocacion

    @solicitud = Solicitud.find(params[:solicitud_id])
    @unidad_produccion_vocacion = UnidadProduccionVocacionTierra.find(:all, :conditions=>['solicitud_id = ? and vocacion_tierra_id = ? and seguimiento_visita_id = ?', @solicitud.id, params[:id], params[:sv_id]])
      
    if @unidad_produccion_vocacion[0]  == nil
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
  end
    


  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_entity = 'unidad_produccion_inventario_animales'
    @form_identity_field = 'lindero_norte'
    @width_layout = '955'

  end
  

end