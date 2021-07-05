# encoding: UTF-8

#
# 
# clase: Solicitudes::ConsultaSrasController
# descripción: Migración a Rails 3
#


class Solicitudes::ConsultaSrasController < FormTabTabsController
  
  layout 'solicitudes/plan_inversion'
  
  def view
    @solicitud = Solicitud.find(params[:solicitud_id])
    unless @solicitud.sub_sector.nemonico == 'MA'
      @plan_inversion = PlanInversion.find(:all, :conditions=>"solicitud_id = #{params[:solicitud_id].to_s}")
    end
    @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
    #### Actualización de este modulo para el funcionamiento de los Gastos
    @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
    
  end
  
    protected
  def common
    super
    @form_title = 'Plan de Inversión'
    @form_title_record = 'Plan de Inversión'
    @form_title_records = 'Plan de Inversión'
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '920'
  end
end
