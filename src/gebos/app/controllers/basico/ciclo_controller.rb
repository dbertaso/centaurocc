# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CicloController
# descripción: Migración a Rails 3
#

class Basico::CicloController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "nombre" unless params['sort']

    conditions=''
    @list = CicloProductivo.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list
  end

  def new
    @ciclo_productivo = CicloProductivo.new    
    form_new @ciclo_productivo
  end

  def save_new
    @ciclo_productivo = CicloProductivo.new(params[:ciclo_productivo])

    resultado = @ciclo_productivo.save
    if resultado == true
      flash[:notice] = I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.se_ha_guardado_registro_con_exito')
      render :update do |page|
        page.redirect_to :action=>'index'
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @ciclo_productivo = CicloProductivo.find(params[:id])
    form_delete @ciclo_productivo
  end
  
  def edit
    @ciclo_productivo = CicloProductivo.find(params[:id])    
    form_edit @ciclo_productivo
  end
  
  def save_edit
    @ciclo_productivo = CicloProductivo.find(params[:id])
    @ciclo_productivo.nombre = params[:ciclo_productivo][:nombre]
    @ciclo_productivo.descripcion = params[:ciclo_productivo][:descripcion]
    @ciclo_productivo.mes_inicio = params[:ciclo_productivo][:mes_inicio]
    @ciclo_productivo.mes_fin = params[:ciclo_productivo][:mes_fin]
    @ciclo_productivo.activo = params[:ciclo_productivo][:activo]
    resultado = @ciclo_productivo.save
    if resultado == true
      flash[:notice] = I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.se_ha_modificado_registro_con_exito')
      render :update do |page|
        page.redirect_to :action=>'index'
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end

  def cancel_edit
    @ciclo_productivo = CicloProductivo.find(params[:id])
    form_cancel_edit @ciclo_productivo
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.CicloProductivo.FormTitles.form_title')#'Ciclos Productivos'
    @form_title_record = I18n.t('Sistema.Body.Controladores.CicloProductivo.FormTitles.form_title_record')#'Ciclos'
    @form_title_records = I18n.t('Sistema.Body.Controladores.CicloProductivo.FormTitles.form_title_records')#'Ciclos'
    @form_entity = 'ciclo_productivo'
    @form_identity_field = 'nombre'
  end
  
end
