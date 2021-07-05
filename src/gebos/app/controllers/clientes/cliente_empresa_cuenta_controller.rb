class Clientes::ClienteEmpresaCuentaController < FormTabTabsController

  def index
    list
    empresa = Empresa.find(params[:empresa_id])
    @count_cuenta = CuentaBancaria.count(:conditions=>['cliente_id = ?', empresa.cliente_empresa.id])
  end

  def list
    _list
    form_list
  end

  def new
    @empresa = Empresa.find(params[:empresa_id])
    @cuenta_bancaria = CuentaBancaria.new
    @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre')
    agencia(@entidad_financiera_select.first.id)
  end

  def edit_validate
       render :update do |page|
          new_options = {:action=>'edit', :id=>params[:id]}
          page.redirect_to new_options
        end
  end

  def save_new
    @cuenta_bancaria = CuentaBancaria.new
    form_save_new @cuenta_bancaria, :value=>@cuenta_bancaria.create_new(params[:cuenta_bancaria],params[:empresa_id],'E',session[:id])
  end

  def edit
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
    cliente = Cliente.find(@cuenta_bancaria.cliente_id)
    @empresa = Empresa.find(cliente.empresa_id)
    @entidad_financiera_select = EntidadFinanciera.find(:all, :order=>'nombre')
    agencia(@cuenta_bancaria.entidad_financiera_id)
  end

  def save_edit

logger.debug "campo tipo de cuenta " << params[:cuenta_bancaria][:tipo].to_s
#    if params[:historico_cambio_cuenta][:observaciones].strip == ""

#      render :update do |page|
#        page.alert 'Debe agregar una observación para proceder con la modificación'
#      end

#    else
    @cuenta_bancaria = CuentaBancaria.find(params[:id])

       form_save_edit @cuenta_bancaria, :value=>@cuenta_bancaria.edit_record(params[:cuenta_bancaria],params[:historico_cambio_cuenta][:observaciones],session[:id],params[:id],params[:empresa_id],'E',params[:historico_cambio_cuenta][:observaciones].to_s.strip) 

#    end



=begin
esto era lo que estaba anteriormente
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
    form_save_edit @cuenta_bancaria, :value=>@cuenta_bancaria.edit_record(params[:cuenta_bancaria])
=end

  end

  def entidad_change
    agencia(params[:entidad_financiera_id])
    render :update do |page|
      page.replace_html 'agencia-select', :partial => 'agencia_bancaria_select'
    end
  end
  
  def view
    list
  end
  
  def list_view
    _list
    form_list_view
  end
  
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["cliente_id = ?", @empresa.cliente_empresa.id]
    params['sort'] = "id desc"
    
    @list = CuentaBancaria.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone
  end

  protected  
  def common
    super
    @form_title = "Cuentas Bancarias del " + Etiquetas.etiqueta(9)
    @form_title_record = "Cuenta "
    @form_title_records = "Cuentas Bancarias del " + Etiquetas.etiqueta(9)
    @form_entity = 'cuenta_bancaria'
    @form_identity_field = 'numero'
    @width_layout = '890'
  end

  def agencia(entidad_financiera_id)
    @agencia_bancaria_select = AgenciaBancaria.find(:all, :conditions=>['entidad_financiera_id = ?', entidad_financiera_id], :order=>'nombre')
  end

end
