# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoArtePescaController
# descripción: Migración a Rails 3
#
class Basico::TipoArtePescaController < FormAjaxController

  def index
    list
  end

  def list
    
    params['sort'] = "grupo" unless params['sort']

    
    conditions=''
	@list = TipoArtePesca.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    
    form_list
  end

  def new
    @tipo_arte_pesca = TipoArtePesca.new
    @grupo=TipoArtePesca.find(:all,:select=>"distinct(grupo)",:order=>"grupo",:group=>"grupo")
    form_new @tipo_arte_pesca
  end

  def save_new
    @tipo_arte_pesca = TipoArtePesca.new(params[:tipo_arte_pesca])
    form_save_new @tipo_arte_pesca
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @tipo_arte_pesca = TipoArtePesca.find(params[:id])
    form_delete @tipo_arte_pesca
  end
  
  def edit
    @tipo_arte_pesca = TipoArtePesca.find(params[:id])
    @grupo=TipoArtePesca.find(:all,:select=>"distinct(grupo)",:order=>"grupo",:group=>"grupo")
    form_edit @tipo_arte_pesca
  end

  def save_edit
    @tipo_arte_pesca = TipoArtePesca.find(params[:id])
    form_save_edit @tipo_arte_pesca
  end

  def cancel_edit
    @tipo_arte_pesca = TipoArtePesca.find(params[:id])
    form_cancel_edit @tipo_arte_pesca
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoArtePesca.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoArtePesca.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoArtePesca.FormTitles.form_title_records')
    @form_entity = 'tipo_arte_pesca'
    @form_identity_field = 'grupo'
  end
  
end
