# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaDireccionController
# descripción: Migración a Rails 3
#
class Clientes::ClientePersonaDireccionController < FormTabTabsController
  
   skip_before_filter :set_charset, :only=>[:region_change, :estado_change, :municipio_change]

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
  
  def _list
    @persona = Persona.find(params[:persona_id])
    conditions = ["persona_direccion.persona_id = ?", @persona.id]
    params['sort'] = "persona_direccion.tipo" unless params['sort']
    
    
    @list = PersonaDireccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone   
  end

  def new
    @persona = Persona.find(params[:persona_id])    
    @persona_direccion = PersonaDireccion.new
    @comunidad_indigena_list = ComunidadIndigena.find(:all, :order=>'comunidad_indigena')
    @region_select = Region.find(:all, :order=>'nombre')
    @estado_select = []
    @municipio_select = []
    @parroquia_select = []
    @ciudad_select = []
  end
  
  def save_new
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.new(params[:persona_direccion])
    
    form_save_new @persona_direccion, 
      :value=>@persona.add_direccion(@persona_direccion),
      :params=> { :id=>@persona_direccion.id, :persona_id => @persona.id }
  end
  
  def edit
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:id])
    fill
  end
  
  def save_edit
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:id])    
    form_save_edit @persona_direccion, :params=> { :id=>@persona_direccion.id, :persona_id => @persona.id }
  end
  
  def delete
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:id])
    form_delete @persona_direccion
  end

  def view_detail
    @persona = Persona.find(params[:persona_id])
    @persona_direccion = PersonaDireccion.find(params[:id])
  end

  def region_change
    if params[:region_id].nil? || params[:region_id].to_s.empty?
      @estado_select = []
      @municipio_select = []
      @ciudad_select = []
      @parroquia_select = []
    else
      region_id = params[:region_id]
      estado_fill(region_id)
    end
    
    render :update do |page|
      page.replace_html 'estado-select', :partial => 'estado_select'.html_safe
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  def estado_change
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    ciudad_fill(estado_id)
    render :update do |page|    
      page.replace_html 'municipio-select', :partial => 'municipio_select'.html_safe
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'.html_safe
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end
  
  def municipio_change
    municipio_id = params[:municipio_id]
    parroquia_fill(municipio_id)
    render :update do |page|    
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'.html_safe
    end
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.ubicacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.ubicaciones')
    @form_entity = 'persona_direccion'
    @form_identity_field = 'tipo_nombre'
    @width_layout = '890'
  end

  private
  def fill
    @comunidad_indigena_list = ComunidadIndigena.find(:all, :order=>'comunidad_indigena')
    @region_select = Region.find(:all, :order=>'nombre')
    unless @persona_direccion.nil?
      if @persona_direccion.ciudad
        region_id = @persona_direccion.region_id
      else
        region_id = 0
      end
    else
      region_id = 0
    end
    estado_fill(region_id)
  end
  
  def estado_fill(region_id)
    @estado_select = Estado.find(:all, :conditions=>['region_id = ?', region_id], :order=>'nombre')
    if @persona_direccion && @persona_direccion.parroquia
      estado_id = @persona_direccion.ciudad.estado.id
    else
      estado_id = 0
    end
    ciudad_fill(estado_id)
    municipio_fill(estado_id)
  end
  
  def municipio_fill(estado_id)
    @municipio_select = Municipio.find(:all, :conditions=> "estado_id = #{estado_id}", :order=>'nombre')
    if @persona_direccion && @persona_direccion.parroquia
      municipio_id = @persona_direccion.parroquia.municipio_id
    else
      municipio_id = 0
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
    @persona = Persona.find(params[:persona_id])
    conditions = ["persona_direccion.persona_id = ?", @persona.id]
    params['sort'] = "persona_direccion.tipo" unless params['sort']
    
    @list = PersonaDireccion.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    @pages = @list.clone  

  end
end
