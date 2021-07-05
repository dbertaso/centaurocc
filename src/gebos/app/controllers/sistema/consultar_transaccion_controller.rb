# encoding: utf-8
class Sistema::ConsultarTransaccionController < FormClassicController

  layout 'form'
  
  skip_before_filter :set_charset, :only=>[:solicitar_autorizacion, :alink,:expand, :collapse, :expand_accion, :collapse_accion, :tabs, :reversar]
  
  def index
    fecha_hoy = Time.now.strftime(I18n.t('time.formats.gebos_short'))
    fecha_manana = Time.now + (60 * 60 * 24)
    @fecha_desde = fecha_hoy
    @fecha_hasta = fecha_manana.strftime(I18n.t('time.formats.gebos_short'))
    @tipo_transaccion_select = MetaTransaccion.find(:all, :order=>'nombre')
    @usuario_select = Usuario.find(:all, :order=>'nombre_usuario')
    
  end

  def list     
    params['sort'] = "transaccion.id desc" unless params['sort']  
    if params[:por_numero_transaccion]=='true'
      conditions = ["transaccion.id = ?", params[:numero_transaccion]]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.nro_suceso')} '#{params[:numero_transaccion]}'"
    else
      unless params[:fecha_desde].nil? or params[:fecha_desde] == ""


        fecha_desde = params[:fecha_desde].split("/")
        fecha_desde = Date.new(fecha_desde[2].to_i, fecha_desde[1].to_i, fecha_desde[0].to_i)

      end
  
      unless params[:fecha_hasta].nil? or params[:fecha_hasta] == ""

        fecha_hasta = params[:fecha_hasta].split("/")
        fecha_hasta = Date.new(fecha_hasta[2].to_i, fecha_hasta[1].to_i, fecha_hasta[0].to_i)

      end

      conditions = ["cast(fecha as date) >= ? and cast(fecha as date) <= ? " , fecha_desde, fecha_hasta]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.fecha_mayor_a')}'#{params[:fecha_desde]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.fecha_menor_a')}'#{params[:fecha_hasta]}'"
      if params[:por_usuario]
        conditions[0] << " and usuario_id = ?"
        conditions.<< params[:usuario_id]
        usuario = Usuario.find(params[:usuario_id]);
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.usuario_igual_a')}'#{usuario.nombre_usuario}'"
      end
      if params[:por_tipo_transaccion]
        conditions[0] << " and meta_transaccion_id = ?"
        conditions.<< params[:meta_transaccion_id]
        meta_transaccion = MetaTransaccion.find(params[:meta_transaccion_id]);
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.tipo_suceso_igual_a')}'#{meta_transaccion.nombre}'"
      end
      if params[:por_prestamo]
        prestamo = Prestamo.find_by_numero(params[:prestamo_numero])
        conditions[0] << " and prestamo_id = ?"
        logger.info prestamo.inspect
        conditions.<< prestamo.id
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.nro_prestamo')}'#{prestamo.numero}'"
      end
      if params[:reverso]
        conditions[0] << " and reversada = true"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.sucesos_sean_reversados')}"
      else
        conditions[0] << " and reversada = false"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.sucesos_no_sean_reversos')}"
      end
    end
    conditions[0] << " and transaccion.meta_transaccion_id is not null "
    
    @list = Transaccion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def reversar
    transaccion_id = params[:transaccion_id]
    valor = Transaccion.reversar(params[:transaccion_id])
    logger.info "Valor en Controlador =========> #{valor.to_s}"
    if valor == true
      render :update do |page|
        page.hide 'error'
        page.remove "row_#{transaccion_id}"
        page.replace_html 'message', "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.se_reverso_transaccion')} #{transaccion_id} #{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.con_exito')}"
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'error', "#{I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.Etiquetas.error_reverso')} #{transaccion_id}" + valor.to_s
        page.show 'error'
      end
    end
  end	

  
  def expand
    @transaccion = Transaccion.find(params[:transaccion_id])
    form_expand @transaccion
  end
  
  def expand_accion
    @transaccion_accion = TransaccionAccion.find(params[:transaccion_accion_id])
    @antes = @transaccion_accion.antes
    @despues = @transaccion_accion.despues
    
		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.hide "row_accion_#{@transaccion_accion.id}"
      page.insert_html :after, "row_accion_#{@transaccion_accion.id}", :partial => 'detail_accion'
  		page.visual_effect :highlight, "row_accion_#{@transaccion_accion.id}_view", :duration => 0.6
    end
    
  end
  
  def collapse_accion
  
    @transaccion_accion = TransaccionAccion.find(params[:transaccion_accion_id])
  
		render :update do |page|
  		page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
  		page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'
      page.remove "row_accion_#{@transaccion_accion.id}_view"
      page.show "row_accion_#{@transaccion_accion.id}"
  		page.visual_effect :highlight, "row_accion_#{@transaccion_accion.id}", :duration => 0.6
    end
  
  end
  
  def collapse
    @transaccion = Transaccion.find(params[:transaccion_id])
    form_collapse @transaccion
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultarTransaccion.FormTitles.form_title_records')
    @form_entity = 'transaccion'
    @form_identity_field = 'id'
  end



end
