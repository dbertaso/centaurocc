# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudConsultaEventoController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudConsultaEventoController < FormTabsController

  layout 'form_basic'

  def index
  
    @list = nil
    @solicitud = Solicitud.find(params[:id])
    list(@solicitud.id)
    
    form_list
    
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.consulta')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.eventos')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.eventos')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.eventos')
    @form_entity = 'evento'
    @form_identity_field = 'numero'
    @width_layout = '800'
  end
  
  private
  def list(id)
  
    params['sort'] = 'fecha_evento' unless params['sort']
    
    condition = "solicitud_id = #{id}"
    
    @list = ViewConsultaEvento.search(condition, params[:page], params['sort'])
    @total=@list.count
  end

end
