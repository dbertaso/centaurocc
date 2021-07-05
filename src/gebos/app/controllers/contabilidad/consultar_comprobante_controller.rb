# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::ConsultarComprobanteController
# descripción: Migración a Rails 3

class Contabilidad::ConsultarComprobanteController < FormClassicController

  layout 'form'

  skip_before_filter :set_charset, :only => [:expand, :collapse]

  def index
    fecha_hoy = Time.now
    @fecha_desde = fecha_hoy.day.to_s + "/" + fecha_hoy.month.to_s + "/" + fecha_hoy.year.to_s
    @fecha_hasta = fecha_hoy.day.to_s + "/" + fecha_hoy.month.to_s + "/" + fecha_hoy.year.to_s
    fill
    
  end

  def list

    @conditions = ''
    
    params['sort'] = "tc_nombre desc" unless params['sort']

    unless params[:transaccion_contable_id].nil? || params[:transaccion_contable_id].empty?
      @conditions = [" tc_id = ? ", "#{params[:transaccion_contable_id].to_s}"]
      if !params[:transaccion_contable_id].nil? &&
         !params[:transaccion_contable_id].empty? &&
         params[:transaccion_contable_id].to_i != 0
     
        transaccion = TransaccionContable.find(params[:transaccion_contable_id].to_i)
      end
      
      unless transaccion.nil?
        @form_search_expression << "#{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.transaccion_igual')} '#{transaccion.nombre}'"
      end
    end
    
    unless params[:programa_id].nil? || params[:programa_id].empty?

      unless @conditions.empty?
        @conditions += [" and programa_id = ? ", "#{params[:programa_id].to_s}"]
      else
        @conditions += ["programa_id = ? ", "#{params[:programa_id].to_s}"]
      end
      
      if params[:programa_id].to_i != 0
        programa = Programa.find(params[:programa_id].to_i)
        @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.programa_igual')} '#{programa.nombre}'"
      end

    end
    
    unless params[:numero_prestamo].nil? || params[:numero_prestamo].empty?

      unless @conditions.empty?
        @conditions = [" and prestamo_numero = ?", "#{params[:numero_prestamo]}"]
      else
        @conditions = ["prestamo_numero = ?", "#{params[:numero_prestamo]}"]
      end

      @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.numero_financiamiento_igual')} '#{params[:numero_prestamo]}'"

      
    end
    
    unless params[:numero_solicitud].nil? || params[:numero_solicitud].empty?
      unless @conditions.empty?
        @conditions = [" and solicitud_numero = ?", "#{params[:numero_solicitud].to_s}"]
      else
        @conditions = [" solicitud_numero = ?", "#{params[:numero_solicitud].to_s}"]
      end

      @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.numero_tramite_igual')} '#{params[:numero_solicitud].to_s}'"
      
    end
    


    unless  params[:fecha_hasta].nil? || 
            params[:fecha_desde].nil? || 
            params[:fecha_hasta].empty? || 
            params[:fecha_desde].empty?

      fecha_desde = params[:fecha_desde].split("/") unless  params[:fecha_desde].nil?
      #fecha_desde = Time.gm(fecha_desde[2], fecha_desde[1], fecha_desde[0]) unless  @params[:fecha_desde].nil? || @params[:fecha_desde].empty?
      fecha_desde = fecha_desde[2].to_s << "-" << fecha_desde[1].to_s << "-" << fecha_desde[0].to_s

      fecha_hasta = params[:fecha_hasta].split("/") unless  params[:fecha_hasta].nil?
      #fecha_hasta = Time.gm(fecha_hasta[2], fecha_hasta[1], fecha_hasta[0])  unless  @params[:fecha_hasta].nil? || @params[:fecha_hasta].empty?
      fecha_hasta = fecha_hasta[2].to_s << "-" << fecha_hasta[1] << "-" << fecha_hasta[0]

      unless @conditions.empty?
        @conditions += " and fecha_registro between '" + fecha_desde.to_s + "' and '" + fecha_hasta.to_s + "'" 
      else
        @conditions += "fecha_registro between '" + fecha_desde.to_s + "' and '" + fecha_hasta.to_s + "'" 
      end

      @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.fecha_desde')} '#{params[:fecha_desde].to_s}' "
      @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.fecha_hasta')} '#{params[:fecha_hasta].to_s}'"
    end

    unless params[:tipo].nil? and
           params[:identificacion].nil?

      unless  params[:identificacion].nil? || params[:identificacion].empty?

        unless @conditions.empty?
          @conditions += " and identificacion = " + "'" + param[:tipo]+params[:identificacion] + "'"
        else
          @conditions += " and identificacion = " + "'" + param[:tipo]+params[:identificacion] + "'"
        end

        @form_search_expression << " #{t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormSearch.rif_cedula_contenga')} '#{tipo}#{params[:identificacion].to_s}'"
      end
    
    end

    unless  params[:nombre].nil? || 
            params[:nombre].empty?

      unless @conditions.empty?
        @conditions += " and nombre_cliente like " + "'" +  "%" + params[:nombre].strip.downcase + "%"  + "'"
      else
        @conditions += " and nombre_cliente like " + "'" +  "%" + params[:nombre].strip.downcase + "%"  + "'"
      end

      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre].to_s}'"
    end
    logger.info "\nCONDICIONES ========> " + @conditions.to_s

    # @form_search_expression << "Fecha sea mayor a '#{@params[:fecha_desde]}'"
    # @form_search_expression << "Fecha sea menor a '#{@params[:fecha_hasta]}'"

    @list = ViewComprobantesContables.search(@conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
  def expand
    @comprobante_contable = ComprobanteContable.find(params[:comprobante_contable_id])
    form_expand @comprobante_contable
  end
  
  def collapse
    @comprobante_contable = ComprobanteContable.find(params[:comprobante_contable_id])
    form_collapse @comprobante_contable
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.ConsultarComprobante.FormTitles.form_title_records')
    @form_entity = 'comprobante_contable'
    @form_identity_field = 'fecha_comprobante'
  end

  def fill
    @transaccion_contable_select = TransaccionContable.find(:all, :order=>'nombre')
    @programa_select = Programa.find(:all, :order=>'nombre')
  end


end
