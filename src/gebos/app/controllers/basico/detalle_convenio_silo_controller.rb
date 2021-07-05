# encoding: utf-8
class Basico::DetalleConvenioSiloController < FormTabTabsController
	
  skip_before_filter :set_charset, :only=>[:tabs, :sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change]
  
	def index
    @silo = Silo.find(params[:silo_id])
	  @convenio_silo = ConvenioSilo.find(params[:convenio_silo_id])
	  list
  end
  
  def list
    params['sort'] = "convenio_silo.numero_memorandum, detalle_convenio_silo.actividad_id" unless params['sort']
    @condition = "convenio_silo_id =#{params[:convenio_silo_id]}"
    
    @list = DetalleConvenioSilo.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list
  end
	
  def new
    @convenio_silo = ConvenioSilo.find(params[:convenio_silo_id])
    @silo = @convenio_silo.silo
    @detalle_convenio_silo = DetalleConvenioSilo.new
    fill
  end
    
  def cancel_new
		form_cancel_new
  end

  def save_new
    @detalle_convenio_silo = DetalleConvenioSilo.new(params[:detalle_convenio_silo])
    @detalle_convenio_silo.convenio_silo_id = params[:convenio_silo_id]
    @detalle_convenio_silo.usuario_id = session[:id]
		form_save_new @detalle_convenio_silo
  end

  def delete
    @detalle_convenio_silo = DetalleConvenioSilo.find(params[:id])
    nombre_compuesto = @detalle_convenio_silo.nombre_compuesto.inspect
    result = @detalle_convenio_silo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @detalle_convenio_silo, "#{nombre_compuesto}"
      end
    end
  end
  
  def edit
    @detalle_convenio_silo = DetalleConvenioSilo.find(params[:id])
    @convenio_silo = @detalle_convenio_silo.convenio_silo
    @silo = @convenio_silo.silo
    fill
  end
   
  def save_edit
    @detalle_convenio_silo = DetalleConvenioSilo.find(params[:id])
    form_save_edit @detalle_convenio_silo
  end

  def cancel_edit
    @detalle_convenio_silo = DetalleConvenioSilo.find(params[:id])
		form_cancel_edit @detalle_convenio_silo
  end

  def view
    @convenio_silo = ConvenioSilo.find(params[:convenio_silo_id])
    @silo = @convenio_silo.silo
    list
  end
  
  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @detalle_convenio_silo.id.nil?
      @solicitud = Solicitud.new
      @solicitud.sector_id = @detalle_convenio_silo.actividad.sub_rubro.rubro.sub_sector.sector_id
      sector_id = @detalle_convenio_silo.actividad.sub_rubro.rubro.sector_id
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      unless @detalle_convenio_silo.nil?
        @solicitud.sub_sector_id = @detalle_convenio_silo.actividad.sub_rubro.rubro.sub_sector_id
        sub_sector_id = @detalle_convenio_silo.actividad.sub_rubro.rubro.sub_sector_id
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
      unless @detalle_convenio_silo.nil?
        @solicitud.rubro_id = @detalle_convenio_silo.actividad.sub_rubro.rubro_id
        rubro_id = @detalle_convenio_silo.actividad.sub_rubro.rubro_id
        case
          when @detalle_convenio_silo.actividad.sub_rubro.rubro.nombre.downcase.match('arroz').to_s.length > 0
            @tcg = 'A'
          when @detalle_convenio_silo.actividad.sub_rubro.rubro.nombre.downcase.match('algodon').to_s.length > 0
            @tcg = 'B'
          else
            @tcg = 'C'
        end
        sub_rubro_fill(rubro_id)
      end
    else
      @rubro_list = []
      @tcg = nil
      sub_rubro_fill(0)
    end
  end
  def sub_rubro_fill(rubro_id)
    if rubro_id > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order=>'nombre')
      unless @detalle_convenio_silo.nil?
        @solicitud.sub_rubro_id = @detalle_convenio_silo.actividad.sub_rubro_id
        sub_rubro_id = @detalle_convenio_silo.actividad.sub_rubro_id
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
    case
      when params[:txt].downcase.match('arroz').to_s.length > 0
        @tcg = 'A'
      when params[:txt].downcase.match('algodon').to_s.length > 0
        @tcg = 'B'
      else
        @tcg = 'C'
    end
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 't-gc', :partial => 'tipo_clase_grado'
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
    @form_title = 'Precios de Convenio'
    @form_title_record = 'Precio Convenio'
    @form_title_records = 'Precios de Convenio'
    @form_entity = 'detalle_convenio_silo'
    @form_identity_field = 'nombre_compuesto'
    @width_layout = '850'
  end
  
end
