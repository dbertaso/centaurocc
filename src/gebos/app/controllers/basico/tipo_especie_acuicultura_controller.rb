# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoEspecieAcuiculturaController
# descripción: Migración a Rails 3
#
class Basico::TipoEspecieAcuiculturaController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    
    conditions=''
	@list = TipoEspecieAcuicultura.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count    

    form_list

  end
	
  def new
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.new
		form_new @tipo_especie_acuicultura
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.new(params[:tipo_especie_acuicultura])
		form_save_new @tipo_especie_acuicultura
  end
  
  def delete
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.find(params[:id])
		form_delete @tipo_especie_acuicultura
  end
  
  def edit
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.find(params[:id])
		form_edit @tipo_especie_acuicultura
  end

  def save_edit
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.find(params[:id])
		form_save_edit @tipo_especie_acuicultura
  end

  def cancel_edit
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.find(params[:id])
		form_cancel_edit @tipo_especie_acuicultura
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoEspecieAcuicultura.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoEspecieAcuicultura.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoEspecieAcuicultura.FormTitles.form_title_records')
    @form_entity = 'tipo_especie_acuicultura'
    @form_identity_field = 'nombre'
  end
end
