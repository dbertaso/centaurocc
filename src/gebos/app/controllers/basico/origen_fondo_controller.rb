# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::OrigenFondoController
# descripción: Migración a Rails 3
#
class Basico::OrigenFondoController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = OrigenFondo.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @origen_fondo = OrigenFondo.new
    @banco_origen = BancoOrigen.find(:all, :order=>'nombre')
    form_new @origen_fondo
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @origen_fondo = OrigenFondo.new(params[:origen_fondo])
    form_save_new @origen_fondo
  end
  
  def delete
    @origen_fondo = OrigenFondo.find(params[:id])
    form_delete @origen_fondo
  end
  
  def edit
    @origen_fondo = OrigenFondo.find(params[:id])
    @banco_origen = BancoOrigen.find(:all, :order=>'nombre')
    form_edit @origen_fondo
  end
  def save_edit
    @origen_fondo = OrigenFondo.find(params[:id])
    form_save_edit @origen_fondo
  end
  def cancel_edit
    @origen_fondo = OrigenFondo.find(params[:id])
    form_cancel_edit @origen_fondo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.OrigenFondo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.OrigenFondo.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.OrigenFondo.FormTitles.form_title_records')
    @form_entity = 'origen_fondo'
    @form_identity_field = 'nombre'
  end
  
end
