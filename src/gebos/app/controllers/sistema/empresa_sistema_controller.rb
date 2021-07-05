# encoding: utf-8

# autor: Luis Rojas
# clase: Sistema::EmpresaSistemaController
# descripción: Creado en Rails 3

class Sistema::EmpresaSistemaController < FormAjaxController

	def index
    unless @usuario.admin_empresa == true
      render  :layout => 'form_basic'
    end
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    
    conditions = 'id > 0'
    
    
    @list = EmpresaSistema.search(conditions, params[:page], params[:sort])
    @total=@list.count
    @pages = @list.clone
    form_list
  end
	
  def new
    @empresa_sistema = EmpresaSistema.new
    @empresa_sistema.activo = true
		form_new @empresa_sistema
  end
  
  def cancel_new
		form_cancel_new
  end

  def save_new
    @empresa_sistema = EmpresaSistema.new(params[:empresa_sistema])
    @empresa_sistema.rif = params[:empresa_sistema][:rif_1] + '-' + params[:empresa_sistema][:rif_2] + '-' + params[:empresa_sistema][:rif_3]
		form_save_new @empresa_sistema
  end
  
  def delete
    @empresa_sistema = EmpresaSistema.find(params[:id])
    result = @empresa_sistema.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @empresa_sistema, 'empresa_sistema'
      end
    end
  end
  
  def edit
    @empresa_sistema = EmpresaSistema.find(params[:id])
    form_edit @empresa_sistema
  end
  
  def save_edit
    @empresa_sistema = EmpresaSistema.find(params[:id])
		form_save_edit @empresa_sistema
  end
  
  def cancel_edit
    @empresa_sistema = EmpresaSistema.find(params[:id])
		form_cancel_edit @empresa_sistema
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.General.empresa_sistema')
    @form_title_record = I18n.t('Sistema.Body.General.empresa_sistema')
    @form_title_records = I18n.t('Sistema.Body.General.empresa_sistema')
    @form_entity = 'empresa_sistema'
    @form_identity_field = 'nombre'
    @width_layout = '1000'
  end
  
  def fill
    @estado_select = Estado.find(:all, :order=>'nombre')   
	@ciudad_select = []    	
	@municipio_select = []  
  end
  
end
