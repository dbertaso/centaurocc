# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::MiembroComiteController
# descripción: Migración a Rails 3
#

class Basico::MiembroComiteController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']

    
    @list = MiembroComite.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @miembro_comite = MiembroComite.new
    form_new @miembro_comite
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new 
    @miembro_comite = MiembroComite.new(params[:miembro])
    form_save_new @miembro_comite
  end
  
  def delete
    
    logger.info "Id =====> #{params[:id]}"
    @miembro_comite = MiembroComite.find(params[:id].to_i)
    logger.info "MiembroComite ======> #{@miembro_comite.inspect}"
    result = @miembro_comite.eliminar(params[:id].to_i)
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @miembro_comite, 'miembro_comite'
      end
    end
    
  end
  
  def edit
    @miembro_comite = MiembroComite.find(params[:id])
    form_edit @miembro_comite
  end
  def save_edit
    @miembro_comite = MiembroComite.find(params[:id])
    form_save_edit @miembro_comite
  end
  def cancel_edit
    @miembro_comite = MiembroComite.find(params[:id])
    form_cancel_edit @miembro_comite
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.MiembroComite.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.MiembroComite.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.MiembroComite.FormTitles.form_title_records')
    @form_entity = 'miembro_comite'
    @form_identity_field = 'nombre'
  end
  
end
