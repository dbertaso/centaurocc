# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoReimpresionFacturasConfirmadasController
# descripción: Migración a Rails 3
#

class Solicitudes::OrdenDespachoReimpresionFacturasConfirmadasController < FormTabsController

  layout 'form_basic'
  

  skip_before_filter :set_charset, :only=>[:sector_change, :rubro_change, :sub_rubro_change, :imprimir]
  

  def index
     
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.consulta_facturas_confirmadas')
    fill()
  end

  def list_especial(oid,sol)  
    
  
  sentencia="select fact.numero_factura,fact.casa_proveedora_id,fact.sucursal_casa_proveedora_id,fact.factura_estatus_id,fact.monto_factura,fact.cantidad_factura,fact.observacion,fact.secuencia,fact.orden_despacho_detalle_id,fact.fecha_emision,fact.fecha_factura,ord_det.item_nombre,ord.id as orden_despacho_id,ord.numero as orden_despacho_numero,sucu.persona_contacto,casa.rif,casa.tipo_pago,sol.id as solicitud_id,
        CASE
            WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
            ELSE emp.nombre
        END AS nombre, 
	CASE		
            WHEN emp.nombre IS NULL THEN (select upper(nombre) from municipio where id = per_dir.municipio_id)
            ELSE (select upper(nombre) from municipio where id = emp_dir.municipio_id)
        END AS nombre_municipio, 
        CASE		
            WHEN emp.nombre IS NULL THEN (select upper(nombre) from estado where id = (select estado_id from ciudad where id=per_dir.ciudad_id))
            ELSE (select upper(nombre) from estado where id = (select estado_id from ciudad where id=emp_dir.ciudad_id))
        END AS nombre_estado, 
	CASE
            WHEN per_int.id IS NULL THEN (''::text)
            ELSE ((upper(per_int.primer_nombre)::text || ' '::text) || upper(per_int.segundo_nombre)::text || ' '::text || (upper(per_int.primer_apellido)::text ) || ' '::text || (upper(per_int.segundo_apellido)::text ))::character varying
        END AS nombre_representante,
	CASE
            WHEN per_int.id IS NULL THEN (''::text)
            ELSE ((per_int.cedula_nacionalidad::text || ' '::text) || per_int.cedula::text)::character varying
        END AS cedula_representante,        
        CASE
            WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
            ELSE emp.rif
        END AS cedula_rif,
        CASE
            WHEN emp_dir.id IS NULL THEN ((upper(per_dir.avenida)::text || ' '::text) || upper(per_dir.edificio)::text || ' '::text || (upper(per_dir.zona)::text ))::character varying
            ELSE ((upper(emp_dir.avenida)::text || ' '::text) || upper(emp_dir.edificio)::text || ' '::text || (upper(emp_dir.zona)::text ))::character varying
        END AS direccion_completa
from factura_orden_despacho fact
inner join orden_despacho_detalle ord_det on fact.orden_despacho_detalle_id=ord_det.id
inner join orden_despacho ord on ord_det.orden_despacho_id =ord.id
LEFT JOIN solicitud sol ON ord.solicitud_id = sol.id
left JOIN cliente cli ON sol.cliente_id = cli.id
LEFT JOIN empresa emp ON cli.empresa_id = emp.id
LEFT JOIN persona per ON cli.persona_id = per.id
LEFT JOIN empresa_direccion emp_dir ON emp.id = emp_dir.empresa_id
left JOIN persona_direccion per_dir ON per.id = per_dir.persona_id
left JOIN persona per_int ON per_int.id=(select persona_id from empresa_integrante,empresa_integrante_tipo where empresa_integrante.empresa_id=emp.id and empresa_integrante_tipo.empresa_integrante_id = empresa_integrante.id and empresa_integrante_tipo.tipo = 'R')
join casa_proveedora casa on fact.casa_proveedora_id=casa.id
join sucursal_casa_proveedora sucu on fact.sucursal_casa_proveedora_id=sucu.id
where fact.monto_factura>0 and fact.emitida=true and fact.confirmada=true and orden_despacho_id=#{oid} and solicitud_id=#{sol}
order by secuencia,orden_despacho_id,fact.numero_factura,fact.secuencia,fact.orden_despacho_detalle_id"
    

    @list =FacturaOrdenDespacho.find_by_sql(sentencia)
    @total = @list.length    

	@total_saldo_entregar=0	
    @cantidad_total_entregar=0	
	cont=0    
    
    while cont< @total
    @total_saldo_entregar+=@list[cont].monto_factura   
    @cantidad_total_entregar+=@list[cont].cantidad_factura   
	cont+=1	
	end  

    form_list
  end



   def imprimir

 # aqui guardo todos los datos que necesito para imprimirlos en las variable

    @width_layout = '1155'
    @form_title = ''
    @imprimo='1'   

#sentecia a ejecutar

sentencia="select distinct orden_despacho_numero,numero_factura,secuencia,observacion,casa_proveedora_id,sucursal_casa_proveedora_id,persona_contacto,rif,tipo_pago,nombre,cedula_rif,direccion_completa,nombre_representante,cedula_representante,nombre_municipio,nombre_estado from (select fact.numero_factura,fact.casa_proveedora_id,fact.sucursal_casa_proveedora_id,fact.factura_estatus_id,fact.monto_factura,fact.cantidad_factura,fact.observacion,fact.secuencia,fact.orden_despacho_detalle_id,fact.fecha_emision,fact.fecha_factura,ord_det.item_nombre,ord.id as orden_despacho_id,ord.numero as orden_despacho_numero,sucu.persona_contacto,casa.rif,casa.tipo_pago,sol.id as solicitud_id,
        CASE
            WHEN emp.nombre IS NULL THEN ((per.primer_nombre::text || ' '::text) || per.primer_apellido::text)::character varying
            ELSE emp.nombre
        END AS nombre, 
	CASE		
            WHEN emp.nombre IS NULL THEN (select upper(nombre) from municipio where id = per_dir.municipio_id)
            ELSE (select upper(nombre) from municipio where id = emp_dir.municipio_id)
        END AS nombre_municipio, 
        CASE		
            WHEN emp.nombre IS NULL THEN (select upper(nombre) from estado where id = (select estado_id from ciudad where id=per_dir.ciudad_id))
            ELSE (select upper(nombre) from estado where id = (select estado_id from ciudad where id=emp_dir.ciudad_id))
        END AS nombre_estado, 
	CASE
            WHEN per_int.id IS NULL THEN (''::text)
            ELSE ((upper(per_int.primer_nombre)::text || ' '::text) || upper(per_int.segundo_nombre)::text || ' '::text || (upper(per_int.primer_apellido)::text ) || ' '::text || (upper(per_int.segundo_apellido)::text ))::character varying
        END AS nombre_representante,
	CASE
            WHEN per_int.id IS NULL THEN (''::text)
            ELSE ((per_int.cedula_nacionalidad::text || ' '::text) || per_int.cedula::text)::character varying
        END AS cedula_representante,        
        CASE
            WHEN emp.rif IS NULL THEN ((per.cedula_nacionalidad::text || ' '::text) || per.cedula::text)::character varying
            ELSE emp.rif
        END AS cedula_rif,
        CASE
            WHEN emp_dir.id IS NULL THEN ((upper(per_dir.avenida)::text || ' '::text) || upper(per_dir.edificio)::text || ' '::text || (upper(per_dir.zona)::text ))::character varying
            ELSE ((upper(emp_dir.avenida)::text || ' '::text) || upper(emp_dir.edificio)::text || ' '::text || (upper(emp_dir.zona)::text ))::character varying
        END AS direccion_completa
from factura_orden_despacho fact
inner join orden_despacho_detalle ord_det on fact.orden_despacho_detalle_id=ord_det.id
inner join orden_despacho ord on ord_det.orden_despacho_id =ord.id
LEFT JOIN solicitud sol ON ord.solicitud_id = sol.id
left JOIN cliente cli ON sol.cliente_id = cli.id
LEFT JOIN empresa emp ON cli.empresa_id = emp.id
LEFT JOIN persona per ON cli.persona_id = per.id
LEFT JOIN empresa_direccion emp_dir ON emp.id = emp_dir.empresa_id
left JOIN persona_direccion per_dir ON per.id = per_dir.persona_id
left JOIN persona per_int ON per_int.id=(select persona_id from empresa_integrante,empresa_integrante_tipo where empresa_integrante.empresa_id=emp.id and empresa_integrante_tipo.empresa_integrante_id = empresa_integrante.id and empresa_integrante_tipo.tipo = 'R')
join casa_proveedora casa on fact.casa_proveedora_id=casa.id
join sucursal_casa_proveedora sucu on fact.sucursal_casa_proveedora_id=sucu.id
where fact.monto_factura>0 and fact.emitida=true and fact.confirmada=true and orden_despacho_id=#{params[:id]} and solicitud_id=#{params[:solicitud_id]}
order by secuencia,orden_despacho_id,fact.numero_factura,fact.secuencia,fact.orden_despacho_detalle_id) as tempo
group by orden_despacho_numero,numero_factura,secuencia,observacion,casa_proveedora_id,sucursal_casa_proveedora_id,persona_contacto,rif,tipo_pago,nombre,cedula_rif,direccion_completa,nombre_representante,cedula_representante,nombre_municipio,nombre_estado
order by orden_despacho_numero,secuencia"

@factura_orden_despacho =FacturaOrdenDespacho.find_by_sql(sentencia)

@solicitudes = Solicitud.find(params[:solicitud_id])

@oficina= Oficina.find(:all,:conditions => ['id = ?', @solicitudes.oficina_id]) unless @solicitudes.nil?

@parametros_general=ParametroGeneral.find(:first)

@marca=params[:marca]

list_especial(params[:id],params[:solicitud_id])

#@vista = 'view_orden_despacho_planilla'

 end


# list especial para el proceso de reimpresion y consulta
  def list

   #anterior @condition ="solicitud_id > 0 and oficina_id = #{identificador_oficina}"
    moneda_id = ParametroGeneral.first.moneda_id
    @condition ="moneda_id = #{moneda_id} and solicitud_id > 0 " 
    
    params[:sort] = "numero" unless params[:sort]
    
    # busqueda por sector
    unless params[:sector_id].nil? 
    unless params[:sector_id][0].to_s==''
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)      
      @condition << " and sector_id = #{sector_id}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
    end
    end

    # busqueda por rubro
    unless params[:rubro_id].nil? 
    unless params[:rubro_id][0].to_s==''
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)      
      @condition << " and rubro_id = #{rubro_id}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
    end
    end

 # busqueda por Sub rubro
    unless params[:sub_rubro_id].nil? 
    unless params[:sub_rubro_id][0].to_s==''
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      subrubro = SubRubro.find(sub_rubro_id)      
      @condition << " and sub_rubro_id = #{sub_rubro_id}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{subrubro.nombre}'"
    end
    end

 # busqueda por actividad
    unless params[:actividad_id].nil? 
    unless params[:actividad_id][0].to_s==''
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)      
      @condition << " and actividad_id = #{actividad_id}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
    end
    end


    # busqueda por numero de tramite
    unless params[:numero].to_s=="" || params[:numero].to_s.empty?
      @condition << " AND numero = '#{params[:numero].to_i}'"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
      logger.info "XXXXXXXXXXXX==============>>>>>>>" << @form_search_expression.inspect
    end
 
    # busqueda por cedula
    unless params[:identificacion].to_s=="" ||  params[:identificacion].to_s.empty?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:identificacion]}'"
    end

    # busqueda por nombre o apellido
  
    unless params[:nombre].to_s=="" || params[:nombre].to_s.empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end

    # busqueda por estatus orden de despacho nuevo filtro al 24/05/2013
    unless params[:estatus_orden_id].nil? 
    unless params[:estatus_orden_id][0].to_s==''
      estatus_id = params[:estatus_orden_id][0].to_s      
      estatus_nombre=Estatus.find(estatus_id).nombre      
      @condition << " and estatus_id = #{estatus_id}"            
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_od_igual')} '#{estatus_nombre}'"
    end
    end
 
   
   if (params[:fecha_desde_f].to_s!=''  && params[:fecha_hasta_f].to_s!='')        

       fecha =format_fecha_conversion(params[:fecha_desde_f])
       fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])       

        
                @condition << "and (fecha_orden >= '#{fecha}'"
                @condition << " and fecha_orden <= '#{fecha_hasta}')"
                
                @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}'"
                @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                    
        
    
    # casos especiales    
    elsif (params[:fecha_desde_f].to_s==''  && params[:fecha_hasta_f].to_s!='')    
        
        fecha_hasta =format_fecha_conversion(params[:fecha_hasta_f])       
        
        @condition << " and fecha_orden <= '#{fecha_hasta}'"                
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_hasta')} '#{params[:fecha_hasta_f].to_s}'"                                    
                      
    
    
    elsif (params[:fecha_desde_f].to_s!='' && params[:fecha_hasta_f].to_s=='') 
        
        fecha =format_fecha_conversion(params[:fecha_desde_f])
        
        @condition << "and fecha_orden >= '#{fecha}'"                     
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_registro_desde')} '#{params[:fecha_desde_f].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                    
            
    
    end
    
    #nuevo        
    
    @list = ViewListOrdenDespachoConsulta.search(@condition, params[:page], params[:sort])            
    @total=@list.count
    
    form_list
    
    
  end


  def sector_change    
    params[:id].to_s=="" ? @rubro_list =[] : @rubro_list = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{params[:id]}", :order=>"nombre")
    @sub_rubro_list=[]
    @actividad_list=[]    
    
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end

  def rubro_change    
    params[:id].to_s=="" ? @sub_rubro_list =[] : @sub_rubro_list = SubRubro.find(:all, :conditions=>"activo=true and rubro_id = #{params[:id]}", :order=>"nombre")
    @actividad_list=[]    
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end


  def sub_rubro_change    
    params[:id].to_s=="" ? @actividad_list =[] : @actividad_list = Actividad.find(:all, :conditions=>"activo=true and sub_rubro_id = #{params[:id]}", :order=>"nombre")
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end   
  

protected

  def fill    
    @sector = Sector.find(:all,:conditions=>"activo=true" ,:order=>'nombre')
    @estatus_list = Estatus.find(:all,:conditions=>"id >=20000 and id <30000", :order=>'nombre')
    @rubro_list = []
    @sub_rubro_list = []
    @actividad_list = []    
  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.facturas_od_confirmadas')
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.facturas_od_confirmadas')
    @form_title_records = I18n.t('Sistema.Body.ModalidadPago.orden_despacho')
    @form_entity = 'view_list_orden_despacho_consulta'
    @form_identity_field = 'numero'
    @records_by_page=15    
    @width_layout = '1180'
  end

end
