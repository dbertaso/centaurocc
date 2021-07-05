# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaRegistroController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaRegistroController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change]

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
    @empresa = Empresa.find(params[:empresa_id])    
    @registro_mercantil = RegistroMercantil.new
    fill
  end
  
  def save_new
    @registro_mercantil = RegistroMercantil.new(params[:registro_mercantil])
    form_save_new @registro_mercantil,
      :value=>@registro_mercantil.create_new(params[:registro_mercantil],params[:empresa_id], 'J'),
      :params=> { :id=>@registro_mercantil.id, :empresa_id => @registro_mercantil.empresa_id  }
  end
  
  def edit
    @empresa = Empresa.find(params[:empresa_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    fill
  end
  
  def save_edit
    @empresa = Empresa.find(params[:empresa_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    form_save_edit @registro_mercantil,:value=>@registro_mercantil.edit_record(params[:registro_mercantil]),
      :params=> { :id=>@registro_mercantil.id, :empresa_id => @empresa.id }
  end
  
  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    form_delete @registro_mercantil
  end

  def view_detail
    @empresa = Empresa.find(params[:empresa_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
  end

  def estado_change
    ciudad_fill(params[:estado_id])
    municipio_fill(params[:estado_id])
    render :update do |page|    
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
    end
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.registro')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.registros')
    @form_entity = 'registro_mercantil'
    @form_identity_field = 'nombre_registro'
    @width_layout = '900'
  end

  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["registro_mercantil.empresa_id = ?", @empresa.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = RegistroMercantil.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone 
  end

  def fill
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @registro_mercantil.estado_id.nil?
      estado_id = @estado_select.first.id
    else
      estado_id = @registro_mercantil.estado_id
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
    @unidad_produccion_select = UnidadProduccion.find(:all, :conditions=>['cliente_id = ?', @empresa.cliente_empresa.id], :order=>'nombre')
    @tipo_documento_select = TipoDocumento.find(:all, :order=>'tipo')
    @tenencia_unidad_produccion_select = TenenciaUnidadProduccion.find(:all, :order=>'nombre')
  end
  
  def ciudad_fill(estado_id)
    @ciudad_select = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
  end

   def municipio_fill(estado_id)
    @municipio_select = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
  end

end
