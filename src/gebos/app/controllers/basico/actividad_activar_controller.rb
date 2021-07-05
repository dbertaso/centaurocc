# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ActividadActivarController
# descripción: Migración a Rails 3
#
class Basico::ActividadActivarController < FormTabTabsController

  def index
    @actividad = Actividad.find(params[:actividad_id])
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    total_oficinas = Oficina.count()
    total_actividad_oficina = ActividadOficina.count(:conditions=>['actividad_id = ?', @actividad.id])
    ActividadOficina.clonar(@actividad.id) if total_oficinas > total_actividad_oficina
    @estado_list = Estado.find(:all, :order=>'nombre')
    valor = ActividadOficina.oficinas(@actividad.id)
    @oficinas = valor[0]
    @oficina_id = valor[1]
  end

  def save_new
    actividad = Actividad.find(params[:actividad_id])
    ids = params[:oficina].to_s[0, ((params[:oficina].to_s.length) -1)]
    unless ids.to_s.length > 0
      ids = "0"
    end
    ActividadOficina.find_by_sql("UPDATE actividad_oficina SET activo = false WHERE actividad_id = #{actividad.id}")
    ActividadOficina.find_by_sql("UPDATE actividad_oficina SET activo = true WHERE id in (#{ids})")
    flash[:notice] = "#{I18n.t('Sistema.Body.Controladores.ActividadActivar.Mensajes.activado_desactivado')} '#{actividad.nombre}' #{I18n.t('Sistema.Body.Controladores.ActividadActivar.Mensajes.oficinas_seleccionadas')}"
    render :update do |page|
      page.redirect_to :action=>'index', :actividad_id => actividad.id, :popup=>params[:popup]
    end
    return
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ActividadActivar.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ActividadActivar.FormTitles.form_title_record')
    @form_entity = 'actividad_activar'
    @form_identity_field = 'id'
    @width_layout = '1200'
  end

end
