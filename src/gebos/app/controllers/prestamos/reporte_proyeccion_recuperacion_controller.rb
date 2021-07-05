# encoding: utf-8

#
# autor: Luis Rojas
# clase: Prestamos::ReporteProyeccionRecuperacionController
# descripción: Migración a Rails 3

class Prestamos::ReporteProyeccionRecuperacionController < FormClassicController

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
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page.show 'sub-sector-select'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def sub_rubro_change
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end
  
  
  def procesar_reporte
    @fecha_inicio = params[:fecha_inicio]
    @fecha_fin = params[:fecha_fin]

    if @fecha_inicio.blank?
      flash[:error] = "La fecha desde es requerida"
      render :action => "index"
      return
    end
    if @fecha_fin.blank?
      flash[:error] = "La fecha hasta es requerida"
      render :action => "index"
      return
    end
    
    if !fecha?(@fecha_inicio)
      flash[:error] = "La fecha desde no es valida"
      render :action => "index"
      return    
    end
    
    if !fecha?(@fecha_fin)
      flash[:error] = "La fecha hasta no es valida"
      render :action => "index"
      return    
    end
    
    if conversionfecha(@fecha_fin) < conversionfecha(@fecha_inicio)
    
      flash[:error] = "La fecha hasta debe ser mayor a la fecha desde"
      render :action => "index"
      return
    end
    
    #logger.info "sub_rubro_id Empty  #{params[:sub_rubro_id].empty?.to_s}"
    #logger.info "sub_rubro_id nil  #{params[:sub_rubro_id].nil?.to_s}"
    
    #if params[:sub_rubro_id].nil?
      #logger.info "Parametros  #{params[:sub_rubro_id].nil?.to_s}"
    #end
    
    fecha = params[:fecha_inicio].split("/")
    fecha_inicio = fecha[2] + "/" + fecha[1] + "/"  + fecha[0]
    fecha_inicio_rep = fecha[0] + "_" + fecha[1] + "_" + fecha[2]
    fecha_inicio_rep1 = fecha[0] + "/" + fecha[1] + "/" + fecha[2]
    fecha = ''
    fecha = params[:fecha_fin].split("/")
    fecha_fin = fecha[2] + "/" + fecha[1] + "/" + fecha[0]
    fecha_fin_rep = fecha[0] + "_" + fecha[1] + "_" + fecha[2]
    fecha_fin_rep1 = fecha[0] + "/" + fecha[1] + "/" + fecha[2]
    
    conditions = "fecha_cuota >= \'#{fecha_inicio}\' and fecha_cuota <= \'#{fecha_fin}\'"
    
    
    unless params[:programa_id][0].blank?
      conditions += " and programa_id = #{params[:programa_id][0]}"
    end
    
    unless params[:estado_id][0].blank?
      conditions += " and estado_id = #{params[:estado_id][0]}"
    end 
       
    unless params[:sector_id][0].blank?
      conditions += " and sector_id = #{params[:sector_id][0]}"
    end
  
    unless params[:sub_sector_id][0].blank?
      conditions += " and sub_sector_id = #{params[:sub_sector_id][0]}"
    end
    
    unless params[:rubro_id][0].blank?
      conditions += " and rubro_id = #{params[:rubro_id]}"
    end

    unless params[:sub_rubro_id].blank?
      conditions += " and sub_rubro_id = #{params[:sub_rubro_id]}"
    end

    unless params[:actividad_id].blank?
      conditions += " and actividad_id = #{params[:actividad_id]}"
    end

    logger.info "Conditions ==============> #{conditions}"
    logger.info "Fecha Inicio ==============> #{fecha_inicio_rep}"
    logger.info "Fecha Fin ==============> #{fecha_fin_rep}"
    file_name = "proyeccion_recuperacion_cartera_del_#{fecha_inicio_rep}_al_#{fecha_fin_rep}.xls"
    nombre_archivo = ViewRecuperacionCartera.exportar_excel(conditions, file_name, fecha_inicio_rep1, fecha_fin_rep1)
    #archivo_salida = @reporte.gsub("_","")
    #parameters = {:p_fecha_inicio=> [@fecha_inicio, "date"], :p_fecha_fin=> [@fecha_fin, "date"]}
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
    @form_title = 'Reporte Proyección Recuperación Cartera'
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
  
  def sub_rubro_fill(rubro_id)
    unless rubro_id.nil?
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', rubro_id], :order => 'nombre')
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

  
 end
