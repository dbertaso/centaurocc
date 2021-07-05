# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::ClaseController
# descripción: Migración a Rails 3

class Basico::ClaseController < FormAjaxController
  
  def index
    list
  end
  
  def list
    params['sort'] = "clase.nombre" unless params['sort']
    condition = "clase.id > 0"
    
    @list = Clase.search(condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @tipo_maquinaria = TipoMaquinaria.find(:all)
    @clase = Clase.new
    form_new @clase
  end

  def save_new
    @clase = Clase.new(params[:clase])
    form_save_new @clase
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @clase = Clase.find(params[:id])
    form_delete @clase
  end
  
  def edit
    @tipo_maquinaria = TipoMaquinaria.find(:all)
    @clase = Clase.find(params[:id])
    form_edit @clase
  end
  
  def save_edit
    @clase = Clase.find(params[:id])
    form_save_edit @clase
  end

  def cancel_edit
    @clase = Clase.find(params[:id])
    form_cancel_edit @clase
  end

  protected
  def common
   super
    @form_title          = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.maquinarias')}"
    @form_title_records  = "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.maquinaria')}"
    @form_entity         = 'clase'
    @form_identity_field = 'nombre'
  end
  
end
