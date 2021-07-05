
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Gestion::IndicadorCarteraController
# descripción: Migración a Rails 3
#

require 'rubygems'
#require 'gruff'

class Gestion::IndicadorCarteraController < FormTabsController

  skip_before_filter :set_charset, :only=>[:agrupador_change, :region_change, :rubro_change,
                                           :sector_change, :sub_rubro_change, :sub_sector_change, :moneda_change]
  layout 'form_basic'

  def index
    fill
    @estado_select=[]
    @sub_sector_select=[]
    @rubro_select=[]
    @sub_rubro_select=[]
    @actividad_select=[]
    @sector_select = Sector.where("activo=true").order('nombre')
    @region_select = Region.where("pais_id = 1").order('nombre')

    @vigente = 0.0
    @excedente = 0.0
    @vencido = 0.0
    @cant_vencido = 0
    @cant_vigente = 0
    
    parametro = ParametroGeneral.find(1, :select=>"moneda_id")
    
    unless parametro.nil?
      moneda_id = parametro.moneda_id
    end
  	@vigente_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='V' or estatus='H' and moneda_id = #{moneda_id}")
    @cant_vencido = Prestamo.count('prestamo.id',  :conditions=>"estatus='E' and moneda_id = #{moneda_id}" )
    @vigente_monto = Prestamo.sum('saldo_insoluto', :conditions=>"estatus='V' or estatus='H' and moneda_id = #{moneda_id}")
    @excedente = 0
    @vencido = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' and moneda_id = #{moneda_id}")

    #Diego Bertaso
    #Se agrego el status P a las condiciones que tomara en cuenta los prestamos
    #que estan en la gracia de la mora
   	@vencido_cantidad = Prestamo.count('prestamo.id', :conditions=>"(estatus='E') and dias_mora<=30 and moneda_id = #{moneda_id}")
   	@vencido_monto = Prestamo.sum('capital_vencido', :conditions=>"(estatus='E') and dias_mora<=30 and moneda_id = #{moneda_id}")
   	#---> fin modificacion
   	
   	@demorada_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='E' and dias_mora>30 and dias_mora < 90 and moneda_id = #{moneda_id}")
   	@demorada_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' and dias_mora>30 and dias_mora < 90 and moneda_id = #{moneda_id}")
    
    @vencido_90_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='E' and dias_mora >=90 and dias_mora < 180 and moneda_id = #{moneda_id}")
    @vencido_90_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' and dias_mora >=90 and dias_mora<180 and moneda_id = #{moneda_id}")
    
    @vencido_180_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='E' and dias_mora >= 180 and dias_mora < 365 and moneda_id = #{moneda_id}")
    @vencido_180_monto = Prestamo.sum('capital_vencido', :conditions=> "estatus ='E' and dias_mora >= 180 and dias_mora < 365 and moneda_id = #{moneda_id}")
    
    @vencido_365_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='E' and dias_mora >= 365 and moneda_id = #{moneda_id}")
    @vencido_365_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' and dias_mora>=365 and moneda_id = #{moneda_id}")
   	
   	@litigio_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus='L' and moneda_id = #{moneda_id}")
   	@litigio_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus='L' and moneda_id = #{moneda_id}")
   	
   	@reestructurado_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus<>'A' and estatus<>'F' and reestructurado = 'F' and moneda_id = #{moneda_id}")
   	@reestructurado_monto = Prestamo.sum('saldo_insoluto', :conditions=>"estatus<>'A' and estatus<>'F' and reestructurado = 'F' and moneda_id = #{moneda_id}")

  end
  
  def agrupador_change

    _agrupadores = ''

    _agrupador=''



    unless params[:moneda_id][0].to_s == ""

      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and prestamo.moneda_id = #{params[:moneda_id][0]} "
       logger.debug "consulta 1 #{params[:moneda_id][0].to_s}" 
      _agrupador += "#{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.moneda')}" 
    end

    unless params[:region_id].to_s == "" 
      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and estado.region_id = #{params[:region_id].to_s} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.region')}"
    end

    unless params[:estado_id][0].to_s == ""

      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and estado.id = #{params[:estado_id][0]} "
       logger.debug "consulta 1 #{params[:estado_id][0].to_s}" 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.estado')}" 
    end

    unless params[:sector_id].to_s == ""
      _agrupadores += " and solicitud.sector_id = #{params[:sector_id].to_s} " 

      if params[:estado_id].to_s != "" || params[:region_id].to_s != ""
        _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sector')}"  
      else
        _agrupador += " #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sector')}"  
      end

    end

    unless params[:sub_sector_id][0].to_s == ""
      _agrupadores += " and solicitud.sub_sector_id = #{params[:sub_sector_id][0]} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sub_sector')}" 
    end

    unless params[:rubro_id][0].to_s == ""
      _agrupadores += " and solicitud.rubro_id = #{params[:rubro_id][0]} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.rubro')}" 
    end


    unless params[:sub_rubro_id][0].to_s == ""
      _agrupadores += " and solicitud.sub_rubro_id = #{params[:sub_rubro_id][0]} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sub_rubro')}" 
    end


    unless params[:actividad_id][0].to_s == ""
      _agrupadores += " and solicitud.actividad_id = #{params[:actividad_id][0]} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.actividad')}" 
    end


    @agrupadores = []

    vigente = 0.0
    excedente = 0.0
    vencido = 0.0
    cant_vencido = 0
    cant_vigente = 0
    vigente_monto = 0.0
    vigente_cantidad = 0


    ### consulta

    #_agrupadores = _agrupadores.to_s
    #_agrupadores.gsub!(', ', '')
    logger.debug "consulta xxxx" << _agrupadores
    cantidad_vigente = Prestamo.count('prestamo.id', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"(prestamo.estatus='V' or prestamo.estatus = 'H') #{_agrupadores}")

    logger.debug "antes de " << cantidad_vigente.to_s

    cantidad_vigente = 0 if cantidad_vigente.to_s == ""

    logger.debug "despues de " << cantidad_vigente.to_s

    vigente = Prestamo.sum('saldo_insoluto', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"(prestamo.estatus='V' or prestamo.estatus = 'H') #{_agrupadores}")
    vigente = 0 unless !vigente.nil?
    excedente = 0 unless !excedente.nil?
    cant_vencido = Prestamo.count('prestamo.id', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"(prestamo.estatus = 'E') #{_agrupadores}")
    cant_vencido = 0 unless !cant_vencido.nil?
    vencido = Prestamo.sum('capital_vencido', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"(prestamo.estatus = 'E') #{_agrupadores}")
    vencido = 0 unless !vencido.nil?
                
   	vencido_cantidad = Prestamo.count('prestamo.id',
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"(prestamo.estatus='E') and dias_mora<=30 #{_agrupadores}")
   	vencido_monto = Prestamo.sum('capital_vencido', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"(prestamo.estatus='E') and dias_mora<=30 #{_agrupadores}")
   	
   	demorada_cantidad = Prestamo.count('prestamo.id', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
   	  :conditions=>"prestamo.estatus='E' and dias_mora>30 and dias_mora<90 #{_agrupadores}")
   	demorada_monto = Prestamo.sum('capital_vencido',
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
   	  :conditions=>"prestamo.estatus='E' and dias_mora>30 and dias_mora<90 #{_agrupadores}")
      
    demorada_90_cantidad = Prestamo.count('prestamo.id', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=90 and dias_mora<180 #{_agrupadores}")
    demorada_90_monto = Prestamo.sum('capital_vencido',
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=90 and dias_mora<180 #{_agrupadores}")
      
    demorada_180_cantidad = Prestamo.count('prestamo.id', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=180 and dias_mora<365 #{_agrupadores}")
    demorada_180_monto = Prestamo.sum('capital_vencido',
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=180 and dias_mora<365 #{_agrupadores}")
                
    demorada_365_cantidad = Prestamo.count('prestamo.id', 
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=365 #{_agrupadores}")
    demorada_365_monto = Prestamo.sum('capital_vencido',
      :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
      :conditions=>"prestamo.estatus='E' and dias_mora>=365 #{_agrupadores}")
             	
   	litigio_cantidad = Prestamo.count('prestamo.id',
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"prestamo.estatus='L' #{_agrupadores}")
   	litigio_monto = Prestamo.sum('capital_vencido',
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"prestamo.estatus='L' #{_agrupadores}")
             	
   	reestructurado_cantidad = Prestamo.count('prestamo.id', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
   	  :conditions=>"prestamo.estatus<>'A' and prestamo.estatus<>'F' and reestructurado = 'F' #{_agrupadores}")
   	reestructurado_monto = Prestamo.sum('saldo_insoluto',
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
   	  :conditions=>"prestamo.estatus<>'A' and prestamo.estatus<>'F' and reestructurado = 'F' #{_agrupadores}")


    @agrupadores.<<( { :agrupador=>_agrupador, 
      :vigente_cantidad=>cantidad_vigente,
      :vigente_monto=>vigente,
      :vencido_cantidad=>vencido_cantidad,
      :vencido_monto=>vencido_monto,
      :demorada_cantidad=>demorada_cantidad,
      :demorada_monto=>demorada_monto,
      :demorada_90_cantidad=>demorada_90_cantidad,
      :demorada_90_monto=>demorada_90_monto,
      :demorada_180_cantidad=>demorada_180_cantidad,
      :demorada_180_monto=>demorada_180_monto,
      :demorada_365_cantidad=>demorada_365_cantidad,
      :demorada_365_monto=>demorada_365_monto,
      :litigio_cantidad=>litigio_cantidad,
      :litigio_monto=>litigio_monto,
      :reestructurado_cantidad=>reestructurado_cantidad,
      :reestructurado_monto=>reestructurado_monto} )

      if _agrupador.to_s != ""
          render :update do |page|
            page.hide 'error'
            page.hide 'message'
            page.replace_html 'agrupadores', :partial => 'agrupadores', :locals=>{:meta=>@meta,:agrupadores=>@agrupadores, :agrupador=>@agrupador }
          end

      else
          render :update do |page|
            page.hide 'error'
            page.hide 'message'
            page.replace_html 'agrupadores', ''
          end

  end

end  

  
  def region_change
    region_id = params[:region_id]
    params[:region_id]=='' ? @estado_select =[] : @estado_select = Estado.where("region_id = ?", region_id).order('nombre')
    render :update do |page|    
      page.replace_html 'estado-select', :partial => 'estado_select'
      #page.replace_html 'municipio-select', :partial => 'municipio_select'
      #page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      #page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def global_por_moneda(moneda_id)

    @vigente = 0.0
    @excedente = 0.0
    @vencido = 0.0
    @cant_vencido = 0
    @cant_vigente = 0
    
  	@vigente_cantidad = Prestamo.count('prestamo.id', :conditions=>"(estatus='V' or estatus='H') and moneda_id = #{moneda_id}")
    @cant_vencido = Prestamo.count('prestamo.id',  :conditions=>"estatus='E' and moneda_id = #{moneda_id}")
    @vigente_monto = Prestamo.sum('saldo_insoluto', :conditions=>"(estatus='V' or estatus='H') and moneda_id = #{moneda_id}")
    @excedente = 0
    @vencido = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' and moneda_id = #{moneda_id}")

    #Diego Bertaso
    #Se agrego el status P a las condiciones que tomara en cuenta los prestamos
    #que estan en la gracia de la mora
   	@vencido_cantidad = Prestamo.count('prestamo.id', :conditions=>"(estatus = 'E') and dias_mora <= 30 and moneda_id = #{moneda_id}")
   	@vencido_monto = Prestamo.sum('capital_vencido', :conditions=>"(estatus = 'E') and dias_mora <= 30 and moneda_id = #{moneda_id}")
   	#---> fin modificacion
   	
   	@demorada_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus = 'E' and dias_mora > 30 and dias_mora < 90 and moneda_id = #{moneda_id}")
   	@demorada_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus = 'E' and dias_mora > 30 and dias_mora < 90 and moneda_id = #{moneda_id}")
    
    @vencido_90_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus = 'E' and dias_mora >= 90 and dias_mora < 180 and moneda_id = #{moneda_id}")
    @vencido_90_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus = 'E' and dias_mora >= 90 and dias_mora < 180 and moneda_id = #{moneda_id}")
    
    @vencido_180_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus = 'E' and dias_mora >= 180 and dias_mora < 365 and moneda_id = #{moneda_id}")
    @vencido_180_monto = Prestamo.sum('capital_vencido', :conditions=> "estatus ='E' and dias_mora >= 180 and dias_mora < 365 and moneda_id = #{moneda_id}")
    
    @vencido_365_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus = 'E' and dias_mora >= 365 and moneda_id = #{moneda_id}")
    @vencido_365_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus = 'E' and dias_mora >= 365 and moneda_id = #{moneda_id}")
   	
   	@litigio_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus = 'L' and moneda_id = #{moneda_id}")
   	@litigio_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus = 'L' and moneda_id = #{moneda_id}")
   	
   	@reestructurado_cantidad = Prestamo.count('prestamo.id', :conditions=>"estatus <> 'A' and estatus <> 'F' and reestructurado = 'F' and moneda_id = #{moneda_id}")
   	@reestructurado_monto = Prestamo.sum('saldo_insoluto', :conditions=>"estatus <> 'A' and estatus <> 'F' and reestructurado = 'F' and moneda_id = #{moneda_id}")

  end
  
  def moneda_change
  
    moneda_id = params[:moneda_id]
    
    global_por_moneda(moneda_id)
    
    render :update do |page|    
      page.replace_html 'meta_global', :partial => 'global'
      #page.replace_html 'municipio-select', :partial => 'municipio_select'
      #page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      #page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  def estado_change
    estado_id = params[:estado_id]
    #municipio_fill(estado_id)
    
    render :update do |page|    
      #page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      #page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end


  def sector_change
    sector_id = params[:sector_id]
    params[:sector_id]=='' ? @sub_sector_select =[] : sub_sector_fill(sector_id)
    @rubro_select=[]
    @sub_rubro_select=[]
    @actividad_select=[]
    render :update do |page|    
      page.replace_html 'sub_sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      #page.replace_html 'municipio-select', :partial => 'municipio_select'
      #page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      #page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  def sub_sector_change
    sub_sector_id = params[:sub_sector_id]
    #municipio_fill(estado_id)
    params[:sub_sector_id]=='' ? @rubro_select =[] : rubro_fill(sub_sector_id)
    
    @sub_rubro_select=[]
    @actividad_select=[]

    render :update do |page|    
      #page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      #page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def rubro_change
    rubro_id = params[:rubro_id]
    params[:rubro_id]=='' ? @sub_rubro_select =[] : sub_rubro_fill(rubro_id)
    @actividad_select=[]


    render :update do |page|    
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end

  
  def sub_rubro_change
    sub_rubro_id = params[:sub_rubro_id]
    params[:sub_rubro_id]=='' ? @actividad_select = [] : actividad_fill(sub_rubro_id)
    render :update do |page|    
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end


  def estado_fill(region_id)
    @estado_select = Estado.where("region_id = ?",region_id).order('nombre')
    #estado_id = @estado_select.first.id if @estado_select.first
    #ciudad_fill(estado_id)
    #municipio_fill(estado_id)
  end


  def sub_sector_fill(sector_id)
    @sub_sector_select = SubSector.where("sector_id = ?", sector_id).order('nombre')
    #estado_id = @estado_select.first.id if @estado_select.first
    #ciudad_fill(estado_id)
    #municipio_fill(estado_id)
  end

  def rubro_fill(sub_sector_id)
    @rubro_select = Rubro.where("sub_sector_id = ? ",sub_sector_id).order('nombre')
  end


  def sub_rubro_fill(rubro_id)
    
    @sub_rubro_select = SubRubro.where("rubro_id = ?",rubro_id).order('nombre')

    #municipio_id = @municipio_select.first.id if @municipio_select.first
    #parroquia_fill(municipio_id)
  end

  
  def actividad_fill(sub_rubro_id)
    @actividad_select = Actividad.where("sub_rubro_id = ?",sub_rubro_id).order('nombre')
  end



  protected  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.IndicadorCartera.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.IndicadorCartera.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.IndicadorCartera.FormTitles.form_title')
    @form_entity = ''
    @form_identity_field = ''
    @width_layout = 1200;
  end

  private

  def fill
    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
                        CASE
                            WHEN mon.id = par.moneda_id THEN 
                            '1'::text
                            ELSE '0'::text
                        END AS no_va
                  FROM moneda mon,parametro_general par 
                  where mon.activo=true order by no_va desc, nombre;"

    @moneda_list=Moneda.find_by_sql(sentencia)
  end

end

