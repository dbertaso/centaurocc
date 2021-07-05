# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaIntegrantePersonaDireccionController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaIntegrantePersonaDireccionController < FormTabTabsController

  before_filter :common_local, :except => [:estado_change, :municipio_change]
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
    @persona_direccion = PersonaDireccion.new   
    fill
  end
  
  def save_new
    @persona_direccion = PersonaDireccion.new(params[:persona_direccion])
    
    form_save_new @persona_direccion, 
      :value=>@persona.add_direccion(@persona_direccion),
      :params=> { :id=>@persona_direccion.id, :empresa_integrante_tipo_id => @empresa_integrante_tipo.id }
  end
  
  def edit
    @persona_direccion = PersonaDireccion.find(params[:id])
    fill
  end
  
  def save_edit
    @persona_direccion = PersonaDireccion.find(params[:id])
    form_save_edit @persona_direccion, :params=> { :id=>@persona_direccion.id, :empresa_integrante_tipo_id => @empresa_integrante_tipo.id }
  end
  
  def delete
    @persona_direccion = PersonaDireccion.find(params[:id])
    form_delete @persona_direccion
  end
  def view_detail
    @persona_direccion = PersonaDireccion.find(params[:id])
  end
  def estado_change
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    ciudad_fill(estado_id)
    render :update do |page|    
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  def municipio_change
    municipio_id = params[:municipio_id]
    parroquia_fill(municipio_id)
    render :update do |page|    
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  protected 
  def common_local
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:empresa_integrante_tipo_id])
    @empresa = @empresa_integrante_tipo.empresa_integrante.empresa
    @persona = @empresa_integrante_tipo.empresa_integrante.persona
  end
  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.ubicacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.ubicaciones')
    @form_entity = 'persona_direccion'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '800'
  end

  private
  def fill
    @estado_select = Estado.find_all_by_pais_id(1, :order=>'nombre')
    if @persona_direccion.ciudad
      estado_id = @persona_direccion.ciudad.estado_id
    else
      estado_id = @estado_select.first.id if @estado_select.first
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
  end
  
  def municipio_fill(estado_id)
    @municipio_select = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    if @persona_direccion && @persona_direccion.parroquia
      municipio_id = @persona_direccion.parroquia.municipio_id
    else
      municipio_id = @municipio_select.first.id if @municipio_select.first
    end
    parroquia_fill(municipio_id)
  end
  def ciudad_fill(estado_id)
    @ciudad_select = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
  end
  
  def parroquia_fill(municipio_id)
    @parroquia_select = Parroquia.find_all_by_municipio_id(municipio_id, :order=>'nombre')
  end

  def _list
    conditions = ["persona_direccion.persona_id = ?", @persona.id]
    params['sort'] = "persona_direccion.tipo" unless params['sort']    
    
    @list = PersonaDireccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
    
    @pages = @list.clone  
  end

end

