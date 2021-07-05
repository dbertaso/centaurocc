# encoding: utf-8
class Basico::TiposSemovientesController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = TiposSemovientes.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end


  def new
    @tipos_semovientes = TiposSemovientes.new
    form_new @tipos_semovientes
  end

  def save_new
    @tipos_semovientes = TiposSemovientes.new(params[:tipos_semovientes])
    form_save_new @tipos_semovientes
  end


  def cancel_new
		form_cancel_new
  end


  def delete
    begin
      @tipos_semovientes = TiposSemovientes.find(params[:id])
      form_delete @tipos_semovientes
    rescue StandardError =>e
      render :update do |page|
        page.alert("#{I18n.t('Sistema.Body.Modelos.Errores.tipo_semoviente')}")
      end
    end
  end

  def edit
    @tipos_semovientes = TiposSemovientes.find(params[:id])
    form_edit @tipos_semovientes
  end
  def save_edit
    @tipos_semovientes = TiposSemovientes.find(params[:id])
    form_save_edit @tipos_semovientes
  end
  def cancel_edit
    @tipos_semovientes = TiposSemovientes.find(params[:id])
    form_cancel_edit @tipos_semovientes
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoSemoviente.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoSemoviente.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoSemoviente.FormTitles.form_title_records')
    @form_entity = 'tipos_semovientes'
    @form_identity_field = 'nombre'
  end

end

