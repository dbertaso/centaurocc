# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::TipoGarantiaController
# descripción: Migración a Rails 3

class Basico::TipoGarantiaController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']
    condition = "tipo_garantia.id > 0"
    
    @list = TipoGarantia.search(condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @tipo_garantia = TipoGarantia.new
		form_new @tipo_garantia
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_garantia = TipoGarantia.new(params[:tipo_garantia])
    form_save_new @tipo_garantia
  end
  
  def delete
    #ALTER TABLE garantia_sector  DROP CONSTRAINT garantia_sector_tipo_garantia_id_fkey;
    
    @tipo_garantia = TipoGarantia.find(params[:id])
    result = @tipo_garantia.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @tipo_garantia, 'tipo_garantia'
      end
    end
#    @tipo_garantia = TipoGarantia.find(params[:id])
#    form_delete @tipo_garantia
  end
  
  def edit
    @tipo_garantia = TipoGarantia.find(params[:id])
     form_edit @tipo_garantia
  end
  def save_edit
    @tipo_garantia = TipoGarantia.find(params[:id])
    form_save_edit @tipo_garantia
  end
  def cancel_edit
    @tipo_garantia = TipoGarantia.find(params[:id])
    form_cancel_edit @tipo_garantia
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoGarantia.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoGarantia.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoGarantia.FormTitles.form_title_records')
    @form_entity = 'tipo_garantia'
    @form_identity_field = 'nombre'
  end
  
end
