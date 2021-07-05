# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoConsultaController
# descripción: Migración a Rails 3
#



class Solicitudes::OrdenDespachoConsultaController < FormTabsController

  layout 'form_basic'
  
  skip_before_filter :set_charset, :only=>[:sector_change,:rubro_change,:sub_rubro_change,:casa_proveedora_change,:estado_change,:collapse,:expand,:casa_change]

  def index
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.consultar_pago_casa_proveedora')
    fill()
  end



  def list 
    
    identificador_estado=Oficina.find(Usuario.find(session[:id]).oficina_id).ciudad.estado_id
    identificador_oficina=Usuario.find(session[:id]).oficina_id
    join=""

    moneda_id = ParametroGeneral.first.moneda_id
    @condition ="view_list_orden_despacho.moneda_id = #{moneda_id} and view_list_orden_despacho.solicitud_id > 0 and view_list_orden_despacho.oficina_id = #{identificador_oficina}"
    params['sort'] = "numero" unless params['sort']

    # busqueda por sector
    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''
      @condition << " and (view_list_orden_despacho.sector_id = #{params[:sector_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(params[:sector_id][0]).nombre}'"
      end
    end

    # busqueda por rubro
    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''      
      @condition << " and (view_list_orden_despacho.rubro_id = #{params[:rubro_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(params[:rubro_id][0]).nombre}'"
      end
    end

    # busqueda por Sub rubro
    unless params[:sub_rubro_id].nil?
      unless params[:sub_rubro_id][0].to_s==''            
      @condition << " and (view_list_orden_despacho.sub_rubro_id = #{params[:sub_rubro_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(params[:sub_rubro_id][0]).nombre}'"
      end
    end

    # busqueda por actividad
    unless params[:actividad_id].nil?
    
      unless params[:actividad_id][0].to_s==''                  
      @condition << " and (view_list_orden_despacho.actividad_id = #{params[:actividad_id][0]})"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(params[:actividad_id][0]).nombre}'"
      end
    end
    
    # busqueda por numero de tramite
    
    unless params[:numero].to_s.nil? || params[:numero].to_s.empty?
      @condition << " AND view_list_orden_despacho.numero =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"      
    end
 
    # busqueda por cedula
    unless params[:identificacion].to_s.nil? ||  params[:identificacion].to_s.empty?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:tipo].to_s}#{params[:identificacion]}'"
    end

    # busqueda por nombre o apellido
    unless params[:nombre].to_s.nil? || params[:nombre].to_s.empty?
      @condition << " AND UPPER(view_list_orden_despacho.nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
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

    # busqueda por casa proveedora
    
    unless params[:casa_proveedora_id].nil?
      unless params[:casa_proveedora_id][0].to_s==''            
      orden = OrdenDespacho.find(:all,:select=>"distinct (id)",:conditions=>"id in (select orden_despacho_id from orden_despacho_detalle where id in (select orden_despacho_detalle_id from factura_orden_despacho where casa_proveedora_id=#{params[:casa_proveedora_id][0]}))")
      casa_nombre=CasaProveedora.find(params[:casa_proveedora_id][0]).nombre      
      
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
        
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.casa_proveedora_igual')} '#{casa_nombre}'"
    end
    end
        
    
    # busqueda por sucursal casa proveedora
    
    unless params[:sucursal_casa_proveedora_id].nil?
      unless params[:sucursal_casa_proveedora_id][0].to_s==''            
      
      orden = OrdenDespacho.find(:all,:select=>"distinct (id)",:conditions=>"id in (select orden_despacho_id from orden_despacho_detalle where id in (select orden_despacho_detalle_id from factura_orden_despacho where sucursal_casa_proveedora_id=#{params[:sucursal_casa_proveedora_id][0]}))")
      sucu_nombre=SucursalCasaProveedora.find(params[:sucursal_casa_proveedora_id][0]).nombre      
      
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
        
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sucursal_casa_proveedora_igual')} '#{sucu_nombre}'"
    end
    end
   
    if (params[:fecha_desde_f].to_s!='' && params[:fecha_hasta_f].to_s!='')        

          fecha =format_fecha_conversion(params[:fecha_desde_f])
          fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])        

          @condition << "and (fecha_orden_despacho >= '#{fecha}'"
          @condition << " and fecha_orden_despacho <= '#{fecha_hasta}')"
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}'"
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                    
      
    
    # casos especiales    
    elsif (params[:fecha_desde_f].to_s=='' && params[:fecha_hasta_f].to_s!='') 
      
        fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])        
        @condition << " and fecha_orden_despacho <= '#{fecha_hasta}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                                    
      
    
    elsif (params[:fecha_desde_f].to_s!='' && params[:fecha_hasta_f].to_s=='')
      
          fecha =format_fecha_conversion(params[:fecha_desde_f])
          @condition << "and fecha_orden_despacho >= '#{fecha}'"                    
          @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                                
    
    end   
    
    
    @list = ViewListOrdenDespacho.search_join(@condition, params[:page], params['sort'],join)    
    @total=@list.count
    form_list
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

      logger.debug "condiciones >>>>>>>>>> " << condi.to_s


@facturas = FacturaOrdenDespacho.find(:all,:conditions=>"emitida=true and orden_despacho_detalle_id in #{condi} ",:select=>"distinct numero_factura, sum (monto_factura) as monto_total_factura,sum (cantidad_factura) as cantidad_total_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:group=>"numero_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia",:order=>"secuencia")

#anteriormente estaba esto
      #@facturas = FacturaOrdenDespacho.find(:all,:conditions=>"orden_despacho_detalle_id in #{condi} ",:order=>"secuencia")    
    else
      @facturas=[]           
    end    




		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.hide "row_#{params[:orden_id]}"
      page.insert_html :after, "row_#{params[:orden_id]}", :partial => 'detail' , :orden_id=>params[:orden_id]
  		page.visual_effect :highlight, "row_#{params[:orden_id]}_view", :duration => 1.6
    end


    #form_expand @orden
  end


  def collapse
    @mis_ordenes=OrdenDespachoDetalle.find(:all ,:conditions=>"orden_despacho_id = #{params[:orden_id]}") 

    unless @mis_ordenes.empty?
    condi="("
        @mis_ordenes.each{ |orden_detalle|

          condi+=orden_detalle.id.to_s << "," 
        }
    condi=condi[0,condi.length-1]      
    condi+=")"   



      @facturas = FacturaOrdenDespacho.find(:all,:conditions=>"emitida=true and orden_despacho_detalle_id in #{condi}",:order=>"secuencia")    
    else
      @facturas=[]           
    end    

		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.remove "row_#{params[:orden_id]}_view"
      page.show "row_#{params[:orden_id]}"
  		page.visual_effect :highlight, "row_#{params[:orden_id]}", :duration => 1.6
    end

  end

  def sector_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    @rubro_list = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{params[:id]}", :order=>"nombre")
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
    end
  end

  def rubro_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    @sub_rubro_list = SubRubro.find(:all, :conditions=>"activo=true and rubro_id = #{params[:id]}", :order=>"nombre")
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
    end
  end

  def sub_rubro_change
    logger.info "XXXXX:::=========================>>>>>>" << params[:id].to_s
    @actividad_list = Actividad.find(:all, :conditions=>"activo=true and sub_rubro_id = #{params[:id]}", :order=>"nombre")
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end

  def casa_proveedora_change

    @cuenta_casa_proveedora = CasaProveedora.find(:all, :conditions=>"activo=true and id = #{params[:id]}", :order=> "numero_cuenta")

    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'cuenta_casa_proveedora_select'      
      page.replace_html 'banco-cuenta-casa-proveedora-select', :partial => 'banco_cuenta_casa_proveedora_select'  

    end
  end

  def estado_change

    #@estado_aux = Estado.find_by_sql("select estado_id from ciudad where id in (select ciudad_id from oficina where id=#{params[:id]} ) ")

    @casa_proveedora_select = CasaProveedora.find_by_sql("select * from casa_proveedora where activo=true and ciudad_id in (select id from ciudad where estado_id=#{params[:id]}) order by nombre")

    render :update do |page|
      page.replace_html 'casa-proveedora-select', :partial => 'casa_proveedora_select'      
    end
  end

  def casa_change

    @sucursal_casa_proveedora_select = params[:id].to_s == "" ? [] : SucursalCasaProveedora.find(:all,:conditions=>"casa_proveedora_id=#{params[:id]}",:order=>"nombre")

    render :update do |page|
      page.replace_html 'sucursal-casa-proveedora-select', :partial => 'sucursal_casa_proveedora_select'      
    end
  end



protected

  def fill
    @estado = Estado.find(:all, :order=>'nombre')
    @sector = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    @estatus_list = Estatus.find(:all,:conditions=>"id >=20000 and id <30000", :order=>'nombre')
    @rubro_list = []
    @sub_rubro_list = []
    @actividad_list = []
    @casa_proveedora_select = CasaProveedora.find(:all,:conditions=>"activo=true",:order=>"nombre")
    @sucursal_casa_proveedora_select = []
  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho')
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho')
    @form_title_records = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.ordenes_despachos')
    @form_entity = 'orden_despacho_consulta'
    @form_identity_field = 'id'
    @width_layout = '1180'
  end

  
end
