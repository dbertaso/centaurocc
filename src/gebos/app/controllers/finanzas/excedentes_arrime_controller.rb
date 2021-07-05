# encoding: utf-8

class Finanzas::ExcedentesArrimeController < FormTabsController

  skip_before_filter :set_charset, :only=>[:pagar_excedente]
  
  layout 'form_basic'
 


  def index

  end


  def list

    
    conditions = " remanente_por_aplicar > 0 and prestamo.estatus = 'C'  "
    @condition = ""
    #estatus = Estatus.find(estatus_id)
    #@form_search_expression << "Estatus igual '#{estatus.nombre}'"

    params['sort'] = "prestamo.numero" unless params['sort']
           
    unless params[:solicitud_numero].nil? || params[:solicitud_numero].empty?
      @condition << " AND solicitud_id = (select id from solicitud where numero =  #{params[:solicitud_numero]} )"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:solicitud_numero]}'"
    end
    
    unless params[:prestamo_numero].nil? || params[:prestamo_numero].empty?
      @condition << " AND prestamo.numero =  #{params[:prestamo_numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_prestamo_igual')} '#{params[:prestamo_numero]}'"
    end

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " and prestamo.cliente_id in 
        (select c.id from persona p,cliente c where c.persona_id = p.id and cast( cedula as text) like ('%#{params[:identificacion].strip}%'))
        or prestamo.cliente_id in (select c.id from empresa e,cliente c where c.empresa_id = e.id and upper(rif) like upper('%#{params[:identificacion].strip}%'))"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rif_cedula_contenga')} '#{params[:identificacion]}'"
    end

    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " and prestamo.cliente_id in 
        (select c.id from persona p,cliente c where c.persona_id = p.id and upper(primer_nombre || segundo_nombre || primer_apellido || segundo_apellido) like upper('%#{params[:nombre].strip}%'))
        or prestamo.cliente_id in (select c.id from empresa e,cliente c where c.empresa_id = e.id and upper(nombre) || upper(alias)  like upper('%#{params[:nombre].strip}%')) "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end
    
    if @condition != ""
      conditions = conditions <<  @condition
    end
    @conditions = conditions
           
    @filtro = params

    @list = Prestamo.search_excedente_arrime(@conditions, params[:page], params[:sort])
    @total=@list.count
           
      
    @monto_pagar = 0
    @ids = ""
    @idsTabla = ""
      
    @prestamos_todos =  Prestamo.find(:all, :conditions => @conditions)
    @prestamos_todos.each do |prestamo|
      @ids == "" ?  @ids = prestamo.id.inspect : @ids = @ids << "," << prestamo.id.inspect 
      @monto_pagar = @monto_pagar + prestamo.remanente_por_aplicar
    end
    @list.each do |prestamo|
      @idsTabla == "" ?  @idsTabla = prestamo.id.inspect : @idsTabla = @idsTabla << "," << prestamo.id.inspect 
    end
      
    if @ids == "" ; @ids = "0" end
    if @idsTabla == "" ; @idsTabla = "0" end
    form_list

  end

  def pagar_excedente

    fecha_evento = Time.now
    fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")  

    @prestamo = Prestamo.find(:first, :conditions=>"id in (#{params[:prestamo_id]}) and remanente_por_aplicar > 0 and estatus = 'C'")
    @prestamos = Prestamo.find(:all, :conditions=>"id in (#{params[:prestamo_id]}) and remanente_por_aplicar > 0 and estatus = 'C'")
    @prestamos_tabla = Prestamo.find(:all, :conditions=>"id in (#{params[:registros]}) and remanente_por_aplicar > 0 and estatus = 'C'")

    logger.info"XXXXXXXXX==========================>>>>>"<<@usuario.inspect
    success = @prestamo.pagar_excedente_arrime(@usuario, @prestamos)
    
    @cantidad_new = Prestamo.count(:conditions=>"id in (#{params[:prestamos_consulta]}) and remanente_por_aplicar > 0 and estatus = 'C'")
    @monto_new = Prestamo.sum(:remanente_por_aplicar, :conditions=>"id in (#{params[:prestamos_consulta]}) and remanente_por_aplicar > 0 and estatus = 'C'")
    if @cantidad_new == nil ; @cantidad_new = 0 end
    if @monto_new == nil ; @monto_new = 0 end
      
    if success == true
      numero_prestamos = ""
      cantidad_prestamos = 0
          
      @prestamos.each do |prestamo|
        numero_prestamos == "" ?  numero_prestamos  = prestamo.numero.to_s : numero_prestamos = numero_prestamos << ", " << prestamo.numero.to_s 
        cantidad_prestamos = cantidad_prestamos + 1          
      end  
      logger.info"XXXXXXXXX================cantidad==========>>>>>"<<cantidad_prestamos.inspect        
      render :update do |page|
        @prestamos_tabla.each do |prestamo|
          page.remove "row_#{prestamo.id}"
          page.<<"alert('row1 :'+'row_'+#{prestamo.id});"
        end
        page.hide 'error'
        if cantidad_prestamos == 1 ; page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.Arrime.Messages.se_envio_a_finanzas')} <a href='javascript:""' title='#{I18n.t('Sistema.Body.Modelos.Errores.tramites')}: #{numero_prestamos}'>#{cantidad_prestamos} #{I18n.t('Sistema.Body.Vistas.General.financiamiento')}</a> " end
        if cantidad_prestamos > 1 ; page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.Arrime.Messages.se_enviaron_a_finanzas')} <a href='javascript:""' title='#{I18n.t('Sistema.Body.Modelos.Errores.tramites')}: #{numero_prestamos}'>#{cantidad_prestamos} #{I18n.t('Sistema.Body.Vistas.General.financiamientos')}</a> " end
        if cantidad_prestamos > 0 ; page.show 'message' end
        page.replace_html 'dv_total', format_f(@monto_new )
        page.replace_html 'dv_cantidad', @cantidad_new 
        page.<< "window.scrollTo(0,0);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.form_error
      end
      return false
    end
      
  end



  def view
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
    @accion = params[:accion]
    @historial = DetalleReestructuracion.find(:all, :conditions=>["solicitud_id = ?", @solicitud.id])
  end
        
  protected
  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = I18n.t('Sistema.Body.Vistas.Arrime.HeaderExcedentesArrime.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Arrime.HeaderExcedentesArrime.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Arrime.HeaderExcedentesArrime.form_title_records')
    @form_entity = 'excedentes_arrime'
    @form_identity_field = 'numero'
    @width_layout = '1000'
  end
    
      
end

