# encoding: UTF-8

#
# 
# clase: Clientes::ClientePersonaCuentasController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaCuentasController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:edit_validate]

  def index
    list
    persona = Persona.find(params[:persona_id])
    @count_cuenta = CuentaBancaria.count(:conditions=>['cliente_id = ?', persona.cliente_persona.id])
  end

  def list
    _list

    form_list

  end	
  
  def view
    list
  end
  
  def list_view
    _list
    form_list_view
  end

  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["cliente_id = ?", @persona.cliente_persona.id]
    params['sort'] = "tipo, numero" unless params['sort']
    
    @list = CuentaBancaria.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end

  def new
    @cuenta_bancaria = CuentaBancaria.new
    @persona = Persona.find(params[:persona_id])
    @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre')
    agencia(@entidad_financiera_select.first.id)
  end

  def edit_validate
    render :update do |page|
      page.redirect_to :action=>'edit', :id=>params[:id]
    end
  end

  def save_new
    @cuenta_bancaria = CuentaBancaria.new
    form_save_new @cuenta_bancaria, :value=>@cuenta_bancaria.create_new(params[:cuenta_bancaria],params[:persona_id],'P',session[:id])
  end

  def edit
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
    @persona = Persona.find(@cuenta_bancaria.cliente.persona_id)
    @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre')
    agencia(@cuenta_bancaria.entidad_financiera_id)
  end

  def save_edit

    #    if params[:historico_cambio_cuenta][:observaciones].strip == ""

    #      render :update do |page|
    #        page.alert 'Debe agregar una observación para proceder con la modificación'
    #      end

    #    else
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
    form_save_edit @cuenta_bancaria, :value=>@cuenta_bancaria.edit_record(params[:cuenta_bancaria],params[:historico_cambio_cuenta][:observaciones],session[:id],params[:id],params[:persona_id],'P',params[:historico_cambio_cuenta][:observaciones].to_s.strip)  
    #    end

  end

  def detalles_cambios_cuenta
    @width_layout = '1200'
    @form_title = "Relación de todas las modificaciones hechas a la cuenta"
    @todos_historico=HistoricoCambioCuenta.find(:all,:conditions=>"cuenta_id=#{params[:id]}",:order=>"fecha_modificacion_actual asc")

  end


  def entidad_change
    agencia(params[:entidad_financiera_id])
    render :update do |page|
      page.replace_html 'agencia-select', :partial => 'agencia_bancaria_select'
    end
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = "Cuentas Bancarias "
    @form_title_records = "Cuentas Bancarias "
    @form_entity = 'cuenta_bancaria'
    @form_identity_field = 'tipo_w'
    @width_layout = '890'
  end

  def agencia(entidad_financiera_id)
    @agencia_bancaria_select = AgenciaBancaria.find(:all, :conditions=>['entidad_financiera_id = ?', entidad_financiera_id], :order=>'nombre')
  end



end
