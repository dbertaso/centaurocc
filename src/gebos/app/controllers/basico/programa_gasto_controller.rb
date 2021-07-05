# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaGastoController
# descripción: Migración a Rails 3
#
class Basico::ProgramaGastoController < FormAjaxTabsController

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
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_gasto = ProgramaTipoGasto.new
    fill_programa_tipo_gasto
    form_new @programa_tipo_gasto
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    logger.info 'Parametros ======> ' << params.inspect
    params[:programa_tipo_gasto][:programa_id] = @programa.id
    logger.info"XXXXXXX=============ddd============>>>>"<<params[:programa_tipo_gasto].inspect
    @programa_tipo_gasto = ProgramaTipoGasto.new(params[:programa_tipo_gasto])
#    @programa_tipo_gasto.tipo_gasto_id = params[:programa_tipo_gasto][:tipo_gasto_id]
#    @programa_tipo_gasto.porcentaje_f=(params[:programa_tipo_gasto][:porcentaje_f])
#    @programa_tipo_gasto.monto_fijo_f=(params[:programa_tipo_gasto][:monto_fijo_f])
    #@programa_tipo_gasto.programa = @programa
    logger.info"XXXXXXX=============xxxxx============>>>>"<<@programa_tipo_gasto.inspect
    form_save_new @programa_tipo_gasto
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_gasto = ProgramaTipoGasto.find(params[:id])
    form_delete @programa_tipo_gasto
  end

  def edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_gasto = ProgramaTipoGasto.find(params[:id])
    fill_programa_tipo_gasto
    form_edit @programa_tipo_gasto
  end

  def cancel_edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_gasto = ProgramaTipoGasto.find(params[:id])
    form_cancel_edit @programa_tipo_gasto
  end

  def save_edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_gasto = ProgramaTipoGasto.find(params[:id])
    logger.info"XXXXXXXX==============save-edit=============>>>>>"<<params.inspect
    form_save_edit @programa_tipo_gasto
    logger.info"XXXXXXXX==============save-edit=============>>>>>"
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaGasto.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaGasto.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaGasto.FormTitles.form_title_records')
    @form_entity = 'programa_tipo_gasto'
    @form_identity_field = 'tipo_gasto.nombre'
    @width_layout = 850
  end

  private
  def fill_programa_tipo_gasto
    @tipo_gasto_select = TipoGasto.find(:all, :order=>'nombre',
      :conditions=>"activo = true and ( tipo_gasto.id not in (select tipo_gasto_id from programa_tipo_gasto where programa_id = #{@programa.id} ) ) ")
  end
  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["programa_tipo_gasto.programa_id = ?", @programa.id]
    joins = 'INNER JOIN tipo_gasto ON programa_tipo_gasto.tipo_gasto_id = tipo_gasto.id'
    params['sort'] = "tipo_gasto.nombre" unless params['sort']
    
    @list = ProgramaTipoGasto.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end
end
