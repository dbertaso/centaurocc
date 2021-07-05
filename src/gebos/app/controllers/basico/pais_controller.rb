# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: pais
# descripción: Migración a Rails 3
#

class Basico::PaisController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = Pais.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @pais = Pais.new
    form_new @pais
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @pais = Pais.new(params[:pais])
    @pais.abreviacion = @pais.abreviacion.upcase
    form_save_new @pais
  end
  
  def delete
    @pais = Pais.find(params[:id])
    form_delete @pais
  end
  
  def edit
    @pais = Pais.find(params[:id])
    form_edit @pais
  end
  
  def save_edit
    @pais = Pais.find(params[:id])
    @pais.nombre = params[:pais][:nombre]
    @pais.abreviacion = params[:pais][:abreviacion].upcase
    form_save_edit @pais, :value=>@pais.save
  end
  def cancel_edit
    @pais = Pais.find(params[:id])
    form_cancel_edit @pais
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Pais.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Pais.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Pais.FormTitles.form_title_records')
    @form_entity = 'pais'
    @form_identity_field = 'nombre'
  end
  
end
