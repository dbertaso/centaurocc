# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::DetallePrecioGacetaController
# descripción: Migración a Rails 3
#
class Basico::DetallePrecioGacetaController < FormTabTabsController
 
 
  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :tabs]
  
  def index
    @precio_gaceta = PrecioGaceta.find(params[:precio_gaceta_id])
    list
  end
  
  def list
    params['sort'] = "precio_gaceta.gaceta_oficial, detalle_precio_gaceta.actividad_id" unless params['sort']
    @condition = "precio_gaceta.id =#{params[:precio_gaceta_id]}"
    
    @list = DetallePrecioGaceta.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  def new
    @precio_gaceta = PrecioGaceta.find(params[:precio_gaceta_id])
    @detalle_precio_gaceta = DetallePrecioGaceta.new
    fill
  end
    
  def cancel_new
    form_cancel_new
  end

  def save_new
    @detalle_precio_gaceta = DetallePrecioGaceta.new(params[:detalle_precio_gaceta])
    @detalle_precio_gaceta.precio_gaceta_id = params[:precio_gaceta_id] 
    form_save_new @detalle_precio_gaceta
  end

  def delete
    @detalle_precio_gaceta = DetallePrecioGaceta.find(params[:id])
    nombre_compuesto = @detalle_precio_gaceta.nombre_compuesto.inspect
    result = @detalle_precio_gaceta.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @detalle_precio_gaceta, "#{nombre_compuesto}"
      end
    end
  end
  
  def edit
    @detalle_precio_gaceta = DetallePrecioGaceta.find(params[:id])
    @precio_gaceta = @detalle_precio_gaceta.precio_gaceta 
    fill
  end
   
  def save_edit
    @detalle_precio_gaceta = DetallePrecioGaceta.find(params[:id])
    form_save_edit @detalle_precio_gaceta
  end

  def cancel_edit
    @detalle_precio_gaceta = DetallePrecioGaceta.find(params[:id])
    form_cancel_edit @detalle_precio_gaceta
  end

  def view
    @precio_gaceta = PrecioGaceta.find(params[:precio_gaceta_id])
    list
  end
  
  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @detalle_precio_gaceta.id.nil?
      #@solicitud = Solicitud.new
      #@solicitud.sector_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro.sub_sector.sector_id
      sector_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro.sector_id
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      unless @detalle_precio_gaceta.nil?
        #@solicitud.sub_sector_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro.sub_sector_id
        sub_sector_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro.sub_sector_id
        rubro_fill(sub_sector_id)
      end
    else
      @sub_sector_list = []
      rubro_fill(0)
    end 
  end
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order=>'nombre')
      unless @detalle_precio_gaceta.nil?
        #@solicitud.rubro_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro_id
        rubro_id = @detalle_precio_gaceta.actividad.sub_rubro.rubro_id
        sub_rubro_fill(rubro_id)
      end
    else
      @rubro_list = []
      sub_rubro_fill(0)
    end
  end
  def sub_rubro_fill(rubro_id)
    if rubro_id > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order=>'nombre')
      unless @detalle_precio_gaceta.nil?
        #@solicitud.sub_rubro_id = @detalle_precio_gaceta.actividad.sub_rubro_id
        sub_rubro_id = @detalle_precio_gaceta.actividad.sub_rubro_id
        actividad_fill(sub_rubro_id)
      end
    else
      @sub_rubro_list = []
      actividad_fill(0)
    end
  end
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id > 0
      @actividad_list = Actividad.find(:all, :conditions=>['sub_rubro_id = ?', sub_rubro_id], :order=>'nombre')
    else
      @actividad_list = []
    end
  end

  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end
  def sub_sector_change
    @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{params[:sub_sector_id]}")
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end
  end
  def rubro_change
    @sub_rubro_list = SubRubro.find(:all, :conditions=>"rubro_id = #{params[:rubro_id]}")
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
    end
  end
  def sub_rubro_change
    @actividad_list = Actividad.find(:all, :conditions=>"sub_rubro_id = #{params[:sub_rubro_id]}")
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
   
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.DetallePrecioGaceta.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.DetallePrecioGaceta.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.DetallePrecioGaceta.FormTitles.form_title_records')
    @form_entity = 'detalle_precio_gaceta'
    @form_identity_field = 'nombre_compuesto'
    @width_layout = '850'
  end
  
end
