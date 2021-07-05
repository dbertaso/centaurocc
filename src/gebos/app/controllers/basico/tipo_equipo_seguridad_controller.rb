# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoEquipoSeguridadController
# descripción: Migración a Rails 3
#
class Basico::TipoEquipoSeguridadController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "tipo" unless params['sort']

    
    conditions=''
	@list = TipoEquipoSeguridad.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list
  end

  def new
    @tipo_equipo_seguridad = TipoEquipoSeguridad.new
    form_new @tipo_equipo_seguridad
  end

  def save_new
    @tipo_equipo_seguridad = TipoEquipoSeguridad.new(params[:tipo_equipo_seguridad])
    form_save_new @tipo_equipo_seguridad
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(params[:id])
    form_delete @tipo_equipo_seguridad
  end
  
  def edit
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(params[:id])
    form_edit @tipo_equipo_seguridad
  end

  def save_edit
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(params[:id])
    form_save_edit @tipo_equipo_seguridad
  end

  def cancel_edit
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(params[:id])
    form_cancel_edit @tipo_equipo_seguridad
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoEquipoSeguridad.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoEquipoSeguridad.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoEquipoSeguridad.FormTitles.form_title_records')
    @form_entity = 'tipo_equipo_seguridad'
    @form_identity_field = 'tipo'
  end
  
end
