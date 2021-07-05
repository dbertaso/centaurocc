# encoding: utf-8

#
# autor: Luis Rojas
# clase: Prestamos::ReporteOtorgadosPorTrimestreController
# descripción: Migración a Rails 3

class Prestamos::ReporteOtorgadosPorTrimestreController < FormClassicController

skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change]

#include RjReport
 
  def index
    hoy = Time.now.strftime("%d/%m/%Y")
    @fecha_inicio = hoy
    @fecha_fin = hoy
    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(@sector_list[0].id)
  end
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
      page.show 'sub-sector-select'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
    end
  end
  
  def rubro_change
    #sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select', :locals=> {:rubro_id => params[:rubro_id]}
      page.show 'sub-rubro-select'
    end
  end

  def procesar_reporte

    logger.info " Clase Fecha Inicio #{params[:fecha_inicio].class.to_s}"
    logger.info " Clase Fecha Fin #{params[:fecha_fin].class.to_s}"

    @fecha_inicio = params[:fecha_inicio].to_s
    @fecha_fin = params[:fecha_fin].to_s

    if @fecha_inicio.blank?
      flash[:error] = "La fecha desde es requerida"
      fill_by_error
      render :action => "index"
      return
    end
    if @fecha_fin.blank?
      flash[:error] = "La fecha hasta es requerida"
      fill_by_error
      render :action => "index"
      return
    end
    
    if !fecha?(@fecha_inicio)
      flash[:error] = "La fecha desde no es valida"
      fill_by_error      
      render :action => "index"
      return    
    end
    
    if !fecha?(@fecha_fin)
      flash[:error] = "La fecha hasta no es valida"
      fill_by_error
      render :action => "index"
      return    
    end
    
    if conversionfecha(@fecha_fin) < conversionfecha(@fecha_inicio)
    
      flash[:error] = "La fecha hasta debe ser mayor a la fecha desde"
      render :action => "index"
      fill_by_error
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
    
    conditions = "fecha_aprobacion >= \'#{fecha_inicio}\' and fecha_aprobacion <= \'#{fecha_fin}\'"
       
    unless params[:sector_id][0].blank?
      conditions += " and sector_id = #{params[:sector_id][0]}"
    end
  
    unless params[:sub_sector_id][0].blank?
      conditions += " and sub_sector_id = #{params[:sub_sector_id][0]}"
    end

    unless params[:rubro_id][0].blank?
      conditions += " and rubro_id = #{params[:rubro_id][0]}"
    end

    sub_rubros_id = params[:sub_rubros_id]
    unless params[:sub_rubros_id].blank?
      p_subrubros = sub_rubros_id[0...(sub_rubros_id.length-1)]
      conditions += " and sub_rubro_id in (#{p_subrubros}) "
    end
    
    logger.info "sub_rubros =====> #{p_subrubros}"
    
    file_name = "financiamientos_otorgados_por_trimestre_del_#{fecha_inicio_rep}_al_#{fecha_fin_rep}.xls"
    nombre_archivo = ViewCreditosOtorgados.exportar_excel(conditions, file_name, fecha_inicio_rep1, fecha_fin_rep1)
    archivo_salida = 'otorgados_por_trimestre'

    flag = FileTest::exists?(nombre_archivo)
    
    if flag
      send_file nombre_archivo
    else
      flash[:error] = "No hay registros que satisfagan los par&aacute;metros solicitados por el usuario"
      hoy = Time.now.strftime("%d/%m/%Y")
      @fecha_inicio = hoy
      @fecha_fin = hoy
      @sector_list = Sector.find(:all, :order=>'nombre')
      sector_fill(@sector_list[0].id)
      render :action => "index"
      return
    end
        
    #@reporte = 'financiamientos_otorgados_por_trimestre'
    #parameters = {:p_fecha_inicio=> [@fecha_inicio, "date"], :p_fecha_fin=> [@fecha_fin, "date"], 
                  #:p_sector=>[params[:sector_id], "integer"], :p_sub_sector=>[params[:sub_sector_id], "integer"],
                  #:p_rubro=>[params[:rubro_id], "integer"], :p_sub_rubros=>[p_sub_rubros, "integer"]}
    #send_doc(@reporte, parameters, "prestamos", archivo_salida,"pdf")
    
  end 
  
  protected
  def common
    super
    @form_title = 'Reporte Financiamientos Otorgados Por Trimestre'
    @form_title_record = 'Parámetros' 
    @form_title_records = 'Parámetros'
   
  end
  
  def fecha?(valor, formato = "%d/%m/%Y")
  
    logger.info "Valor ======> #{valor}"

    Date.strptime(valor, formato)
    rescue ArgumentError
    false
  end
  
  def trimestre?(fecha_inicio, fecha_fin)
  
    fecha_tri_ini = fecha_inicio.split('/')
    fecha_tri_fin = fecha_fin.split('/')
    
    retorno = true
    unless fecha_tri_ini.length == 0
    

      mes = fecha_tri_ini[1].to_i

      
      logger.info "MES ========> #{mes.to_s}"
      logger.info "MES FIN ====> #{fecha_tri_fin[1].to_s}"
      logger.info "DIA FIN ====> #{fecha_tri_fin[0].to_s}"
           
      if mes == 1 
        if fecha_tri_fin[1].to_i != 3
         retorno = false
        end
        
        if fecha_tri_fin[0].to_i != 31
          retorno = false
        end
          
      end
      
      if mes == 4
        if fecha_tri_fin[1].to_i != 6
          retorno = false
        end
        
        if fecha_tri_fin[0].to_i != 30
          retorno = false
        end
        
      end
      
      if mes == 7
        if fecha_tri_fin[1].to_i != 9
          retorno = false
        end
        
        if fecha_tri_fin[1].to_i != 30
          retorno = false
        end
      end
      
      if mes == 10 
        if fecha_tri_fin[1].to_i != 12
          retorno = false
        end
        
        if fecha_tri_fin[0].to_i != 31
          retorno = false
        end
      end
    
    end
    
    retorno
    
  end
  
  def conversionfecha(valor, formato = "%d/%m/%Y")
  
    Date.strptime(valor, formato)
    
  end

  def fill_by_error

    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(@sector_list[0].id)  
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
  end
  

 end
