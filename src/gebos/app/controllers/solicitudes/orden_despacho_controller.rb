# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoController
# descripción: Migración a Rails 3
#


class Solicitudes::OrdenDespachoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:oficina_change,:estado_change,:casa_proveedora_change,:sub_rubro_change,:rubro_change,:sector_change,:collapse,:expand_otra,:expand]

  layout 'form_basic'

  def index
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.operaciones')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.ordenes_despachos')}" #'Operaciones de Ordenes de Despacho'    
    fill()
  end




  def reimpresion
    fill()

    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id)
    @estado = Estado.find(@municipio.estado_id,:order=>"nombre")
    logger.info"XXXESTADO!!!================================>>>>" << session[:oficina].inspect
    @oficina_select=[]
    @cuenta_casa_proveedora =[]
    #@casa_proveedora_select = []
    @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and ciudad_id in (select id from ciudad where estado_id=#{@estado.id}) and tipo_cuenta <> '' order by nombre")
  end



  def expand
    @mis_ordenes=OrdenDespachoDetalle.find(:all ,:conditions=>"orden_despacho_id = #{params[:orden_id]}") 

    unless @mis_ordenes.empty?
    condi="("
        @mis_ordenes.each{ |orden_detalle|

          condi+=orden_detalle.id.to_s << "," 
        }
    condi=condi[0,condi.length-1]      
    condi+=")"   

      @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"orden_despacho_detalle_id in #{condi} and confirmada='f'")    
    else
      @facturas=[]           
    end    




		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.hide "row_#{params[:orden_id]}"
      page.insert_html :after, "row_#{params[:orden_id]}", :partial => 'detail' , :orden_id=>params[:orden_id]
  		page.visual_effect :highlight, "row_#{params[:orden_id]}_view", :duration => 0.6
    end


    #form_expand @orden
  end


##### otro expand

  def expand_otra
    @facturas=FacturaOrdenDespacho.find_all_by_orden_despacho_detalle_id(params[:orden_despacho_detalle_id])


		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.hide "row_#{params[:orden_id]}"
      page.insert_html :after, "row_#{params[:orden_id]}", :partial => 'detail_otra' , :orden_id=>params[:orden_id]
  		page.visual_effect :highlight, "row_#{params[:orden_id]}_view", :duration => 0.6
    end


    #form_expand @orden
  end


##### fin otro expand


  def collapse
    @mis_ordenes=OrdenDespachoDetalle.find(:all ,:conditions=>"orden_despacho_id = #{params[:orden_id]}") 

    unless @mis_ordenes.empty?
    condi="("
        @mis_ordenes.each{ |orden_detalle|

          condi+=orden_detalle.id.to_s << "," 
        }
    condi=condi[0,condi.length-1]      
    condi+=")"   

      @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"orden_despacho_detalle_id in #{condi} and confirmada='f'")    
    else
      @facturas=[]           
    end    

		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.remove "row_#{params[:orden_id]}_view"
      page.show "row_#{params[:orden_id]}"
  		page.visual_effect :highlight, "row_#{params[:orden_id]}", :duration => 0.6
    end

  end


  
 
  def list
    #@orden_despacho = ViewListOrdenDespacho.find(:all)
    identificador_estado=Oficina.find(Usuario.find(session[:id]).oficina_id).ciudad.estado_id
identificador_oficina=Usuario.find(session[:id]).oficina_id

    moneda_id = ParametroGeneral.first.moneda_id
    @condition ="moneda_id = #{moneda_id} and solicitud_id > 0 and oficina_id = #{identificador_oficina}"
    params['sort'] = "numero" unless params['sort']

    # busqueda por sector
    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''      
        @condition << " and (sector_id = #{params[:sector_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(params[:sector_id][0]).nombre}'"
      end
    end

    # busqueda por rubro
    unless params[:rubro_id].nil? 
      unless params[:rubro_id][0].to_s==''      
        @condition << " and (rubro_id = #{params[:rubro_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(params[:rubro_id][0]).nombre}'"
      end
    end

 # busqueda por Sub rubro
    unless params[:sub_rubro_id].nil? 
      unless params[:sub_rubro_id][0].to_s==''      
        @condition << " and (sub_rubro_id = #{params[:sub_rubro_id][0]})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(params[:sub_rubro_id][0]).nombre}'"
      end
    end

 # busqueda por actividad
    unless params[:actividad_id].nil? 
      unless params[:actividad_id][0].to_s==''      
        actividad_id = params[:actividad_id][0].to_s
        actividad = Actividad.find(actividad_id)
        @condition << " and (actividad_id = #{actividad_id})"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
      end
    end


    # busqueda por estatus orden de despacho nuevo filtro al 24/05/2013
    unless params[:estatus_orden_id].nil? 
      unless params[:estatus_orden_id][0].to_s==''      
        estatus_id = params[:estatus_orden_id][0].to_s
        orden = OrdenDespacho.find_all_by_estatus_id(estatus_id)
        estatus_nombre=Estatus.find(estatus_id).nombre      
        
        unless orden.empty?
          condi="("
          orden.each{ |ordene|
            condi+=ordene.id.to_s << ","
            }
          condi=condi[0,condi.length-1]
          condi+=")"     
          @condition << " and (orden_despacho_id in #{condi})"
        else
          @condition << " and (orden_despacho_id = 0)"
        end
          
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_od_igual')} '#{estatus_nombre}'"
      end
    
    end


    # busqueda por numero de tramite
    unless params[:numero].to_s.nil? || params[:numero].to_s.empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
      logger.info "XXXXXXXXXXXX==============>>>>>>>" << @form_search_expression.inspect
    end
 # busqueda por numero de financiamiento
    unless params[:nro_financiamiento].to_s.nil? || params[:nro_financiamiento].to_s.empty?
      @condition << " AND numero =  #{params[:nro_financiamiento].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_prestamo_igual')} '#{params[:nro_financiamiento]}'"
    end

    # busqueda por cedula
    unless params[:identificacion].to_s.nil? ||  params[:identificacion].to_s.empty?
      @condition << " AND (cedula_rif) = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:tipo].to_s}#{params[:identificacion]}'"
    end    
  
    unless params[:nombre].to_s.nil? || params[:nombre].to_s.empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end   
   
    
    logger.info "XXXX===================>>>>>>>>" << @condition.to_s
    
    @list = ViewListOrdenDespacho.search(@condition, params[:page], params['sort'])    
    @total=@list.count    

    form_list
  end


# list especial para el proceso de reimpresion y consulta
  def list_especial

    @orden_despacho = ViewListOrdenDespacho.find(:all)
    identificador_estado=Oficina.find(Usuario.find(session[:id]).oficina_id).ciudad.estado_id
identificador_oficina=Usuario.find(session[:id]).oficina_id

    @condition ="solicitud_id > 0 and oficina_id = #{identificador_oficina}"
    params['sort'] = "numero" unless params['sort']

    # busqueda por sector
    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''            
      @condition << " and (sector_id = #{params[:sector_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.descripcion}'"
      end
    end

    # busqueda por rubro
    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''                  
      @condition << " and (rubro_id = #{params[:rubro_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.descripcion}'"
      end
    end



 # busqueda por Sub rubro
    unless params[:sub_rubro_id].nil? 
      unless params[:sub_rubro_id][0].to_s==''                        
      @condition << " and (sub_rubro_id = #{params[:sub_rubro_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{subrubro.nombre}'"
      end
    end

 # busqueda por actividad
    unless params[:actividad_id].nil?
        unless params[:actividad_id][0].to_s==''                            
          @condition << " and (actividad_id = #{params[:actividad_id][0]})"
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
        end
    end


    # busqueda por numero de tramite
    unless params[:numero].to_s.nil? || params[:numero].to_s.empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
      logger.info "XXXXXXXXXXXX==============>>>>>>>" << @form_search_expression.inspect
    end
 # busqueda por numero de financiamiento
    unless params[:nro_financiamiento].to_s.nil? || params[:nro_financiamiento].to_s.empty?
      @condition << " AND numero =  #{params[:nro_financiamiento].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_prestamo_igual')} '#{params[:nro_financiamiento]}'"
    end
    # busqueda por cedula
    unless params[:identificacion].to_s.nil? ||  params[:identificacion].to_s.empty?
      @condition << " AND (cedula_rif) = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:identificacion]}'"
    end

    # busqueda por nombre o apellido
    unless params[:orden_despacho].to_s.nil? || params[:orden_despacho].to_s.empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:orden_despacho].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:orden_despacho]}'"
    end
  
    unless params[:nombre].to_s.nil? || params[:nombre].to_s.empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end
   

    
    @list = ViewListOrdenDespacho.search(@condition, params[:page], params['sort'])    
    @total=@list.count
    form_list
  end



  def sector_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    unless params[:id].to_s ==''
      @rubro_list = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{params[:id]}", :order=>"nombre")
      @sub_rubro_list =[]
      @actividad_list = []
    else
      @rubro_list =[]
      @sub_rubro_list =[]
      @actividad_list = []
    end    
    
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      
    end
  end

  def rubro_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    if params[:id]!=""
      @sub_rubro_list = SubRubro.find(:all, :conditions=>"activo=true and rubro_id = #{params[:id]}", :order=>"nombre")
      @actividad_list = []
    else
      @sub_rubro_list =[]
      @actividad_list = []
    end
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end



  def sub_rubro_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    if params[:id]!=""
    @actividad_list = Actividad.find(:all, :conditions=>"activo=true and sub_rubro_id = #{params[:id]}", :order=>"nombre")
    else
    @actividad_list = []
    end  
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end



    
  def casa_proveedora_change

    @cuenta_casa_proveedora = CasaProveedora.find(:all, :conditions=>"activo=true and id = #{params[:id]}", :order=> "numero_cuenta")

    render :update do |page|
      page.replace_html 'cuenta-casa-proveedora-select', :partial => 'cuenta_casa_proveedora_select'      
      page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'banco_cuenta_casa_proveedora_select'  

    end
  end


def estado_change

    @oficina_select = Oficina.find_by_sql("select * from oficina where ciudad_id in (select id from ciudad where estado_id=#{params[:id]} ) ")

    render :update do |page|
      page.replace_html 'oficina-select', :partial => 'oficina_select'      
    end
  end


  def oficina_change

    @estado_aux = Estado.find_by_sql("select estado_id from ciudad where id in (select ciudad_id from oficina where id=#{params[:id]} ) ")

    @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and ciudad_id in (select id from ciudad where estado_id=#{@estado_aux[0].estado_id}) and tipo_cuenta <> '' order by nombre")

    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select'      
    end
  end


  def edit
    @orden_despacho = ViewListOrdenDespacho.find_by_solicitud_id(params[:orden_despacho_id])
    @casa_proveedora = CasaProveedora.find(:all,:conditions=>"activo=true",:order=>"nombre")
    logger.info "XXXXX:::=========================>>>>>>"
    @sucursal= SucursalCasaProveedora.find(:all,:order=>"nombre")
  end
  protected

  def fill
    @estado = Estado.find(:all, :order=>'nombre')
    @sector = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    @estatus_list = Estatus.find(:all,:conditions=>"id >=20000 and id <30000", :order=>'nombre')
    @rubro_list = []
    @sub_rubro_list = []
    @actividad_list = []
  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho') #'Orden de Despacho'
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho') #'Orden de Despacho'
    @form_title_records = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.ordenes_despachos') #'Ordenes de Despachos'
    @form_entity = 'orden_despacho'
    @form_identity_field = 'id'
    @width_layout = '1180'
  end
end
