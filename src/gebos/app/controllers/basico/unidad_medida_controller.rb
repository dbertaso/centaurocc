# encoding: utf-8

#
# autor: Diego Bertaso
# clase: UnidadMedidaController
# descripción: Migración a Rails 3
#


class Basico::UnidadMedidaController < FormAjaxController
  
  def index
    list
  end
  
  def list

    params['sort'] = "unidad_medida.nombre" unless params['sort']

    conditions = "id > 0"
    unless params[:nombre].nil?
      conditions = ["LOWER(unidad_medida.nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end

    
    @list = UnidadMedida.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list

  end
  

  def new
    @unidad_medida = UnidadMedida.new
    form_new @unidad_medida
  end

    
  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:unidad_medida][:nombre])
    params[:unidad_medida][:nombre] = nombre.upcase
    @unidad_medida = UnidadMedida.new(params[:unidad_medida])
    form_save_new @unidad_medida
  end

  def delete
    @unidad_medida = UnidadMedida.find(params[:id])
    form_delete @unidad_medida
  end
  
  def edit
    @unidad_medida = UnidadMedida.find(params[:id])
    form_edit @unidad_medida
  end
  
  def view
    @unidad_medida = UnidadMedida.find(params[:id])
  end
  
  def save_edit
  
    nombre = eliminar_acentos(params[:unidad_medida][:nombre])
    logger.info nombre.upcase
    params[:unidad_medida][:nombre] = nombre.upcase
    @unidad_medida = UnidadMedida.find(params[:id])
    form_save_edit @unidad_medida
  end

  def cancel_edit
    @unidad_medida = UnidadMedida.find(params[:id])
    form_cancel_edit @unidad_medida
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.UnidadMedida.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.UnidadMedida.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.UnidadMedida.FormTitles.form_title_records')
    @form_entity = 'unidad_medida'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
  private

end
