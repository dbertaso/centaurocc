# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::ConsultaOrdenDespachoController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaOrdenDespachoController < FormTabsController

  layout 'form_basic'

  def index    
  end
  
  def view    
    @guias = ViewConsultaOrdenDespachoMaquinaria.find(:first,:conditions=>"solicitud_id=#{params[:solicitud_id]} and guia_id=#{params[:id]}")
    @maquinaria_list = GuiaCatalogo.find_by_sql("select * from view_guia_catalogo_edit_v2 where guia_movilizacion_maquinaria_id = #{params[:id]}")
	@info_recepcion = RecepcionMaquinaria.find(:first,:conditions=>"guia_movilizacion_maquinaria_id=#{params[:id]}") if @guias.estatus.strip =='R'
  end
 
  def list    
    
	identificador_oficina=Usuario.find(session[:id]).oficina_id

    @condition ="solicitud_id > 0 "
    params['sort'] = "numero_guia" unless params['sort']    

    # busqueda por numero de orden
    unless params[:nro_orden].to_s.nil? || params[:nro_orden].to_s.empty?
      @condition << " AND lower(numero_guia) like lower('%#{params[:nro_orden].to_s.strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_guia_igual')} '#{params[:nro_orden]}'"      
    end
	# busqueda por fechas

  if (params[:fecha_envio_f]!='')
    fecha_hasta =format_fecha_conversion(params[:fecha_envio_f])        
    @condition << " and fecha_envio <= '#{fecha_hasta}'"
    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_envio_hasta')} '#{params[:fecha_envio_f].to_s}'"                                    
  end
	

  if (params[:fecha_llegada_f]!='')
    fecha_hasta =format_fecha_conversion(params[:fecha_llegada_f])        
    @condition << " and fecha_llegada <= '#{fecha_hasta}'"
    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_llegada_hasta')} '#{params[:fecha_llegada_f].to_s}'"                                    
  end  
 
	# busqueda por origen
    unless params[:origen].to_s.nil? || params[:origen].to_s.empty?
      @condition << " AND lower(origen) LIKE lower('%#{params[:origen].to_s.strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.origen_igual')} '#{params[:origen]}'"
    end
	
	# busqueda por destino  
    
    unless params[:destino].to_s.nil? || params[:destino].to_s.empty?
      
      case params[:destino]
		when 'F' 
			destinoi = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Mensajes.oficina_asociada') #"Oficina Asociada al Trámite"
		when 'U'
			destinoi = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Mensajes.unidad_produccion_asociada') #"Unidad de Producción Asociada al Trámite"
		else
			destinoi = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Mensajes.otro_destino') #"Otro Destino"
	   end       
      
      @condition << " and destino = '#{params[:destino]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.destino_igual')} '#{destinoi}'"
      else
      @condition << ""
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.todos_destinos')}"
    end
	
    
    # busqueda por estatus
    unless params[:estatus].to_s.nil? || params[:estatus].to_s.empty?
      case params[:estatus]
		when 'E' 
			estatusi =I18n.t('Sistema.Body.Vistas.General.elaborada')
		when 'T'
			estatusi =I18n.t('Sistema.Body.Vistas.General.en_transito')  
		else
			estatusi =I18n.t('Sistema.Body.Vistas.General.recibida')
	   end       
      
      @condition << " and estatus = '#{params[:estatus]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{estatusi}'"
    else
      @condition << ""
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.todos_estatus')}"
    end

    # busqueda por cedula
    unless params[:identificacion].to_s.nil? ||  params[:identificacion].to_s.empty?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:identificacion].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:tipo].to_s}#{params[:identificacion]}'"
    end

    # busqueda por nombre o rif 
    unless params[:beneficiario].to_s.nil? || params[:beneficiario].to_s.empty?
      @condition << " AND UPPER(beneficiario) LIKE UPPER('%#{params[:beneficiario].strip}%')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_beneficiario')} '#{params[:beneficiario]}'"
    end   
    
    
    @list = ViewConsultaOrdenDespachoMaquinaria.search(@condition, params[:page], params[:sort])    
    @total=@list.count

    form_list
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Header.form_title') #'Consulta de Movilización Maquinaria'        
    @form_title_record = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Header.form_title_record') #'Movilización Maquinaria'
    @form_title_records = I18n.t('Sistema.Body.Vistas.ConsultaMovilizacionMaquinaria.Header.form_title_records') #'Movilizaciónes Maquinaria'
    @form_entity = 'view_consulta_orden_despacho_maquinaria'
    @form_identity_field = 'guia_id'
    @width_layout = '1180'
  end
end
