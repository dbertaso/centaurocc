# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::MunicipioParroquiaController
# descripción: Migración a Rails 3
#

class Basico::MunicipioParroquiaController < FormAjaxTabsController

  def index
    list
  end

  def list
    
    conditions = ["municipio_id = ?", params[:municipio_id]]
    params['sort'] = "nombre" unless params['sort']
    

    @list = Parroquia.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count

    form_list

  end 

  def new
    @municipio = Municipio.find(params[:municipio_id])
    @parroquia = Parroquia.new    
    form_new @parroquia
  end

  
  
  def save_new
    @parroquia = Parroquia.new(params[:parroquia])    
    @parroquia.municipio_id=params[:municipio_id]
    form_save_new @parroquia
  end
  
  def edit
    @parroquia = Parroquia.find(params[:id])
    form_edit @parroquia
  end
  
  def save_edit
    @parroquia = Parroquia.find(params[:id])
    form_save_edit @parroquia
  end
  def cancel_edit
    @parroquia = Parroquia.find(params[:id])
    form_cancel_edit @parroquia
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @parroquia = Parroquia.find(params[:id])
    form_delete @parroquia
  end  


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.parroquia')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.parroquias')
    @form_entity = 'parroquia'
    @form_identity_field = 'nombre'
    @estado=Municipio.find(:first,:conditions=>"id=#{params[:municipio_id]}").estado
    @municipio = Municipio.find(params[:municipio_id])
    
  end
end

