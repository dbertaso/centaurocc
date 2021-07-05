# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::LiquidacionMaquinariaEquipoController
# descripción: Migración a Rails 3
#

class Solicitudes::LiquidacionMaquinariaEquipoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change,:generar_tabla]
  
  def index
    @sub_sector_list=[]
    @rubro_list=[]
    @estado = Estado.find(:all,:order=>"nombre")
    @sector = Sector.find(:all,:conditions=>"id in (select sector_id from sub_sector where nemonico = 'MA')",:order=>"nombre")
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    parametros = ParametroGeneral.first
    @meneda_activa = parametros.moneda_id
  end

  def list

    params['sort'] = "numero_tramite" unless params['sort']

    @condition = "estatus_id = 10095"

    unless params[:solicitud_numero] == '' || params[:solicitud_numero].nil?
      @condition << " and numero_tramite =  #{params[:solicitud_numero]}"
      #@form_search_expression << "Número Trámite igual '#{params[:solicitud_numero]}'"
    end

    unless params[:cedula_rif] =='' ||  params[:cedula_rif].nil?
        @condition << " AND LOWER(documento_beneficiario) LIKE '%#{params[:cedula_rif].strip.downcase}%' "
      #@form_search_expression << "Cédula o RIF contenga '#{params[:cedula_rif]}'"
    end

    unless  params[:nombre_beneficiario] == '' || params[:nombre_beneficiario].nil?
        @condition << " AND LOWER(nombre_beneficiario) LIKE '%#{params[:nombre_beneficiario].strip.downcase}%'"
      #@form_search_expression << "Beneficiario semejante a '#{params[:nombre_beneficario]}'"
    end
    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''      
      @condition << " and sector_id = #{params[:sector_id][0]}"
      #@form_search_expression << "Sector es igual '#{sector.nombre}'"
      end
    end
    unless params[:sub_sector_id].nil?
      unless params[:sub_sector_id][0].to_s==''      
        @condition << " and sub_sector_id = #{params[:sub_sector_id][0]}"
      #@form_search_expression << "SubSector es igual '#{sub_sector.nombre}'"
      end
    end
    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''      
        @condition << " and rubro_id = #{params[:rubro_id][0]}"
        #@form_search_expression << "Rubro es igual '#{rubro.nombre}'"
      end
    end
    
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''      
        @condition << " and estado = #{params[:estado_id][0].to_s} "
        #@form_search_expression << "Estado es igual '#{estado.nombre}'"
      end
    end
    
    @condition << " and solicitud_id in (select id from solicitud where moneda_id = #{params[:moneda_id][0]})"
    
    @list = ViewLiquidacionMaquinariaEquipo.search(@condition, params[:page], params[:sort])
    @total=@list.count
    
    form_list
  end
  
  
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'      
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'      
    end
  end
    
  def sub_sector_fill(sector_id)
     if sector_id.to_s.length > 0
        @sub_sector_list = SubSector.find(:all, :conditions=>"sector_id = #{sector_id}", :order=>"nombre")
     else
        @sub_sector_list = SubSector.find(:all, :conditions=>"sector_id = 0")        
     end
     rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
     if sub_sector_id.to_s.length > 0
        @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{sub_sector_id}", :order=>"nombre")
     else
        @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = 0")
     end
  end
  
  def generar_tabla

    logger.info "Parametros =====> " << params.inspect

    ids = params[:prestamos_id]
    if ids.nil? || ids.empty?
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><li>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.no_se_puede_registrar_maquinaria')}</li></UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return false
    end

    errores = ""
    prestamo = Prestamo.find(:first)

    prestamos = Prestamo.find(:all, :conditions=>["id in (#{ids[0,ids.to_s.length - 1]})"])
    prestamos.each do |i|      
        errores << prestamo.validar_fecha_maquinaria(i,params["fecha_liquidacion_#{i.id}"])      
    end

    if errores.length > 0
       render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.html_safe << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
       end
       return false
    end

    id = prestamo.generar_tabla_maquinaria(params, session[:id])

    logger.info "IDS 1 =====> " << id.to_s
    if !id.empty?

      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        id.each {|i|
          page.remove "row_#{i}"
        }
        page.<< 'document.getElementById("prestamos_id").value = "";document.getElementById("prestamos_id").value = "";'
        page.replace_html 'message', I18n.t('Sistema.Body.General.tabla_amortizacion_se_ha_generado_con_exito')
        page.show 'message'
        page.<< "window.scrollTo(0,0);"
      end
    else
      render :update do |page|
      page.hide 'message'
      page.hide 'error'
      numeros = ''
      unless id.nil?
        id.each {|i|
          prestamo = prestamo.find(i.to_i)
          numeros += prestamo.numero.to_s + ' ' unless prestamo.nil?
        }
      end
        page.<< 'document.getElementById("prestamos_id").value = "";document.getElementById("prestamos_id").value = "";'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.Modelos.GeneracionTabla.Errores.error_en_generacion_tabla_amortizacion')}</h2><p><UL>".html_safe << numeros.html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.LiquidacionMaquinaria.Header.form_title') #'Liquidación de Maquinarias y Equipos'
    @form_title_record = I18n.t('Sistema.Body.Vistas.LiquidacionMaquinaria.Header.form_title_record') #'Liquidación de Maquinaria y Equipo'
    @form_title_records = I18n.t('Sistema.Body.Vistas.LiquidacionMaquinaria.Header.form_title') #'Liquidación de Maquinarias y Equipos'
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout=1100;
    @records_by_page = 1000        
  end
end
