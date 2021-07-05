# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausaDevolucionClienteController
# descripción: Migración a Rails 3
#


class Basico::CausaDevolucionClienteController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    
	conditions=''
	@list = CausaDevolucionCliente.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list

  end
	
  def new
    @causa_devolucion_cliente = CausaDevolucionCliente.new
		form_new @causa_devolucion_cliente
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @causa_devolucion_cliente = CausaDevolucionCliente.new(params[:causa_devolucion_cliente])
		form_save_new @causa_devolucion_cliente
  end
  
  def delete
    @causa_devolucion_cliente = CausaDevolucionCliente.find(params[:id])
		form_delete @causa_devolucion_cliente
  end
  
  def edit
    @causa_devolucion_cliente = CausaDevolucionCliente.find(params[:id])
		form_edit @causa_devolucion_cliente
  end
  def save_edit
    @causa_devolucion_cliente = CausaDevolucionCliente.find(params[:id])
		form_save_edit @causa_devolucion_cliente
  end
  def cancel_edit
    @causa_devolucion_cliente = CausaDevolucionCliente.find(params[:id])
		form_cancel_edit @causa_devolucion_cliente
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CausaDevolucionCliente.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CausaDevolucionCliente.FormTitles.form_title_records')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CausaDevolucionCliente.FormTitles.form_title_records')
    @form_entity = 'causa_devolucion_cliente'
    @form_identity_field = 'nombre'
  end
  
end
