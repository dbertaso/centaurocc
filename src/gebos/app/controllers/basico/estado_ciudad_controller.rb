# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EstadoCiudadController
# descripción: Migración a Rails 3
#

class Basico::EstadoCiudadController < FormAjaxTabsController

  def index
    list
  end

  def list
    @estado = Estado.find(params[:estado_id])
    conditions = ["ciudad.estado_id = ?", @estado.id]
    params['sort'] = "nombre" unless params['sort']
    

    @list = Ciudad.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count

    form_list

  end	

  def new
    @estado = Estado.find(params[:estado_id])
    @ciudad = Ciudad.new    
    form_new @ciudad
  end

  def view
    list_view
  end
  
  def list_view    
    @estado = Estado.find(params[:estado_id])
    conditions = ["ciudad.estado_id = ?", @estado.id]
    params['sort'] = "nombre" unless params['sort']
    

    @list = Ciudad.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count


    form_list_view
  end

  def save_new
    @ciudad = Ciudad.new(params[:ciudad])
    @ciudad.estado = @estado
    form_save_new @ciudad
  end
  
  def edit
    @ciudad = Ciudad.find(params[:id])
    form_edit @ciudad
  end
  def save_edit
    @ciudad = Ciudad.find(params[:id])
    form_save_edit @ciudad
  end
  def cancel_edit
    @ciudad = Ciudad.find(params[:id])
    form_cancel_edit @ciudad
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @ciudad = Ciudad.find(params[:id])
    form_delete @ciudad
  end  


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.ciudad')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.ciudades')
    @form_entity = 'ciudad'
    @form_identity_field = 'nombre'
    @estado = Estado.find(params[:estado_id])
  end

  def protect
    action = super
    return action unless action.nil?
    case action_name
    when 'list'
      nil
    when /^_/
      'edit'
    end
  end

end

