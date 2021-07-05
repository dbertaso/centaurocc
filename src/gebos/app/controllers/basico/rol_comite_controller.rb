# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::RolComiteController
# descripción: Migración a Rails 3

class Basico::RolComiteController < FormAjaxController

  def index
    list
  end

  def list
    params['sort'] = "nombre" unless params['sort']
    condition = "id > 0"
    
    @list = RolComite.search(condition, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @rol_comite = RolComite.new
    form_new @rol_comite
  end

  def save_new
    @rol_comite = RolComite.new(params[:rol_comite])
    form_save_new @rol_comite
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @rol_comite = RolComite.find(params[:id])
    total = ComiteMiembro.count(:conditions => "rol_comite_id = #{@rol_comite.id}")
    unless total > 0
      form_delete @rol_comite
    else
      @rol_comite.errors.add(nil, "Rol en el comité está siendo usado por la instancia de aprobación")
      render :update do |page|
        page.form_error
      end
    end
  end
  
  def edit
    @rol_comite = RolComite.find(params[:id])
    form_edit @rol_comite
  end
  
  def save_edit
    @rol_comite = RolComite.find(params[:id])
    form_save_edit @rol_comite
  end
  
  def cancel_edit
    @rol_comite = RolComite.find(params[:id])
    form_cancel_edit @rol_comite
  end
  
  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.RolComite.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.RolComite.FormTitles.form_title')
    @form_entity = 'rol_comite'
    @form_identity_field = 'nombre'
  end
  
end
