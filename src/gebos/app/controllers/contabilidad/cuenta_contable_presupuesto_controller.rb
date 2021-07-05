# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::CuentaContablePresupuestoController
# descripción: Migración a Rails 3

class Contabilidad::CuentaContablePresupuestoController < FormAjaxTabsController

  def index
    list
  end
  
  def list
    _list
    form_list
  end 
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end

  def new
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.new
    form_new @cuenta_contable_presupuesto
  end
  
  def cancel_edit
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.find(params[:id])
    form_cancel_edit @cuenta_contable_presupuesto
  end
  
  def save_new
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.new(:codigo=>params[:cuenta_contable_presupuesto][:codigo], :anio=>params[:cuenta_contable_presupuesto][:anio], :cuenta_contable_id=>@cuenta_contable.id.to_i)
    #logger.info "SQL ===================> #{@cuenta_contable_prestamo.new(:codigo=>params[:cuenta_contable_presupuesto][:codigo], :anio=>params[:cuenta_contable_presupuesto][:anio], :cuenta_contable_id=>@cuenta_contable.id.to_i).to_sql}"
    #@cuenta_contable_presupuesto.codigo = params[:cuenta_contable_presupuesto][:codigo].to_s
    #@cuenta_contable_presupuesto.anio = params[:cuenta_contable_presupuesto][:anio].to_i

    
      #logger.debug "ccacacacacaca " << params[:cuenta_contable_presupuesto][:anio].to_s

    #value = @cuenta_contable.valid?
    
    #begin
      #logger.debug "Value result desoues valid ==========> #{value.inspect}"
      #value=@cuenta_contable_presupuesto.save

      #logger.debug "Value result ==========> #{value.inspect}"

      #if value

        #flash[:notice] = "#{@form_title_record} '#{@cuenta_contable_presupuesto.codigo}' se agregó con éxito"
        #render :update do |page|
          #new_options = {:action=>'index', :cuenta_contable_id=>params[:cuenta_contable_id] }
          #page.redirect_to new_options
        #end
      #else
        #render :update do |page|
          #page.form_error
          #page.<< "window.scrollTo(0,0);"
        #end
      #end
      
    #rescue Exception => e
      #logger.info "Excepcion =======> #{e.inspect}"
    #end
    form_save_new @cuenta_contable_presupuesto
  end
  
  def edit
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.find(params[:id])
    form_edit @cuenta_contable_presupuesto  
  end
  
  def save_edit
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.find(params[:id])
    form_save_edit @cuenta_contable_presupuesto
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def delete
    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    @cuenta_contable_presupuesto = CuentaContablePresupuesto.find(params[:id])
    form_delete @cuenta_contable_presupuesto
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContablePresupuesto.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContablePresupuesto.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.CuentaContablePresupuesto.form_title_records')
    @form_entity = 'cuenta_contable_presupuesto'
    @form_identity_field = 'id'
  end

  private
  def _list

    @cuenta_contable = CuentaContable.find(params[:cuenta_contable_id])
    conditions = ["cuenta_contable_id = ?", @cuenta_contable.id]
    @params['sort'] = "codigo" unless @params['sort']

    @pages, @list = paginate(:cuenta_contable_presupuesto, :class_name => 'CuentaContablePresupuesto',
     :conditions => conditions,
     :per_page => @records_by_page,
     :select=>'cuenta_contable_presupuesto.*',
     :order_by => @params['sort'])
    @total=@pages.item_count

  end
end

