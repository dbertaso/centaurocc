# encoding: utf-8

#
# autor: Luis Rojas
# clase: Prestamos::ReportePidanController
# descripción: Migración a Rails 3

class Prestamos::ReportePidanController < FormClassicController

  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change]

 #include RjReport
 
  def index
    hoy = Time.now.strftime("%d/%m/%Y")
    @fecha_inicio = hoy
    @fecha_fin = hoy
    @estado_list = Estado.find(:all, :order=>'nombre')
    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(@sector_list[0].id)
    @programa_list=Programa.find(:all, :order=>'nombre')
  end
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'sub-sector-select'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.show 'sub_rubro-select'
    end
  end

  def procesar_reporte
    conditions=''
    parameters={}
    
    if params[:programa_id][0].blank?

      flash[:error] = "Debe seleccionar un Programa"
      fill_by_error
      render :action => "index"
      return    
    end    
    
    logger.info "PARAMETROS =======> #{params.inspect}"
    logger.info "PROGRAMA =======> #{params[:programa_id][0]}"
    logger.info "ESTADO =======> #{params[:estado_id]}"
    logger.info "SECTOR =======> #{params[:sector_id][0]}"
    logger.info "SUB SECTOR =======> #{params[:sub_sector_id][0]}"
    logger.info "RUBRO =======> #{params[:rubro_id][0]}"
    #logger.info "SUB RUBRO =======> #{params[:sub_rubro_id][0]}"

    if params[:programa_id][0] != ""
      @reporte = 'listado_pidan_programa'
      conditions += " programa_id = #{params[:programa_id][0]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"]}
    end
    
    if params[:estado_id][0] != '' 
      @reporte = 'listado_pidan_estado'
      conditions += " and estado_id = #{params[:estado_id]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"], :p_estado_id => [params[:estado_id], "integer"]}
    end 
       
    if params[:sector_id][0] != ""
    
      @reporte = 'listado_pidan_sector'
      conditions += " and sector_id = #{params[:sector_id][0]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"], :p_estado_id => [params[:estado_id], "integer"], :p_sector_id => [params[:sector_id][0], "integer"]}
   end
  
    if params[:sub_sector_id][0] != ""
      @reporte = 'listado_pidan_sub_sector'
      conditions +=  " and sub_sector_id = #{params[:sub_sector_id][0]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"], :p_estado_id => [params[:estado_id][0], "integer"], 
      :p_sector_id => [params[:sector_id][0], "integer"], :p_sub_sector_id => [params[:sub_sector_id][0], "integer"]}
    end

    if params[:rubro_id][0].to_s != ""
      @reporte = 'listado_pidan_rubro'
      conditions +=  " and rubro_id = #{params[:rubro_id][0]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"], :p_estado_id => [params[:estado_id], "integer"], 
      :p_sector_id => [params[:sector_id][0], "integer"], :p_sub_sector_id => [params[:sub_sector_id][0], "integer"],
      :p_rubro_id => [params[:rubro_id][0], "integer"]}
    end

    if params[:sub_rubro_id][0].to_s != ""
      @reporte = 'listado_pidan_sub_rubro'
      conditions += " and sub_rubro_id = #{params[:sub_rubro_id][0]}"
      parameters = {:p_programa_id => [params[:programa_id][0], "integer"], :p_estado_id => [params[:estado_id], "integer"], 
      :p_sector_id => [params[:sector_id][0], "integer"], :p_sub_sector_id => [params[:sub_sector_id][0], "integer"],
      :p_rubro_id => [params[:rubro_id][0], "integer"], :p_sub_rubro_id => [params[:sub_rubro_id][0], "integer"]}
    end

    logger.info "Parameters ==============> #{parameters.inspect}"
    logger.info "Conditions ==============> #{conditions}"
    file_name = "presupuesto_pidan_#{Time.now.strftime("%d-%m-%Y-%M:%s")}.xls"
    nombre_archivo = ViewPresupuestoPidan.exportar_excel(conditions, file_name)
    #archivo_salida = @reporte
    #send_doc(@reporte, parameters, "prestamos", archivo_salida,"pdf")
    
    flag = FileTest::exists?(nombre_archivo)
    
    if flag
      send_file nombre_archivo
    else
      flash[:error] = "No hay registros que satisfagan los par&aacute;metros solicitados por el usuario"
      @estado_list = Estado.find(:all, :order=>'nombre')
      @sector_list = Sector.find(:all, :order=>'nombre')
      sector_fill(@sector_list[0].id)
      @programa_list=Programa.find(:all, :order=>'nombre')
      render :action => "index"
      return
    end   
  end 
  
  protected
  def common
    super
    @form_title = 'Listado de Presupuesto'
    @form_title_record = 'Parámetros' 
    @form_title_records = 'Parámetros'
   
  end
  
  def fecha?(valor, formato = "%d/%m/%Y")
  
    Date.strptime(valor, formato)
    rescue ArgumentError
    false
  end
  
  def conversionfecha(valor, formato = "%d/%m/%Y")
  
    Date.strptime(valor, formato)
    
  end

  def sector_fill(sector_id)
    if sector_id > 0
      @sector_list = Sector.find(:all, :order=>'nombre')
    else
      @sector_list = []
    end
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order => "nombre")
    else
      @sub_sector_list = []
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order => "nombre")
    else
      @rubro_list = []
    end
    sub_rubro_fill(nil)
  end
  
  def sub_rubro_fill(id)
    unless id.nil?
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
    else
      @sub_rubro_list =[]
    end
    actividad(nil)
  end
  
  def actividad(id)
    unless id.nil?
      @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
    else
      @actividad_list =[]
    end
  end

  def fill_by_error
    @estado_list = Estado.find(:all, :order=>'nombre')
    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(@sector_list[0].id)
    @programa_list=Programa.find(:all, :order=>'nombre')
  end
  
 end
