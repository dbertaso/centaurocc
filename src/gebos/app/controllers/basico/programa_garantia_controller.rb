# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaGarantiaController
# descripción: Migración a Rails 3
#

class Basico::ProgramaGarantiaController < FormAjaxTabsController

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
    @programa_tipo_garantia = ProgramaTipoGarantia.new
    fill_programa_tipo_garantia
    form_new @programa_tipo_garantia
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_garantia = ProgramaTipoGarantia.new(params[:programa_tipo_garantia])
    @programa_tipo_garantia.programa = @programa
    form_save_new @programa_tipo_garantia
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_garantia = ProgramaTipoGarantia.find(params[:id])
    result = @programa_tipo_garantia.delete(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @programa_tipo_garantia, 'programa_tipo_garantia'
      end
    end
    #form_delete @programa_tipo_garantia
  end
  
  def edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_garantia = ProgramaTipoGarantia.find(params[:id])
    fill_programa_tipo_garantia
    form_edit @programa_tipo_garantia
  end
  
  def cancel_edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_garantia = ProgramaTipoGarantia.find(params[:id])
    form_cancel_edit @programa_tipo_garantia
  end
  
  def save_edit
    @programa = Programa.find(params[:programa_id])
    @programa_tipo_garantia = ProgramaTipoGarantia.find(params[:id])
    form_save_edit @programa_tipo_garantia
  end
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaGarantia.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaGarantia.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaGarantia.FormTitles.form_title_records')
    @form_entity = 'programa_tipo_garantia'
    @form_identity_field = 'nombre_garantia'
    @width_layout = 850
  end

  private
  def fill_programa_tipo_garantia
    @tipo_garantia_select = TipoGarantia.find(:all, :order=>'nombre',
      :conditions=>"activo = true and ( tipo_garantia.id not in (select tipo_garantia_id from programa_tipo_garantia where programa_id = #{@programa.id} ) ) ")
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["programa_tipo_garantia.programa_id = ?", @programa.id]
    joins = 'INNER JOIN tipo_garantia ON programa_tipo_garantia.tipo_garantia_id = tipo_garantia.id'
    params['sort'] = "Programa_tipo_garantia.id" unless params['sort']
    
    @list = ProgramaTipoGarantia.search(conditions, params[:page], params[:sort])
    @total=@list.count


  end
end
