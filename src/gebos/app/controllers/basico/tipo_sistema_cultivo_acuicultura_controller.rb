# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoSistemaCultivoAcuiculturaController
# descripción: Migración a Rails 3
#
class Basico::TipoSistemaCultivoAcuiculturaController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    
    conditions=''
	@list = TipoSistemaAcuicultura.search(conditions, 
                            params[:page], 
                            params['sort'])
                            
    @total=@list.count    

    form_list

  end
	
  def new
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.new
		form_new @tipo_sistema_acuicultura
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.new(params[:tipo_sistema_acuicultura])
		form_save_new @tipo_sistema_acuicultura
  end
  
  def delete
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.find(params[:id])
		form_delete @tipo_sistema_acuicultura
  end
  
  def edit
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.find(params[:id])
		form_edit @tipo_sistema_acuicultura
  end

  def save_edit
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.find(params[:id])
		form_save_edit @tipo_sistema_acuicultura
  end

  def cancel_edit
    @tipo_sistema_acuicultura = TipoSistemaAcuicultura.find(params[:id])
		form_cancel_edit @tipo_sistema_acuicultura
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TipoSistemaAcuicultura.FormTitles.form_title')#'Sistemas de Cultivos (Acuicultura)'
    @form_title_record = I18n.t('Sistema.Body.Controladores.TipoSistemaAcuicultura.FormTitles.form_title_record')#'Sistema de Cultivo'
    @form_title_records = I18n.t('Sistema.Body.Controladores.TipoSistemaAcuicultura.FormTitles.form_title_records')#'Sistemas de Cultivos'
    @form_entity = 'tipo_sistema_acuicultura'
    @form_identity_field = 'nombre'
  end
end
