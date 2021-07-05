# encoding: utf-8
class Sistema::DepartamentoController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = 'id > 0'
    
    @list = Departamento.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @departamento = Departamento.new
    form_new @departamento
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @departamento = Departamento.new(params[:departamento])
    form_save_new @departamento
  end
  
  def delete
    @departamento = Departamento.find(params[:id])
    form_delete @departamento
  end
  
  def edit
    @departamento = Departamento.find(params[:id])
    form_edit @departamento
  end

  def save_edit
    @departamento = Departamento.find(params[:id])
    form_save_edit @departamento
  end

  def cancel_edit
    @departamento = Departamento.find(params[:id])
    form_cancel_edit @departamento
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Departamento.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Departamento.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Departamento.FormTitles.form_title_records')
    @form_entity = 'departamento'
    @form_identity_field = 'nombre'
  end



end
