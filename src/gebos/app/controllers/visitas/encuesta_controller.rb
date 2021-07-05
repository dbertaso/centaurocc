# encoding: utf-8

#
# autor: Luis Rojas
# clase: Visitas::EncuestaController
# descripción: Migración a Rails 3
#
class Visitas::EncuestaController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:save_visita, :save_visita_topico]

  def index
    list
  end

  def list
    _list
  end

  def save_visita
    @encuesta_visita = EncuestaVisita.find(params[:id])
    @encuesta_visita.respuesta = params[:respuesta]
    @encuesta_visita.save
    render :update do |page|
        message = "#{@form_title_record} '#{@encuesta_visita.analisis_conclusion.numero.to_s << '.-' << @encuesta_visita.analisis_conclusion.nombre}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.se_ha_guardado')}"
    		page.visual_effect :highlight, "row_#{@encuesta_visita.id}", :duration => 0.6
        page.replace_html 'message', message
        page.show 'message'
  		end
  end

  def save_visita_topico
    @encuesta_visita_topico = EncuestaVisitaTopico.find(params[:id])
    @encuesta_visita_topico.respuesta = params[:respuesta]
    @encuesta_visita_topico.save
    render :update do |page|
        message = "#{@form_title_record} '#{@encuesta_visita_topico.analisis_topico.nombre}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.se_ha_guardado')}"
    		page.visual_effect :highlight, "rows_#{@encuesta_visita_topico.id}", :duration => 0.6
        page.replace_html 'message', message
        page.show 'message'
  		end
  end
    
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.pregunta')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Form.item')
    @form_entity = 'solicitud_desicion'
    @form_identity_field = 'id'
    @width_layout = '955'
  end

  private
  def _list
    @seguimiento_visita = SeguimientoVisita.find(params[:seguimiento_visita_id])
    @solicitud = Solicitud.find(@seguimiento_visita.solicitud_id)
    @encuesta_visita_list = EncuestaVisita.find_by_sql("select e.id, e.respuesta, e.seguimiento_visita_id, a.numero, a.nombre from encuesta_visita e join analisis_conclusion a on a.id = e.analisis_conclusion_id where e.seguimiento_visita_id = #{@seguimiento_visita.id} order by a.numero, nombre")
    unless @encuesta_visita_list.length > 0
      encuesta_visita = EncuestaVisita.new
      encuesta_visita.clonar(@seguimiento_visita.id)
      @encuesta_visita_list = EncuestaVisita.find_by_sql("select e.id, e.respuesta, e.seguimiento_visita_id, a.numero, a.nombre from encuesta_visita e join analisis_conclusion a on a.id = e.analisis_conclusion_id where e.seguimiento_visita_id = #{@seguimiento_visita.id} order by a.numero, nombre")
    end
    @encuesta_topico_list = EncuestaVisitaTopico.find_by_sql("select e.id, e.respuesta, e.seguimiento_visita_id , a.nombre from encuesta_visita_topico e join analisis_topico a on a.id = e.analisis_topico_id where e.seguimiento_visita_id = #{@seguimiento_visita.id} order by nombre")
    unless @encuesta_topico_list.length > 0
      encuesta_visita_topico = EncuestaVisitaTopico.new
      encuesta_visita_topico.clonar(@seguimiento_visita.id)
      @encuesta_topico_list = EncuestaVisitaTopico.find_by_sql("select e.id, e.respuesta, e.seguimiento_visita_id , a.nombre from encuesta_visita_topico e join analisis_topico a on a.id = e.analisis_topico_id where e.seguimiento_visita_id = #{@seguimiento_visita.id} order by nombre")
    end
  end
  
end