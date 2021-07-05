# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: OrdenDespachoInsumo
# descripción: Migración a Rails 3
#


require 'rubygems'
require 'fastercsv'
require 'csv'

class OrdenDespachoInsumo < ActiveRecord::Base
 
  self.table_name = 'orden_despacho_insumo'
  
  belongs_to :estatus
  belongs_to :unidad_medida
  has_many :orden_despacho
  belongs_to :casa_proveedora
  belongs_to :solicitud
  belongs_to :seguimiento_visita
  belongs_to :prestamo
  belongs_to :factura_orden_despacho

#validates_presence_of :casa_proveedora_id, :sucursal_id,:message => " es requerido"

#validates_length_of :observacion, :within => 1..80, :allow_nil => false,
#    :too_short => " es demasiado corto (mínimo %d)",
#    :too_long => " es demasiado largo (máximo %d)"


  def cantidad_f=(valor)
    self.cantidad = format_valor(valor)
  end

  def cantidad_f
    format_fm(self.cantidad)
  end


def costo_real_f=(valor)
    self.costo_real = format_valor(valor)
  end

  def costo_real_f
    format_fm(self.costo_real)
  end

def monto_financiamiento_f=(valor)
    self.monto_financiamiento = format_valor(valor)
  end

  def monto_financiamiento_f
    format_fm(self.monto_financiamiento)
  end


def monto_facturacion_f=(valor)
    self.monto_facturacion = format_valor(valor)
  end

  def monto_facturacion_f
    format_fm(self.monto_facturacion)
  end


def cantidad_facturacion_f=(valor)
    self.cantidad_facturacion = format_valor(valor)
  end

  def cantidad_facturacion_f
    format_fm(self.cantidad_facturacion)
  end

def monto_recomendado_f=(valor)
    self.monto_recomendado = format_valor(valor)
  end

  def monto_recomendado_f
    format_fm(self.monto_recomendado)
  end

#### funciones de generacion de archivos

### primera funcion
  def self.generar_transferencias(entidad_financiera_id, tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)

    logger.debug 'Entrando GenerarTransferencia =====> ' << entidad_financiera_id.to_s
    logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
    logger.info 'tipo_archivo =>' << tipo_archivo.to_s
    logger.info 'condiciones =>' << condiciones.to_s
    logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
    logger.info 'fecha_valor =>' << fecha_valor.to_s
    logger.info 'items =>' << items.to_s

    nuevas_condiciones=condiciones.gsub("tipo_pago_casa_proveedora=1","tipo_pago_casa_proveedora='1'")

#esto cambia las fechas del formato dd/mm/aaaa a 'dd/mm/aaaa' dependiendo del idioma        

    nuevas_condiciones=nuevas_condiciones.to_s.gsub(/(\d){4}\-(\d){2}\-(\d){2}/,"'\\0'")          
    #anterior nuevas_condiciones=nuevas_condiciones.to_s.gsub(/(\d){2}\/(\d){2}\/(\d){4}/,"'\\0'")

    case entidad_financiera_id.to_i

      when 8

                  logger.debug 'Ingreso en el 467 =====> '
                  self.generar_archivo_vzla(tipo_archivo, nuevas_condiciones, cuenta_bcv_fondas, fecha_valor,items)
    end

  end

#######fin de primera funcion

####### comienzo de la segunda funcion

  def self.generar_archivo_vzla(tipo_archivo, condiciones, cuenta_bcv_fondas, fecha_valor,items)

    logger.debug 'Entrando GenerarArchivoVzla =====> ' << condiciones
    

##### ==========CONDICION SI ES GENERACION DEL ARCHIVO POR SELECCION SEGUN FILTRO, ES DECIR EL PRIMER BOTON==============
    if items==''

      nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_envio_venezuela') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")

      @total = ViewListOrdenDespachoInsumo.count(:conditions=>condiciones)

      @valores = ViewListOrdenDespachoInsumo.find_by_sql("select * from view_list_orden_despacho_insumo where " << condiciones)

      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id    

    if tipo_archivo == "txt"

      documento = 'public/documentos/orden_despacho_insumo/envio/' << nombre << '.txt'
       logger.info "tipo_archivo " << tipo_archivo
       logger.info "documento " << documento

      CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|
        logger.info "Entre aqui en es faster"
        datos =''
        @contador = 0
        
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + Time.now.strftime(I18n.t('time.formats.gebos_short'))

	logger.debug "header " << @header.inspect
        
        csv << @header.gsub(34.chr,'').parse_csv #imprimiendo linea
        
        @total_monto=0.00
        while( @contador < @total)
          

          
          if(@valores[@contador].tipo_cuenta.upcase == 'C')

            tipo_cuenta_bef = '00'

          else

            tipo_cuenta_bef = '01'
          end

          if(@cuenta_fondas.tipo.upcase == 'C')

              tipo_cuenta_fon = '00'
          else

              tipo_cuenta_fon = '01'
          end

          if (@valores[@contador].numero_cuenta[0,4] == '0102')
           
              tipo_pago_bef = '10'

          else
            
              tipo_pago_bef = '00'

          end


          debito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura



          credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura

          nro_solicitud = ('0' * (8 - @valores[@contador].num_factura.to_s.length)) + @valores[@contador].num_factura.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s
           
              logger.debug "valorrrr << " +@valores[@contador].casa_proveedora.to_s
              cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s

			CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length >=30 ? nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre[0,30].to_s : nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s + (" " * (30 - CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length))


          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s

          mi_cod_swift=EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s        

          cod_swift = ('0' * (12 - mi_cod_swift.to_s.length)) + mi_cod_swift.to_s

          #//////// me quede aqui ///////

          mi_email=CasaProveedora.find(@valores[@contador].casa_proveedora).email_contacto

          mi_email.length >=50 ? email_bef = mi_email[0,50].to_s : email_bef = mi_email.to_s + (" " * (50 - mi_email.to_s.length))

          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'
        
          @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '000' + '0000' + email_bef

          @total_monto = @total_monto + @valores[@contador].monto_total_factura.to_f  # sumando los monto de los creditos realizados
  
          csv << @debito.gsub(34.chr,'').parse_csv 	#imprimiendo linea
          csv << @credito.gsub(34.chr,'').parse_csv 	#imprimiendo linea

	logger.debug "debito " << @debito.inspect

  logger.debug "credito " << @credito.inspect


              #codigo nuevo, esto actualiza el estatus de las facturas a enviadas al banco (10057) 

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057
     #factu.send(:update_without_callbacks)
     factu.update_column(:factura_estatus_id, 10057)


  }

     
    end
              # fin del nuevo codigo



          @contador += 1

      end

      valor =@total_monto

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

      @totales ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote

      csv << @totales.gsub(34.chr,'').parse_csv #imprimiendo linea

  logger.debug "MONTOSSSSS======>>>>>>>"  << valor.inspect
    end


      @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".txt", :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)
      @control.save
      @control_id = @control.id
      


  logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s

          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin
          
      @control = ControlOrdenDespachoInsumo.find(@control_id)
      @control.estatus = 2
      @control.save

logger.info "CONTROL ESTATUSS ========>>>>>>" << @control.estatus.to_s


   else #======================================GENERANDO EL ARCHIVO  EXCEL SEGUN FILTRO=================================
    
    documento = 'public/documentos/orden_despacho_insumo/envio/' << nombre << '.csv'
    CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        datos =''
        @contador = 0
        
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

        @total_monto=0.00
      while( @contador < @total)

           if(@valores[@contador].tipo_cuenta.upcase == 'C')

            tipo_cuenta_bef = '00'

          else

            tipo_cuenta_bef = '01'
          end

          if(@cuenta_fondas.tipo.upcase == 'C')

              tipo_cuenta_fon = '00'
          else

              tipo_cuenta_fon = '01'
          end

          if (@valores[@contador].numero_cuenta[0,4] == '0102')
           
              tipo_pago_bef = '10'

          else
            
              tipo_pago_bef = '00'

          end


          debito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura
          credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura

          nro_solicitud = ('0' * (8 - @valores[@contador].num_factura.to_s.length)) + @valores[@contador].num_factura.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s
           
              cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s         

			CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length >=30 ? nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre[0,30].to_s : nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s + (" " * (30 - CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length))         

          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s

          mi_cod_swift=EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s        

          cod_swift = ('0' * (12 - mi_cod_swift.to_s.length)) + mi_cod_swift.to_s
          

          mi_email=CasaProveedora.find(@valores[@contador].casa_proveedora).email_contacto

          mi_email.length >=50 ? email_bef = mi_email[0,50].to_s : email_bef = mi_email.to_s + (" " * (50 - mi_email.to_s.length))
          



        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '000' + ';' + '0000' + ';' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_total_factura.to_f  # sumando los monto de los creditos realizados

        csv << @debito.sub(34.chr,'').parse_csv	 #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv	 #imprimiendo linea

              #codigo nuevo, esto actualiza el estatus de las facturas a enviadas al banco (10057) 

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057

     #factu.send(:update_without_callbacks)
    factu.update_column(:factura_estatus_id, 10057)

  }

     
    end
              # fin del nuevo codigo


        @contador += 1

      end

      valor = @total_monto

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

      @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv	 #imprimiendo linea



      end


      @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".csv", :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)
      @control.save
      @control_id = @control.id



      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s


          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin


      @control = ControlOrdenDespachoInsumo.find(@control_id)
      @control.estatus = 2
      @control.save

    end
#CONDICION CUANDO SI EXITEN LOS ITEMS
  else

##### AQUI EMPIEZA EL ELSE DE LA MEGA CONDICION DEL ITEM

  item_aux=items.split(',')
  item_formateado=''
  fre=0
  while (fre<item_aux.length)
    if (item_aux[fre]!='')
      item_formateado+="'"+item_aux[fre]+"'"+","
    end
    fre+=1
  end

  if item_aux.length > 0
    item_formateado=item_formateado[0,(item_formateado.length)-1]
  end


    otra_condicion=condiciones + " and identificador in (" + item_formateado + ")"

    nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_envio_venezuela') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")

    @total = ViewListOrdenDespachoInsumo.count(:conditions=>otra_condicion)

    @valores = ViewListOrdenDespachoInsumo.find_by_sql("select * from view_list_orden_despacho_insumo where " << otra_condicion)

    @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
    entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

   #============================ TXT SEGUN SELECCION=====================================================
    

   if tipo_archivo == "txt"

      documento = 'public/documentos/orden_despacho_insumo/envio/' << nombre << '.txt'
       logger.info "tipo_archivo " << tipo_archivo
       logger.info "documento " << documento

      CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        datos =''
        @contador = 0        
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + nro_lote.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + fecha_valor + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv	 #imprimiendo linea
        
        @total_monto=0.00
      while( @contador < @total)

if(@valores[@contador].tipo_cuenta.upcase == 'C')

            tipo_cuenta_bef = '00'

          else

            tipo_cuenta_bef = '01'
          end

          if(@cuenta_fondas.tipo.upcase == 'C')

              tipo_cuenta_fon = '00'
          else

              tipo_cuenta_fon = '01'
          end

          if (@valores[@contador].numero_cuenta[0,4] == '0102')
           
              tipo_pago_bef = '10'

          else
            
              tipo_pago_bef = '00'

          end


          debito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura.to_f
          credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura.to_f

          logger.debug "monto aqui <<<< " + credito_monto.to_s
          
          nro_solicitud = ('0' * (8 - @valores[@contador].num_factura.to_s.length)) + @valores[@contador].num_factura.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s
           
          cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s

            CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length >=30 ? nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre[0,30].to_s : nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s + (" " * (30 - CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length))
          
          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s

          mi_cod_swift=EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s        

          cod_swift = ('0' * (12 - mi_cod_swift.to_s.length)) + mi_cod_swift.to_s

          mi_email=CasaProveedora.find(@valores[@contador].casa_proveedora).email_contacto

          mi_email.length >=50 ? email_bef = mi_email[0,50].to_s : email_bef = mi_email.to_s + (" " * (50 - mi_email.to_s.length))

        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + nro_solicitud +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + fecha_valor + tipo_cuenta_fon + nro_cuenta_fon + monto_debito + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + nro_solicitud + cedula_rif + nombre_beneficiario + tipo_cuenta_bef + nro_cuenta_bef + monto_credito + tipo_pago_bef + cod_swift + '000' + '0000' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_total_factura.to_f  # sumando los monto de los creditos realizados


       logger.debug "TOTAL-MONTO============>>>>>>>" << @total_monto.to_s << @debito.to_s << " - " << @debito.sub(34.chr,'').parse_csv.to_s
        
        
        csv << @debito.sub(34.chr,'').parse_csv	 #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv	 #imprimiendo linea

              #codigo nuevo, esto actualiza el estatus de las facturas a enviadas al banco (10057) 

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057

     #factu.send(:update_without_callbacks)
    factu.update_column(:factura_estatus_id, 10057)

  }

     
    end

              # fin del nuevo codigo


        @contador += 1

      end

      valor = @total_monto

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

      @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + cantidad_debito + cantidad_credito + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv	 #imprimiendo linea
      logger.debug "MONTOSSSSS======>>>>>>>"  << valor.inspect
      end


      @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".txt", :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)
      @control.save
      @control_id = @control.id
      


      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s


          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

      @control = ControlOrdenDespachoInsumo.find(@control_id)
      @control.estatus = 2
      @control.save

   else #=====================GENERANDO EL ARCHIVO  EXCEL SEGUN SELECCION=============================
    
     documento = 'public/documentos/orden_despacho_insumo/envio/' << nombre << '.csv'
     CSV.open(documento,'w+',{:col_sep => "·" , :row_sep => "\r\n"}) do |csv|

        datos =''
        @contador = 0
        #fecha_valor= '10/09/2011'
        @nro_lote = ParametroGeneral.find(1)
        nro_lote = @nro_lote.nro_lote
        datos << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
        @nro_lote.nro_lote = datos
        @nro_lote.save

        @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.header')}" + ';' + nro_lote.to_s + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo_excel')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + fecha_valor + ';' + Time.now.strftime(I18n.t('time.formats.gebos_short'))

        csv << @header.sub(34.chr,'').parse_csv #imprimiendo linea

        @total_monto=0.00
      while( @contador < @total)

if(@valores[@contador].tipo_cuenta.upcase == 'C')

            tipo_cuenta_bef = '00'

          else

            tipo_cuenta_bef = '01'
          end

          if(@cuenta_fondas.tipo.upcase == 'C')

              tipo_cuenta_fon = '00'
          else

              tipo_cuenta_fon = '01'
          end

          if (@valores[@contador].numero_cuenta[0,4] == '0102')
           
              tipo_pago_bef = '10'

          else
            
              tipo_pago_bef = '00'

          end


          debito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura
          credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura

          nro_solicitud = ('0' * (8 - @valores[@contador].num_factura.to_s.length)) + @valores[@contador].num_factura.to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          monto_debito = ('0' * (18 - debito_monto.to_s.length)) + debito_monto.to_s #verificar si los montos necesitan los to_s
           
          cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s

          CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length >=30 ? nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre[0,30].to_s : nombre_beneficiario = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s + (" " * (30 - CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s.length))

          nro_cuenta_bef = ('0' * (20 - @valores[@contador].numero_cuenta.to_s.length)) + @valores[@contador].numero_cuenta.to_s
          monto_credito = ('0' * (18 - credito_monto.to_s.length)) + credito_monto.to_s

          mi_cod_swift=EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s        

          cod_swift = ('0' * (12 - mi_cod_swift.to_s.length)) + mi_cod_swift.to_s
          
          mi_email=CasaProveedora.find(@valores[@contador].casa_proveedora).email_contacto

		  mi_email.length >=50 ? email_bef = mi_email[0,50].to_s : email_bef = mi_email.to_s + (" " * (50 - mi_email.to_s.length))          

        @debito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.debito')}" + ';' + nro_solicitud + ';' +  "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + ';' + fecha_valor + ';' + tipo_cuenta_fon + ';' + nro_cuenta_fon + ';' + monto_debito + ';' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + ';' + '40'
        @credito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.credito')}" + ';' + nro_solicitud + ';' + cedula_rif + ';' + nombre_beneficiario + ';' + tipo_cuenta_bef + ';' + nro_cuenta_bef + ';' + monto_credito + ';' + tipo_pago_bef + ';' + cod_swift + ';' + '000' + ';' + '0000' + ';' + email_bef
        @total_monto = @total_monto + @valores[@contador].monto_total_factura.to_f  # sumando los monto de los creditos realizados

        csv << @debito.sub(34.chr,'').parse_csv	 #imprimiendo linea
        csv << @credito.sub(34.chr,'').parse_csv	 #imprimiendo linea

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057

     #factu.send(:update_without_callbacks)
    factu.update_column(:factura_estatus_id, 10057)

  }

     
    end
              # fin del nuevo codigo



        @contador += 1

      end

      valor = @total_monto

      cantidad_debito = ('0' * (5 - @total.to_s.length)) + @total.to_s
      cantidad_credito = ('0' * (5 - @total.to_s.length)) + @total.to_s

      total_monto_lote = ('0' * (18 - valor.to_s.length)) + valor.to_s

      @totales= "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.total')}" + ';' + cantidad_debito + ';' + cantidad_credito + ';' + total_monto_lote

      csv << @totales.sub(34.chr,'').parse_csv	 #imprimiendo linea
      end


      @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".csv", :estatus=>1, :numero_procesado=>@total, :monto_procesado=>@total_monto, :entidad_financiera_id=>entidad_financiera_id)
      @control.save
      @control_id = @control.id



      logger.info "Control =====> " << @control.inspect

      puts "Documento ====> " << documento.to_s


          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

      @control = ControlOrdenDespachoInsumo.find(@control_id)
      @control.estatus = 2
      @control.save

    end


end
  end


###### fin de la segunda funcion






###### fin de las funciones 



############### parte para la generacion del archivo por cheque #####################


#### larga start


#=====================================Archivo txt para CHEQUE ============================

  def self.generar_txt_cheque_vzla(modalidad, condiciones, cuenta_bcv_fondas, items)

    #--------------------- CONDICION SI ES GENERACION DEL ARCHIVO SEGUN FILTRO------------
    logger.info "MODALIDADDDDDDDDDDDDD  ============>" << modalidad.to_s

    if items ==''

      nombre = I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_venezuela_cheque') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")

      logger.info "CODNDICIONES =========> " << condiciones.to_s
      @total = ViewListOrdenDespachoInsumo.count(:conditions=>condiciones)

      @valores = ViewListOrdenDespachoInsumo.find_by_sql("select * from view_list_orden_despacho_insumo where " << condiciones)

      logger.info "Cuenta BCV FONDAS ========================> " << cuenta_bcv_fondas.to_s
      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

      logger.info "MODALIDADDDDD =========> " << modalidad.to_s

      if modalidad == 'gerencia'
      nombre = I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_cheque_gerencia') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")
      else
      nombre = I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_cheque_propio') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("-#{I18n.t('time.formats.hora_banco')}")
      end

        logger.info "modalidad " << modalidad.to_s
        documento = 'public/documentos/orden_despacho_insumo/envio_cheque/' << nombre << '.txt'

        logger.info "DOCUMENTO =================> " << documento.to_s

        CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

          logger.info "Entro a creación de archivo =================> "
          datos = ''
          @contador = 0
          numero = ''
          montos_creditos = 0.00
          montos_credito = ''
          cantidad_credito = ''
          creditos_montos = ''

          @nro_lote = ParametroGeneral.find(1)
          logger.info "Numero de lote leido =================> " << @nro_lote.inspect
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          numero << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          logger.debug "Numero de lote ===============> " << datos.to_s
          @nro_lote.nro_lote =  numero
          @nro_lote.save
          logger.info "Numero de lote despues save =================> " << @nro_lote.inspect

          cantidad_credito = ('0' * (15 - @total.to_s.length)) + @total.to_s

          montos_creditos = ViewListOrdenDespachoInsumo.sum(:monto_total_factura, :conditions=>condiciones)          

          montos_credito = montos_creditos.nil? ? 0 : montos_creditos
          logger.info "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
          logger.info "Montos Credito ========> " << montos_credito.to_s

          creditos_montos = ('0' * (17 - (montos_credito.to_f).to_s.length))

          logger.info "Creditos Montos ========> " << creditos_montos.to_s  

          #PRIMER LINEA------------------------------
          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + nro_lote.to_s + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '000000000000001' + cantidad_credito.to_s + creditos_montos.to_s

          logger.debug "HEADER    " << @header.to_s

          csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea

          
          nro_lote = ('0' * (8 - (@nro_lote.nro_lote.to_i).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s
          
          @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
          entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

          cod_swift = EntidadFinanciera.find(entidad_financiera_id).cod_swift.to_s + (" " * (12 - EntidadFinanciera.find(entidad_financiera_id).cod_swift.to_s.length )) #CAMBIAR EL Q ESTA EN LA TRANSFERENCIA

          #SEGUNDA LINEA------------------------------
          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '03292' + nro_lote.to_s + creditos_montos.to_s + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon.to_s + cod_swift.to_s + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"

          csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea

          logger.debug "DEBITO    " << @debito.inspect.to_s

          #TERCERA LINEA------------------------------
          begin

            while ( @contador < @total)

              incremental = 0
              cod_swift = ''

              credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura
              monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto.to_s

          

                cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s
                espacio = ''

              

              nombre_benef = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s[0,54]
              nombre_benef = nombre_benef + (" " * (55 - nombre_benef.to_s.length))

              incremental += 1
              incremental1 = ('0' * (8 - incremental.to_s.length) << incremental.to_s)

              logger.info "Icremental1  " << incremental1.to_s
              logger.info "incremental " << incremental.to_s.length.to_s

              incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

              @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2


              csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea

              logger.debug "CREDITO    " << @credito.inspect
              

              #codigo nuevo, esto actualiza el estatus de las facturas a enviadas al banco (10057) 

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057

     #factu.send(:update_without_callbacks)
    factu.update_column(:factura_estatus_id, 10057)

  }

     
    end
              # fin del nuevo codigo
              @contador += 1

            end #fin del while
            rescue Exception => x
              logger.info x.message
              logger.info x.backtrace.join("\n")
            return false


          end # fin de begin
          montos_creditos = ViewListOrdenDespachoInsumo.sum(:monto_total_factura, :conditions=>condiciones)
          if montos_creditos.nil? 
				montos_creditos="0.00"
		  end 
          @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".txt", :estatus=>1, :numero_procesado=>@total, :monto_procesado=> montos_creditos.to_f, :entidad_financiera_id=>entidad_financiera_id)
          @control.save
          @control_id = @control.id



          logger.info "Control =====> " << @control.inspect

          puts "Documento ====> " << documento.to_s

          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

          @control = ControlOrdenDespachoInsumo.find(@control_id)
          @control.estatus = 2
          @control.save

        end # del do      

    else # Items =================SEGUN  SELECCION====================

      item_aux=items.split(',')
      item_formateado=''
      fre=0
      while (fre<item_aux.length)
        if (item_aux[fre]!='')
          item_formateado+="'"+item_aux[fre]+"'"+","
        end
        fre+=1
      end

      if item_aux.length > 0
        item_formateado=item_formateado[0,(item_formateado.length)-1]
      end

      otra_condicion=condiciones + " and identificador in (" + item_formateado + ")"

      logger.info "OTRA CONDICION ========> " << otra_condicion.to_s
      nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_envio_cheque_venezuela') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")

      @total = ViewListOrdenDespachoInsumo.count(:conditions=>otra_condicion)

      @valores = ViewListOrdenDespachoInsumo.find_by_sql("select * from view_list_orden_despacho_insumo where " << otra_condicion)

      @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
      entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

      if modalidad == 'gerencia'
      nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_cheque_gerencia') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")
      else
      nombre =I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre_archivo_cheque_propio') + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + Time.now.strftime("#{I18n.t('time.formats.hora_banco')}")
      end
        logger.info "modalidad ttt" << modalidad.to_s
        documento = 'public/documentos/orden_despacho_insumo/envio_cheque/' << nombre << '.txt'

        logger.info "DOCUMENTO =================> " << documento.to_s

        CSV.open(documento,'w+',{:col_sep => "|" , :row_sep => "\r\n"}) do |csv|

          logger.info "Entro a creación de archivo =================> "
          datos = ''
          @contador = 0
          numero = ''
          montos_creditos = 0.00
          montos_credito = ''
          cantidad_credito = ''
          creditos_montos = ''

          @nro_lote = ParametroGeneral.find(1)
          logger.info "Numero de lote leido =================> " << @nro_lote.inspect
          nro_lote = @nro_lote.nro_lote
          datos << ('0' * (15 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          numero << ('0' * (8 - (@nro_lote.nro_lote.to_i + 1).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s
          logger.debug "Numero de lote ===============> " << datos.to_s
          @nro_lote.nro_lote =  numero
          @nro_lote.save
          logger.info "Numero de lote despues save =================> " << @nro_lote.inspect

          cantidad_credito = ('0' * (15 - @total.to_s.length)) + @total.to_s

          montos_creditos = ViewListOrdenDespachoInsumo.sum(:monto_total_factura, :conditions=>otra_condicion)          

          montos_credito = montos_creditos.nil? ? 0 : montos_creditos
          logger.info "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
          logger.info "Montos Credito ========> " << montos_credito.to_s

          creditos_montos = ('0' * (17 - (montos_credito.to_f).to_s.length)) << montos_credito.to_s

          logger.info "Creditos Montos ========> " << creditos_montos.to_s  

          #PRIMER LINEA------------------------------
          @header ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '01' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.codigo')}" + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.nombre')}" + nro_lote.to_s + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '000000000000001' + cantidad_credito + creditos_montos

          logger.debug "HEADER    2" << @header.to_s

          csv << @header.sub(34.chr,'').parse_csv # imprimiendo linea    


          nro_lote = ('0' * (8 - (@nro_lote.nro_lote.to_i).to_s.length)) << (@nro_lote.nro_lote.to_i + 1).to_s          

          nro_cuenta_fon = ('0' * (20 - cuenta_bcv_fondas.to_s.length)) + cuenta_bcv_fondas.to_s

          @cuenta_fondas = CuentaBcv.find_by_numero(cuenta_bcv_fondas)
          entidad_financiera_id = @cuenta_fondas.entidad_financiera_id

          cod_swift = EntidadFinanciera.find(entidad_financiera_id).cod_swift.to_s + (" " * (12 - EntidadFinanciera.find(entidad_financiera_id).cod_swift.to_s.length )) #CAMBIAR EL Q ESTA EN LA TRANSFERENCIA

          # antes estaba esto cod_swift = EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s + (" " * (12 - EntidadFinanciera.find(@valores[@contador].entidad_financiera_id).cod_swift.to_s.length )) #CAMBIAR EL Q ESTA EN LA TRANSFERENCIA



          #SEGUNDA LINEA------------------------------

          @debito ="#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" + ' ' + '02' + Time.now.strftime("#{I18n.t('time.formats.gebos_txt_banco')}") + '03292' + nro_lote.to_s + creditos_montos + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" + '  ' + nro_cuenta_fon + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" + '006' + "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cheques_manuales')}"


          

          csv << @debito.sub(34.chr,'').parse_csv # imprimiendo linea

          logger.debug "DEBITO    " << @debito.inspect

          #TERCERA LINEA------------------------------
          begin

            while ( @contador < @total)

              incremental = 0
              cod_swift = ''

              credito_monto = @valores[@contador].monto_total_factura.nil? ? 0 : @valores[@contador].monto_total_factura
              monto_credito = ('0' * (17 - credito_monto.to_s.length)) + credito_monto.to_s

              

                cedula_rif = ('0' * (10 - (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s.length)) + (CasaProveedora.find(@valores[@contador].casa_proveedora).rif[0,1]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[2,8]+CasaProveedora.find(@valores[@contador].casa_proveedora).rif[11,1].to_s).to_s
                espacio = ''

              

              nombre_benef = CasaProveedora.find(@valores[@contador].casa_proveedora).nombre.to_s[0,54]
              nombre_benef = nombre_benef + (" " * (55 - nombre_benef.to_s.length))

              incremental += 1
              incremental1 = ('0' * (8 - incremental.to_s.length) << incremental.to_s)

              logger.info "Icremental1  " << incremental1.to_s
              logger.info "incremental " << incremental.to_s.length.to_s

              incremental2 = ('0' * (15 - incremental.to_s.length) << incremental.to_s)

              @credito = "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.cabecera_cheque')}" << ' ' << '03' << '03292' << incremental1 << monto_credito << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.veb')}" << '20' << '  ' << '                     ' << "#{I18n.t('Sistema.Body.Modelos.Desembolso.Txt.bschveca')}" << '501  ' << cedula_rif << espacio << nombre_benef << '              ' << incremental2


              csv << @credito.sub(34.chr,'').parse_csv  #imprimiendo linea

              logger.debug "CREDITO    " << @credito.inspect

              #codigo nuevo, esto actualiza el estatus de las facturas a enviadas al banco (10057) 

 ordenes=OrdenDespachoDetalle.find(:all, :conditions=>"orden_despacho_id=#{@valores[@contador].orden_despacho_id}")   

    unless ordenes.empty?
      condi="("
      ordenes.each{ |orden|
        condi+=orden.id.to_s << ","
        }
      condi=condi[0,condi.length-1]
      condi+=")"

      logger.info "wwwwwwwwwwwwwwwwww "<< condi.to_s


    actualiza_factura=FacturaOrdenDespacho.find(:all,:conditions=>"numero_factura='#{@valores[@contador].num_factura}' and casa_proveedora_id = #{@valores[@contador].casa_proveedora} and orden_despacho_detalle_id in #{condi}")

 
  actualiza_factura.each { |factu|
      #aqui actualizamos todas las facturas
     #factu.factura_estatus_id=10057

     #factu.send(:update_without_callbacks)
     factu.update_column(:factura_estatus_id, 10057)


  }

     
    end

              # fin del nuevo codigo


              @contador += 1

            end #fin del while
            rescue Exception => x
              logger.info x.message
              logger.info x.backtrace.join("\n")
            return false


          end # fin de begin
            logger.debug " asi es el monto " << monto_credito.to_f.to_s 
            montos_creditos = ViewListOrdenDespachoInsumo.sum(:monto_total_factura, :conditions=>otra_condicion)
			
			if montos_creditos.nil? 
				montos_creditos="0.00"
			end
                  
          @control = ControlOrdenDespachoInsumo.new(:fecha=>Time.now, :archivo=>nombre+".txt", :estatus=>1, :numero_procesado=>@total, :monto_procesado=> montos_creditos.to_f, :entidad_financiera_id=>entidad_financiera_id)
          @control.save
          @control_id = @control.id


          logger.info "Control =====> " << @control.inspect

          puts "Documento ====> " << documento.to_s

          @contador = 0

          begin

            transaction do
            while( @contador < @total)

              #actualizamos el estado de la orden de despacho por por liquidar-casa_proveedora
              @ordenes=OrdenDespacho.find(@valores[@contador].orden_despacho_id)
              @ordenes.estatus_id = 20070
              @ordenes.save              
              @contador+= 1

              end #fin while
            end # fin transaction

            rescue Exception => x
            logger.error x.message
            logger.error x.backtrace.join("\n")
            return false

          end # fin begin

          @control = ControlOrdenDespachoInsumo.find(@control_id)
          @control.estatus = 2
          @control.save

        end # del do

    end # Items
  end



###### larga fin


  def self.generar_cheque(entidad_financiera_id, modalidad, condiciones, cuenta_bcv_fondas,items)

    logger.debug 'Entrando GenerarCheque =====> ' << entidad_financiera_id.to_s
    logger.info 'entidad_financiera_id ===>' << entidad_financiera_id.to_s
    logger.info 'modalidad =>' << modalidad.to_s
    logger.info 'condiciones =>' << condiciones.to_s
    logger.info 'cuenta_bcv_fondas =>' << cuenta_bcv_fondas.to_s
    logger.info 'items =>' << items.to_s
#    fecha_valor1 = fecha_valor[6,4] << '-' << fecha_valor[3,2] << '-' << fecha_valor[0,2]
    nuevas_condiciones=condiciones.gsub("tipo_pago_casa_proveedora=2","tipo_pago_casa_proveedora='2'")

#esto cambia las fechas del formato dd/mm/aaaa a 'dd/mm/aaaa' dependiendo del idioma
        
    
    nuevas_condiciones=nuevas_condiciones.to_s.gsub(/(\d){4}\-(\d){2}\-(\d){2}/,"'\\0'")          
    #anterior nuevas_condiciones=nuevas_condiciones.to_s.gsub(/(\d){2}\/(\d){2}\/(\d){4}/,"'\\0'")

    case entidad_financiera_id.to_i

      when 8

                  logger.debug 'Ingreso en el 467 =====> '
                  self.generar_txt_cheque_vzla(modalidad, nuevas_condiciones, cuenta_bcv_fondas, items)
    end # when

  end


############### fin parte para la generacion del archivo por cheque #####################



end
