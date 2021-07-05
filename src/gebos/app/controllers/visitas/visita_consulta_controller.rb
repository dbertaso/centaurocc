# encoding: utf-8
class Visitas::VisitaConsultaController < FormTabTabsController

  def view
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    fill
    @unidad_produccion = @seguimiento_visita.solicitud.unidad_produccion
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = 'Control de Visitas'
    @form_title_record = 'Control de Visita'
    @form_title_records = 'Control de Visitas'
    @form_entity = 'seguimiento_visita'
    @form_identity_field = 'codigo_visita'
    @width_layout = '955'
    @full_info = "#{@visitas.codigo_visita} del Trámite #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  def fill
    @motivo_visita_list = MotivoVisita.find(:all, :conditions=>'id > 1', :order=>'id')
  end
end