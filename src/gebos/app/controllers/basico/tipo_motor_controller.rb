# encoding: utf-8
class Basico::TipoMotorController < FormAjaxController

  def index
    list
  end

  def list  
    params['sort'] = "tipo" unless params['sort']
    conditions = 'id > 0'
    
    @list = TipoMotor.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_motor = TipoMotor.new
    form_new @tipo_motor
  end

  def save_new
    @tipo_motor = TipoMotor.new(params[:tipo_motor])
    form_save_new @tipo_motor
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_motor = TipoMotor.find(params[:id])
    form_delete @tipo_motor
  end
  
  def edit
    @tipo_motor = TipoMotor.find(params[:id])
    form_edit @tipo_motor
  end

  def save_edit
    @tipo_motor = TipoMotor.find(params[:id])
    form_save_edit @tipo_motor
  end

  def cancel_edit
    @tipo_motor = TipoMotor.find(params[:id])
    form_cancel_edit @tipo_motor
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoMotor.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoMotor.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoMotor.FormTitles.form_title_records')
    @form_entity = 'tipo_motor'
    @form_identity_field = 'tipo'
  end
  
end
