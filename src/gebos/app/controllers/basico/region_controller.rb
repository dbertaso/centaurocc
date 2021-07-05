# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::RegionController
# descripción: Migración a Rails 3
#

class Basico::RegionController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "region.nombre" unless params['sort']

    
    conditions=''
	@list = Region.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list

  end
	
  def new
    @pais=Pais.find(:all,:order=>"nombre")
    @region = Region.new
		form_new @region
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @region = Region.new(params[:region])
    form_save_new @region
  end
  
  def delete
    @region = Region.find(params[:id])
    form_delete @region
  end
  
  def edit
    @pais=Pais.find(:all,:order=>"nombre")
    @region = Region.find(params[:id])    
    form_edit @region    
  end
  def save_edit
    @region = Region.find(params[:id])
    form_save_edit @region
  end
  def cancel_edit
    @region = Region.find(params[:id])
    form_cancel_edit @region
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Region.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Region.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Region.FormTitles.form_title_records')
    @form_entity = 'region'
    @form_identity_field = 'nombre'
  end
  
end
