# encoding: utf-8

#
# autor: Luis Rojas
# clase: Maquinaria::GuiaMovilizacionMaquinariaController
# descripción: Migración a Rails 3
#
class Consultas::ConsultaStockController < FormTabsController
  
   skip_before_filter :set_charset, :only=>[:clase_search]

  layout 'form_basic'

  def index
    @tipo_maquinaria            = TipoMaquinaria.find(:all, :order => "nombre")
    @marca = MarcaMaquinaria.find(:all, :conditions=>"activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @clase                      = []
  end
  
  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
      render :update do |page|
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'clase-search'
      end
    else
      render :update do |page|
        @clase = []
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'clase-search'
      end
    end
  end

  def list
    
    conditions = "rubro_id > 0"
    params['sort'] = "rubro" unless params['sort']

    unless params[:consulta][:rubro_id].nil? || params[:consulta][:rubro_id].to_s.empty?
      rubro = TipoMaquinaria.find(params[:consulta][:rubro_id].to_i)
      conditions = "#{conditions} and rubro_id = #{rubro.id} "
      @form_search_expression << "Rubro es igual '#{rubro.descripcion}'"
    end
    
    unless params[:consulta][:tipo_id].nil? || params[:consulta][:tipo_id].to_s.empty?
      tipo = Clase.find(params[:consulta][:tipo_id])
      conditions = "#{conditions} and tipo_id = #{tipo.id} "
      @form_search_expression << "Tipo es igual '#{tipo.nombre}'"
    end
    
    unless params[:consulta][:marca_id].nil? || params[:consulta][:marca_id].to_s.empty?
      marca = MarcaMaquinaria.find(params[:consulta][:marca_id])
      conditions = "#{conditions} and marca_id = #{marca.id} "
      @form_search_expression << "Marca es igual '#{marca.nombre}'"
    end
    
    unless params[:consulta][:modelo_id].nil? || params[:consulta][:modelo_id].to_s.empty?
      modelo = Modelo.find(params[:consulta][:modelo_id])
      conditions = "#{conditions} and modelo_id = #{modelo.id} "
      @form_search_expression << "Modelo es igual '#{modelo.nombre}'"
    end
    
    @parametros = conditions
    
    @list = ViewStockMaquinaria.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end
  
  def reporte
    #@width_layout = 1500
    @reporte = ViewStockMaquinaria.find(:all, :conditions => params[:parametros], :order => "rubro")
    render  :layout => 'form_reporte'
  end
  
  def view
    @catalogo = Catalogo.find(params[:id])
  end
	
  protected
  def common
    super
    @form_title = 'Consulta de Existencia del Inventario'
    @form_title_record = 'Inventario'
    @form_title_records = 'Trámites'
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end
  
end
