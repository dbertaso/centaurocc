class Prestamos::ConsultaPrestamoSituacionController < FormTabsController

  skip_before_filter :set_charset, :only=>[:imprimir]
  #include RjReport
  require 'prawn'

  layout 'form_basic'

  def index
  
    @prestamo = Prestamo.find(params[:prestamo_id])
    
    #Se recuperan los desembolsos efectuados
    
    @facturas_desembolso = Factura.select("fecha_realizacion,
                                                     fecha,
                                                     fecha_contable,
                                                     monto_banco,
                                                     monto_insumos,
                                                     monto_inventario,
                                                     monto_sras,
                                                     monto_gastos,
                                                     monto,
                                                     numero,
                                                     desembolso_id,
                                                     prestamo_id").
                                                     where("prestamo_id = ? and tipo = ?",params[:prestamo_id], 'D').order('fecha_realizacion desc').all
    
    #Se recuperan los pagos efectuados
    
    @facturas_pago = ViewPagosEstadoCuenta.where("prestamo_id = ? ",params[:prestamo_id]).order('fecha_realizacion desc').all
                                                
    #Se recuperan los excedentes pagados
    
    @pago_excedentes = ViewExcedenteArrime.select("fecha_abono_cuenta,
                                                                fecha_registro_cheque,
                                                                tipo_cheque,
                                                                monto_abono,
                                                                referencia,
                                                                tipo,
                                                                numero_cuenta,
                                                                banco").
                                           where("prestamo_id = ? and (fecha_abono_cuenta is not null or fecha_registro_cheque is not null)", params[:prestamo_id]).
                                           order('fecha_abono_cuenta desc').all
    
    @cronograma_pagos = ViewCronogramaPagos.where("prestamo_id = ? and activo = true", params[:prestamo_id]).
                                            order('tipo_cuota desc, numero').all
    @cliente = @prestamo.cliente
  
    
    @facturas = FacturaOrdenDespacho.select("distinct numero_factura, sum (monto_factura) as monto_total_factura,sum (cantidad_factura) as cantidad_total_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia").
      where("emitida = true and 
             confirmada = true and 
             orden_despacho_detalle_id in (select id from orden_despacho_detalle where orden_despacho_id in (select id from orden_despacho where solicitud_id = #{@prestamo.solicitud_id}))").
      group("numero_factura,casa_proveedora_id,sucursal_casa_proveedora_id,emitida,confirmada,fecha_factura,fecha_emision,factura_estatus_id,secuencia").
      order('secuencia')
    
  end

  def generar()
    
    @prestamo = Prestamo.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GenerarPdf.new
        send_data pdf.render,  filename: "prueba.pdf",
          type: "application/pdf"

      end
    end
  end

  protected
  def common
    super
    @form_title = t('Sistema.Body.Controladores.ConsultaPrestamoSituacion.FormTitles.form_title')
    @form_title_record = t('Sistema.Body.Controladores.ConsultaPrestamoSituacion.FormTitles.form_title_record')
    @form_title_records = t('Sistema.Body.Controladores.ConsultaPrestamoSituacion.FormTitles.form_title_records')
    @form_entity = 'prestamo'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end


end


