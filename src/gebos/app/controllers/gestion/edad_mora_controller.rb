# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Gestion::EdadMoraController
# descripción: Migración a Rails 3

require 'rubygems'

class Gestion::EdadMoraController < FormTabsController

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
    @sector_select = Sector.find(:all, :order=>'nombre',:conditions=>"activo=true")
    @region_select = Region.find_all_by_pais_id(1, :order=>'nombre')

    parametro = ParametroGeneral.find(1, :select=>"moneda_id")
    
    unless parametro.nil?
      moneda_id = parametro.moneda_id
    end
    
    @_30 = Prestamo.sum('monto_mora', :conditions=>"dias_mora<=30 and moneda_id = #{moneda_id}")
    @_60 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>30 and dias_mora <= 60 and moneda_id = #{moneda_id}")
      
    @_90 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>60 and dias_mora <= 90 and moneda_id = #{moneda_id}")
    @_180 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>90 and dias_mora <= 180 and moneda_id = #{moneda_id}")
    @_180plus = Prestamo.sum('monto_mora', :conditions=>"dias_mora > 180 and moneda_id = #{moneda_id}")

  end
  
  def agrupador_change

    #if !params[:agrupador].nil? && !params[:agrupador].empty?
     # @agrupador = params[:agrupador]
    _agrupadores = ''
    _agrupador=''

    unless params[:moneda_id][0].to_s == ""

      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and prestamo.moneda_id = #{params[:moneda_id][0]} "
       logger.debug "consulta 1 #{params[:moneda_id][0].to_s}" 
      _agrupador += "#{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.moneda')}" 
    end
    
    unless params[:region_id].to_s=="" 
      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and estado.region_id = #{params[:region_id].to_s} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.region')}"
    end

    unless params[:estado_id][0].to_s==""

      inner="INNER JOIN oficina ON solicitud.oficina_id = oficina.id INNER JOIN ciudad ON oficina.ciudad_id = ciudad.id INNER JOIN estado ON ciudad.estado_id = estado.id"
      _agrupadores += " and estado.id = #{params[:estado_id][0].to_s} "
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.estado')}" 
    end


    unless params[:sector_id].to_s==""
      _agrupadores += " and solicitud.sector_id = #{params[:sector_id].to_s} " 

      if params[:estado_id].to_s!="" || params[:region_id].to_s!=""
        _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sector')}"  
      else
        _agrupador += " #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sector')}"  
      end

    end

    unless params[:sub_sector_id][0].to_s==""
      _agrupadores += " and solicitud.sub_sector_id = #{params[:sub_sector_id][0].to_s} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sub_sector')}" 
    end

    unless params[:rubro_id][0].to_s==""
      _agrupadores += " and solicitud.rubro_id = #{params[:rubro_id][0].to_s} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.rubro')}" 
    end

    unless params[:sub_rubro_id][0].to_s==""
      _agrupadores += " and solicitud.sub_rubro_id = #{params[:sub_rubro_id][0].to_s} " 
      _agrupador += ", #{I18n.t('Sistema.Body.Controladores.IndicadorCartera.Agrupadores.sub_rubro')}" 
    end


    unless params[:actividad_id][0].to_s==""
      _agrupadores += " and solicitud.actividad_id = #{params[:actividad_id][0].to_s} " 
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



    #### consulta

  	@_30 = Prestamo.sum('monto_mora', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"dias_mora<=30 #{_agrupadores}")
  	  
  	@_60 = Prestamo.sum('monto_mora', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"dias_mora>30 and dias_mora<=60 #{_agrupadores}")
  	  
  	@_90 = Prestamo.sum('monto_mora', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"dias_mora>60 and dias_mora<=90 #{_agrupadores}")
  	  
  	@_180 = Prestamo.sum('monto_mora', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"dias_mora>90 and dias_mora<=180 #{_agrupadores}")
  	  
  	@_180plus = Prestamo.sum('monto_mora', 
  	  :joins => "INNER JOIN solicitud ON prestamo.solicitud_id = solicitud.id #{inner}",
  	  :conditions=>"dias_mora>180 #{_agrupadores}")


   
    @agrupadores.<<( { :agrupador=>_agrupador, 
      :_30=>@_30,
      :_60=>@_60,
      :_90=>@_90,
      :_180=>@_180,
      :_180plus=>@_180plus } )


    if _agrupador.to_s != ""
     render :update do |page|
          page.hide 'error'
          page.hide 'message'
          page.replace_html 'agrupadores', :partial => 'agrupadores', :locals=>{:agrupadores=>@agrupadores, :agrupador=>@agrupador }
        end
    else
      render :update do |page|
        page.hide 'error'
        page.hide 'message'
        page.replace_html 'agrupadores', ''
      end
    end

  end  

    def global_por_moneda(moneda_id)

    @_30 = 0.0
    @_60 = 0.0
    @_90 = 0.0
    @_180 = 0
    @_180plus = 0
    
    @_30 = Prestamo.sum('monto_mora', :conditions=>"dias_mora<=30 and moneda_id = #{moneda_id}")
    @_60 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>30 and dias_mora <= 60 and moneda_id = #{moneda_id}")
      
    @_90 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>60 and dias_mora <= 90 and moneda_id = #{moneda_id}")
    @_180 = Prestamo.sum('monto_mora', :conditions=>"dias_mora>90 and dias_mora <= 180 and moneda_id = #{moneda_id}")
    @_180plus = Prestamo.sum('monto_mora', :conditions=>"dias_mora > 180 and moneda_id = #{moneda_id}")

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

  protected  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EdadMora.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.EdadMora.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.EdadMora.FormTitles.form_title_records')
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

