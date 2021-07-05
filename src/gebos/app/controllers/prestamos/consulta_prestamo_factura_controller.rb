class Prestamos::ConsultaPrestamoFacturaController < FormTabTabsController

 include RjReport

  def index
    list
  end

  def list
    _list

    logger.info "list #{@list.inspect}"
    form_list

  end

  def imprimir

    @factura = Factura.find(params[:factura_id]);
    @prestamo = Prestamo.find(params[:prestamo_id]);

    #puts "Tipo factura " + @factura_tipo.to_s

    parameters = {:p_id_factura=> [@factura.id, "integer"]}
    if @factura.tipo == "P" or @factura.tipo == "R"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.aplicacion_pagos')
    elsif @factura.tipo == "D" or @factura.tipo == "M"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.factura_desembolso')
    elsif @factura.tipo == "X"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.factura_reestructuracion_destino')
    elsif @factura.tipo == "W"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.factura_reestructuracion_origen')
    elsif @factura.tipo == "C"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.factura_cancelacion')
    elsif @factura.tipo == "A" or @factura.tipo == "E"
      nombre_reporte = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFActura.NombreReporte.factura_abono')
    end

    unless @factura.tipo.nil?
      send_doc(nombre_reporte, parameters, "prestamos", "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFactura.NombreReporte.factura')}_#{@factura.id.to_s}", "pdf" )
    end
  end

  def view_only
    @prestamo = Prestamo.find(params[:prestamo_id])
    @factura = Factura.find(params[:id])
  end


  def view
    @prestamo = Prestamo.find(params[:prestamo_id])
    @factura = Factura.find(params[:id])
  end




  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFactura.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFactura.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoFactura.FormTitles.form_title_records')
    @form_entity = 'factura'
    @form_identity_field = 'factura.fecha'
    @width_layout = '1200'

    @prestamo = Prestamo.find(params[:prestamo_id])

  end

  private

  def _list
    conditions = ["factura.prestamo_id = ?", @prestamo.id]
    params['sort'] = "factura.id desc" unless params['sort']

    
    @list = Factura.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end

end

