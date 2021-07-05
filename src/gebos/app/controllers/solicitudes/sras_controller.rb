# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SrasController
# descripción: Migración a Rails 3
#
class Solicitudes::SrasController < FormTabTabsController
  
  layout 'solicitudes/plan_inversion'
  
  def index
    @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{params[:solicitud_id].to_s}")
    @solicitud = Solicitud.find(params[:solicitud_id])
    @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
    #### Actualización de este modulo para el funcionamiento de los Gastos
    @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
  end
  
    protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = 'Plan de Inversión'
    @form_title_records = 'Plan de Inversión'
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '900'
  end
end
