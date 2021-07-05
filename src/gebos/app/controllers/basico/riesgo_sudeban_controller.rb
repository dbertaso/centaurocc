# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: Basico::RiesgoSudebanController
# descripción: Migración a Rails 3
#

class Basico::RiesgoSudebanController < FormAjaxController

  def index
   list
    
  end

  def riesgo_provision_sudeban

    @list = RiesgoSudeban.find(:all)

 end
	
  def list
   params['sort'] = "categoria" unless params['sort']


    @list = RiesgoSudeban.search( '', 
                                  params[:page], 
                                  params['sort'])
    @total=@list.count
    form_list
   

  end
  def new
    @riesgo_sudeban = RiesgoSudeban.new
    form_new @riesgo_sudeban
  end

  def save_new
    @riesgo_sudeban = RiesgoSudeban.new(params[:riesgo_sudeban])
    form_save_new @riesgo_sudeban
  end
  

  def cancel_new
		form_cancel_new
  end
  

  def delete
    @riesgo_sudeban = RiesgoSudeban.find(params[:id])
    form_delete @riesgo_sudeban
  end
  
  def edit
    @riesgo_sudeban = RiesgoSudeban.find(params[:id])
    form_edit @riesgo_sudeban
  end
  def save_edit
    @riesgo_sudeban = RiesgoSudeban.find(params[:id])
    form_save_edit @riesgo_sudeban
  end
  def cancel_edit
    @riesgo_sudeban = RiesgoSudeban.find(params[:id])
    form_cancel_edit @riesgo_sudeban
  end
  


  protected
  def common
 

   super
    @form_title =  I18n.t('Sistema.Body.Controladores.RiesgoSudeban.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.RiesgoSudeban.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.RiesgoSudeban.FormTitles.form_title_records')
    @form_entity = 'riesgo_sudeban'
    @form_identity_field = 'categoria'
  
  end
  
end
