# encoding: UTF-8
#
# autor: Luis Rojas
# clase: Basico::CorvertidorController
# descripción: Creada en Rails 3

class Basico::ConvertidorController < FormAjaxController
  
  skip_before_filter :set_charset, :only=>[:clase_search]

  def index
    list
  end

  def list
    
    params['sort'] = "id" unless params['sort']
    conditions = "id > 0"
    
    @list = Convertidor.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @moneda = Moneda.find(:all, :conditions=>"activo = true", :order => "nombre")
    @convertidor = Convertidor.new
    parametros = ParametroGeneral.first
    @meneda_activa = parametros.moneda_id
    form_new @convertidor
  end

  def save_new
    @convertidor = Convertidor.new(params[:convertidor])
    form_save_new @convertidor
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @convertidor = Convertidor.find(params[:id])
    form_delete @convertidor
  end
  
  def edit
    @moneda = Moneda.find(:all, :conditions=>"activo = true", :order => "nombre")
    @convertidor = Convertidor.find(params[:id])
    form_edit @convertidor
  end
  
  def save_edit
    @convertidor = Convertidor.find(params[:id])
    form_save_edit @convertidor
  end

  def cancel_edit
    @convertidor = Convertidor.find(params[:id])
    form_cancel_edit @convertidor
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Vistas.General.convertidor')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.convertidor')
    @form_entity = 'convertidor'
    @form_identity_field = 'origen_destino'
    @width_layout = '950'
  end
  
end