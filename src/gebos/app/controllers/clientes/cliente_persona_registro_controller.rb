# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaRegistroController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaRegistroController < FormTabTabsController
  
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
    @persona = Persona.find(params[:persona_id])
    @registro_mercantil = RegistroMercantil.new
    fill
  end
  
  def save_new
    @registro_mercantil = RegistroMercantil.new(params[:registro_mercantil])
    form_save_new @registro_mercantil,
      :value=>@registro_mercantil.create_new(params[:registro_mercantil],params[:persona_id], 'N'),
      :params=> { :id=>@registro_mercantil.id, :persona_id => @registro_mercantil.persona_id }
  end
  
  def edit
    @persona = Persona.find(params[:persona_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    fill
  end
  
  def save_edit
    @persona = Persona.find(params[:persona_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    form_save_edit @registro_mercantil,:value=>@registro_mercantil.edit_record(params[:registro_mercantil]),
      :params=> { :id=>@registro_mercantil.id, :persona_id => @persona.id }
  end
  
  def delete
    @persona = Persona.find(params[:persona_id])
    @registro_mercantil = RegistroMercantil.find(params[:id])
    form_delete @registro_mercantil
  end

  def view_detail
    @persona = Persona.find(params[:persona_id])
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
    @form_title ="#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.registro')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.registros')
    @form_entity = 'registro_mercantil'
    @form_identity_field = 'nombre_registro'
    @width_layout = '900'
  end

  private
  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["registro_mercantil.persona_id = ?", @persona.id]
    params['sort'] = "tipo" unless params['sort']
    
    @list = RegistroMercantil.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone 
  end

  def fill
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @registro_mercantil.estado_id.nil?
      estado_id = 0
    else
      estado_id = @registro_mercantil.estado_id
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
    @unidad_produccion_select = UnidadProduccion.find(:all, :conditions=>['cliente_id = ?', @persona.cliente_persona.id], :order=>'nombre')
    @tipo_documento_select = TipoDocumento.find(:all, :order=>'tipo')
    @tenencia_unidad_produccion_select = TenenciaUnidadProduccion.find(:all, :order=>'nombre')
  end

  def ciudad_fill(estado_id)
    if estado_id.blank?
      estado_id = 0
    end
    @ciudad_select = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
  end

  def municipio_fill(estado_id)
    if estado_id.blank?
      estado_id = 0
    end
    @municipio_select = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
  end

end
