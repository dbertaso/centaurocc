# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::OrdenDespachoArchivosGeneradosController
# descripción: Migración a Rails 3
#

class Solicitudes::OrdenDespachoArchivosGeneradosController < FormTabsController

  
  skip_before_filter :set_charset, :only=>[:actualiza_plan]

  def index

  end

  def list
  @condition="control_orden_despacho_insumo.id > 0 and "

  @condition << params[:tipo][0].to_s
      

  params['sort'] = "fecha desc" unless params['sort']


  logger.debug "entrando a list " << params[:fecha_hasta].to_s << " " << params[:fecha_desde].to_s << " " << params[:tipo].to_s

    if (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s!='')
      
        
      fecha_valor_desde =format_fecha_conversion(params[:fecha_desde])
      fecha_valor_hasta =format_fecha_conversion(params[:fecha_hasta])

      @condition << " AND (fecha between '#{fecha_valor_desde}' and '#{fecha_valor_hasta}')"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_desde')} '#{params[:fecha_desde].to_s}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_hasta')} '#{params[:fecha_hasta].to_s}'"                                
    
    elsif (params[:fecha_desde]=='' && params[:fecha_hasta].to_s!='')        
        logger.debug "aqui 2"
        
        fecha_valor_hasta =format_fecha_conversion(params[:fecha_hasta])
        
        @condition << " and fecha <= '#{fecha_valor_hasta}'"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_hasta')} '#{params[:fecha_hasta].to_s}'"                                    
        
    
    
    elsif (params[:fecha_desde].to_s!='' && params[:fecha_hasta].to_s=='')
        logger.debug "aqui 3"
        

        fecha_valor_desde =format_fecha_conversion(params[:fecha_desde])
        
        @condition << "and fecha >= '#{fecha_valor_desde}'"                    
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.fecha_desde')} '#{params[:fecha_desde].to_s}' #{I18n.t('Sistema.Body.Controladores.SearchComun.en_adelante')}"                            
    


    end

    
    @list = ControlOrdenDespachoInsumo.search(@condition, params[:page], params['sort'])
    @total=@list.count
    form_list
  end




   def preparar_transferencia

    @estado = Estado.find(:all, :order=>'nombre')
    @casa_proveedora_select = []


   @form_title_record=I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_transferencia')


  end



  def preparar_cheque

    @estado = Estado.find(:all, :order=>'nombre')
    @casa_proveedora_select = []

   @form_title_record=I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.pago_casa_proveedora_cheque')


  end

 


protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.archivos_generados_pago_casa_proveedora')
    @form_title_record = I18n.t('Sistema.Body.Modelos.OrdenDespacho.Mensajes.orden_despacho')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.orden_despacho')
    @form_entity = 'control_orden_despacho_insumo'
    @form_identity_field = 'id'
    @width_layout = '1180'
  end

end
