# encoding: utf-8
class Visitas::VisitaDescripcionesEspecificasController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[ :tabs ]
  
  def index
  end
	
  def edit
    @visitas = SeguimientoVisita.find(params[:id])
      @seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(params[:id])
      @descripciones_especificas = DescripcionesEspecificas.find_by_seguimiento_cultivo_id(@seguimiento_cultivo.id)
      if @descripciones_especificas.nil?
        @descripciones_especificas = DescripcionesEspecificas.new
      end
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end
  
  def save_edit
    @descripciones_especificas = DescripcionesEspecificas.find_by_seguimiento_cultivo_id(params[:seguimiento_cultivo_id])
    if @descripciones_especificas.nil?
      @descripciones_especificas = DescripcionesEspecificas.new(:seguimiento_cultivo_id=>params[:seguimiento_cultivo_id],:seguimiento_visita_id => params[:seguimiento_visita_id])
    end
    @descripciones_especificas.update_attributes(params[:descripciones_especificas])

    if @descripciones_especificas.save
      
      render :update do |page|
          page.replace_html 'messages', I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspecificas.Messages.se_actualizo')
          page.hide 'error'
          page.show 'messages'
      end

    else
      render :update do |page|
        page.hide 'messages'
        page.form_error
      end
    end

  end
  
  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspecificas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspecificas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspecificas.FormTitles.form_title_records')
    @form_entity ='codigo_visita'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end
  private
 
  
end
