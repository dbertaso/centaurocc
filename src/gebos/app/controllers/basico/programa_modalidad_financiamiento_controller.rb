# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaModalidadFinanciamientoController
# descripción: Migración a Rails 3
#

class Basico::ProgramaModalidadFinanciamientoController < FormAjaxTabsController

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
    @modalidad_financiamiento = ModalidadFinanciamiento.new
    fill_modalidad_financiamiento
    form_new @modalidad_financiamiento
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:modalidad_financiamiento][:id])
    form_save_new @modalidad_financiamiento, :value=>@programa.add_modalidad_financiamiento(@modalidad_financiamiento)
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @modalidad_financiamiento = ModalidadFinanciamiento.find(params[:id])
    form_delete @modalidad_financiamiento, @programa.modalidades_financiamiento.delete(@modalidad_financiamiento)
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ModalidadFinanciamiento.FormTitles.form_title_records')
    @form_entity = 'modalidad_financiamiento'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end

  private
  def fill_modalidad_financiamiento
    @modalidad_financiamiento_select = ModalidadFinanciamiento.find(:all, :order=>'nombre', :conditions=>"activo = true and ( modalidad_financiamiento.id not in (select modalidad_financiamiento_id from programa_modalidad_financiamiento where programa_id = #{@programa.id} ) ) ")
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["programa_modalidad_financiamiento.programa_id = ?", @programa.id]
    params['sort'] = "modalidad_financiamiento.nombre" unless params['sort']
    
    @list = ModalidadFinanciamiento.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end
end
