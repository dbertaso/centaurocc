# encoding: utf-8

#
# autor: Luis Rojas
# clase: Maquinaria::GuiaMovilizacionMaquinariaController
# descripción: Migración a Rails 3
#
class Consultas::ConsultaInventarioController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:clase_search]

  layout 'form_basic'

  def index
    @tipo_maquinaria            = TipoMaquinaria.find(:all)
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
    @clase                      = []
    @marca = MarcaMaquinaria.find(:all, :conditions=>"activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
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
    
    @condition = "catalogo.id > 0 "
    params['sort'] = "contrato_maquinaria_equipo.nombre" unless params['sort']
    logger.debug "Parametros " << params.inspect.to_s
    unless params[:contrato_maquinaria_equipo_id][0].to_s==''
      contrato = ContratoMaquinariaEquipo.find(params[:contrato_maquinaria_equipo_id][0])
      @condition << " and catalogo.contrato_maquinaria_equipo_id = #{contrato.id} "
      @form_search_expression << "Contrato #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{contrato.nombre}'"
    end
    
    unless params[:tipo_maquinaria_id][0].to_s==''
      tipo_maquinaria = TipoMaquinaria.find(params[:tipo_maquinaria_id][0])
      @condition << " and catalogo.clase_id in (select id from clase where tipo_maquinaria_id = #{tipo_maquinaria.id}) "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{tipo_maquinaria.descripcion}'"
    end
    
    unless params[:clase_id][0].to_s==''
      clase = Clase.find(params[:clase_id][0])
      @condition << " and catalogo.clase_id = #{clase.id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{clase.nombre}'"
    end
    
    unless params[:marca_id][0].to_s==''
      marca = MarcaMaquinaria.find(params[:marca_id][0])
      @condition << " and catalogo.marca_maquinaria_id = #{marca.id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{marca.nombre}'"
    end
    
    unless params[:modelo_id][0].to_s==''
      modelo = Modelo.find(params[:modelo_id][0])
      @condition << " and catalogo.modelo_id = #{modelo.id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{modelo.nombre}'"
    end
    
    unless params[:serial][0].to_s==''
      @condition << " and lower(catalogo.serial) like '%#{params[:serial][0].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:serial][0].strip}'"
    end
    
    unless params[:chasis][0].to_s==''
      @condition << " and lower(catalogo.chasis) like '%#{params[:chasis][0].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:chasis][0].strip}'"
    end
    
    unless params[:numero_factura][0].to_s==''
      @condition << " and catalogo.numero_factura = '#{params[:numero_factura][0]}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero_factura][0]}'"
    end
    
    unless params[:estatus][0].to_s==''
      @condition << " and catalogo.estatus = '#{params[:estatus][0]}' "
      case params[:estatus][0]
      when 'L'
        estatus = I18n.t('Sistema.Body.Vistas.General.libre')
      when 'R'
        estatus = I18n.t('Sistema.Body.Vistas.General.reservado')
      when 'E'
        estatus = I18n.t('Sistema.Body.Vistas.General.entregado')
      end 
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.estatus_igual')} '#{estatus}'"
    end
    select = 'catalogo.*, tipo_maquinaria.nombre, tipo_maquinaria.id, contrato_maquinaria_equipo.nombre, contrato_maquinaria_equipo.id, modelo.nombre, modelo.id, marca_maquinaria.nombre, marca_maquinaria.id'
    join = " INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id INNER JOIN modelo ON modelo.id = catalogo.modelo_id INNER JOIN marca_maquinaria ON marca_maquinaria.id = catalogo.marca_maquinaria_id INNER JOIN contrato_maquinaria_equipo ON contrato_maquinaria_equipo.id = catalogo.contrato_maquinaria_equipo_id"
    @list = Catalogo.search_especial(@condition, params[:page], params[:sort],join, select)
    @total=@list.count
    
    form_list
  end
  
  def view
    @catalogo = Catalogo.find(params[:id])
  end
	
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.consulta')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.inventario')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.inventario')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.inventario')
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1200'
    @records_by_page     = 50
  end
  
end
