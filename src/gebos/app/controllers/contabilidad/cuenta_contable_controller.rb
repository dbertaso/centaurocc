# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::CuentaContableController
# descripción: Migración a Rails 3

class Contabilidad::CuentaContableController < FormTabsController

  def list

    params['sort'] = "codigo" unless params['sort']
    initial_conditions = "auxiliar = false"
    logger.info "CLASE DE PARAMS[:CODIGO] ======> " << params[:codigo].to_s
    

    unless params[:codigo].to_s == ''
      conditions = ["LOWER(codigo) = ?", "#{params[:codigo].strip.downcase}"]
      @form_search_expression << "#{t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormSearch.codigo_igual')} '#{params[:codigo]}'"
    else
      conditions = ["LOWER(codigo) > ?", "0"]
      @form_search_expression << "#{t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormSearch.codigo_contenga')} '#{params[:codigo]}'"
    end
    unless params[:nombre].nil?
      conditions = ["LOWER(nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "#{t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormSearch.nombre_contenga')} '#{params[:nombre]}'"
    end


    @list = CuentaContable.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def new
    @cuenta_contable = CuentaContable.new
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @cuenta_contable = CuentaContable.new(params[:cuenta_contable])
    form_save_new @cuenta_contable
  end
    def cancel_edit
    @cuenta_contable = CuentaContable.find(params[:id])
    form_cancel_edit @cuenta_contable
  end
  def delete
    @cuenta_contable = CuentaContable.find(params[:id])
    form_delete @cuenta_contable
  end
  
  def edit
    @cuenta_contable = CuentaContable.find(params[:id])
  end
  
  def view
    @cuenta_contable = CuentaContable.find(params[:id])
  end

  def save_edit
    logger.info "PARAMETROS ======> " << params.inspect
    
    codigo_anterior = params[:cuenta_contable1][:codigo_anterior]
    logger.info "CODIGO ANTERIOR =====> " << codigo_anterior.to_s
    asiento = AsientoContable.find_by_sql("select monto from asiento_contable where substr(codigo_contable,0,21) = '#{codigo_anterior}'")

    @cuenta_contable = CuentaContable.find(params[:id])
    
    #if asiento.size > 0
     
     #@cuenta_contable.errors.add("", "No puede modificarse cuenta contable esta siendo utilizada en comprobantes contables")
     
     #render :update do |page|
        #page.form_error
        #page.<< "window.scrollTo(0,0);"
     #end
     
     #return
    #end
    
    form_save_edit @cuenta_contable
    
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContable.FormTitles.form_title_records')
    @form_entity = 'cuenta_contable'
    @form_identity_field = 'nombre'
    @width_layout = 750
  end



end
