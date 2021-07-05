# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EntidadFinancieraController
# descripción: Migración a Rails 3
#

class Basico::EntidadFinancieraController < FormTabsController

	def index
	end

  def list
    params['sort'] = "nombre" unless params['sort']
    @condition = "id > 0"
    unless params[:alias]==""
      @condition << " and UPPER(alias)  ILIKE'%#{params[:alias]}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_corto')} '#{params[:alias]}'"
    end
    unless params[:nombre]==""
      @condition << " and UPPER(nombre) ILIKE'%#{params[:nombre]}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
    unless params[:privado]==""
      @condition << " and privado = #{params[:privado]}"
      tipo=params[:privado]=="FALSE" ? "#{I18n.t('Sistema.Body.Vistas.General.publico')}" : "#{I18n.t('Sistema.Body.Vistas.General.privado')}" 
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.tipo_entidad_financiera_igual')} '#{tipo}'"
    end
    
	@list = EntidadFinanciera.search(@condition.to_s, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list
  end

	
  def new
    fill_cuenta_contable
    @entidad_financiera = EntidadFinanciera.new
    
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @entidad_financiera = EntidadFinanciera.new(params[:entidad_financiera])
    form_save_new @entidad_financiera
  end
  
  def delete
    @entidad_financiera = EntidadFinanciera.find(params[:id])
    form_delete @entidad_financiera
  end
  
  def edit
    fill_cuenta_contable
    @entidad_financiera = EntidadFinanciera.find(params[:id])
    
  end
  def save_edit
    @entidad_financiera = EntidadFinanciera.find(params[:id])
    form_save_edit @entidad_financiera
  end
  def cancel_edit
    @entidad_financiera = EntidadFinanciera.find(params[:id])
    form_cancel_edit @entidad_financiera
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EntidadFinanciera.FormTitles.form_title')#'Entidades Financieras'
    @form_title_record = I18n.t('Sistema.Body.Controladores.EntidadFinanciera.FormTitles.form_title_record')#'Entidad Financiera' 
    @form_title_records = I18n.t('Sistema.Body.Controladores.EntidadFinanciera.FormTitles.form_title_records')#'Entidades Financieras'
    @form_entity = 'entidad_financiera'
    @form_identity_field = 'alias'
  end
  def fill_cuenta_contable
    @cuenta_contable_select = CuentaContable.find(:all, :order=>'nombre')    
  end
end
