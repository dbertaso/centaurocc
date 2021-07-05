# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: OrdenAbonoExcedenteArrime
# descripción: Migración a Rails 3
#



class OrdenAbonoExcedenteArrime < ActiveRecord::Base

    self.table_name = 'orden_abono_excedente_arrime'

    attr_accessible :id,
                    :solicitud_id,
                    :prestamo_id,
                    :cliente_id,
                    :fecha_envio,
                    :usuario_id,
                    :monto_abono,
                    :estatus_id,
                    :fecha_envio_banco,
                    :fecha_valor,
                    :fecha_abono_cuenta,
                    :entidad_financiera_liquidadora_id,
                    :numero_cuenta_liquidadora,
                    :entidad_financiera_cliente_id,
                    :numero_cuenta_cliente,
                    :tipo_cheque,
                    :referencia,
                    :numero_lote,
                    :fecha_registro_cheque



  belongs_to :solicitud
  belongs_to :prestamo
  belongs_to :cliente
  belongs_to :usuario

  validates :solicitud_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  
  validates :prestamo_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.prestamo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cliente_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :usuario_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.usuario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  


  def contabilizar_pago_excedente(solicitud, monto, fecha,transaccion_id,tipo_transaccion)

    fuente_recursos_id = 0
    logger.info "Fecha cierre: =====> " << fecha.to_s
    
    cliente = Cliente.find(solicitud.cliente_id)
    cuenta = CuentaBancaria.find_by_cliente_id_and_activo(cliente.id,true)
    
    prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
    
    case prestamo.banco_origen
      when I18n.t('Sistema.Body.Modelos.Prestamo.BancoOrigen.fondas')
        fuente_recursos_id = 1
      when I18n.t('Sistema.Body.Modelos.Prestamo.BancoOrigen.agrovenezuela')
        fuente_recursos_id = 2
      when I18n.t('Sistema.Body.Modelos.Prestamo.BancoOrigen.fondafa')
        fuente_recursos_id = 3
      else
        fuente_recursos_id = 1
    end
    
    modalidad_pago = 'X'.to_s
    estatus = 'X'.to_s
    logger.info "Banco Origen ======> #{prestamo.banco_origen}"
    logger.info "fuente_recursos_id =======> #{fuente_recursos_id.to_s}"
    
        fechapro = Date.new(fecha[0,4].to_i,fecha[5,2].to_i,fecha[8,2].to_i )          
        anio = fecha[0,4].to_i
        
    
    tipo_transaccion = tipo_transaccion
    voucher = fecha.to_s + "-" + solicitud.numero.to_s
    entidad_financiera = 0
    
    banco = I18n.t('Sistema.Body.Vistas.General.pago_cheque')
    banco = cuenta.entidad_financiera.nombre.to_s unless cuenta.nil?
    cliente = cliente.nombre.to_s
    numero_prestamo = prestamo.numero.to_s
    prestamo_id = prestamo.id.to_i
    
    params = {:p_transaccion_contable_id=>14,
              :p_modalidad=>modalidad_pago.to_s,
              :p_fuente_recursos_id=>fuente_recursos_id.to_i,
              :p_programa_id=> solicitud.programa_id.to_i,
              :p_estatus=>estatus.to_s,
              :p_entidad_financiera_id=>entidad_financiera,
              :p_monto_pago=>monto,
              :p_monto_ingreso_intereses=>0.00,
              :p_monto_por_cobrar_intereses=>0.00,
              :p_remanente_por_aplicar=>monto,
              :p_monto_capital_cuota=>0.00,
              :p_ingreso_mora=>0.00,
              :p_remanente_por_aplicar_inicial=>0.00,
              :p_monto_comision_intereses=>0.00,
              :p_interes_diferido=>0.00,
              :p_monto_gasto=>0.00,
              :p_monto_sras=>0.00,
              :p_monto_excedente=>monto,
              :p_monto_desembolso=>0.00,
              :p_fecha_registro => fechapro,
              :p_fecha_comprobante => fechapro,
              :p_prestamo_id => prestamo_id,
              :p_factura_id => self.id.to_i,
              :p_anio => anio,
              :p_voucher => voucher,
              :p_banco => banco,
              :p_nombre => cliente,
              :p_tipo_transaccion => tipo_transaccion,
              :p_prestamo => numero_prestamo,
              :p_reestructurado => prestamo.reestructurado,
              :p_transaccion_id => transaccion_id.to_i         
              
              }

      begin

        transaction do
          execute_sp('registro_contable',  params.values_at(:p_transaccion_contable_id,
              :p_modalidad,
              :p_fuente_recursos_id,
              :p_programa_id,
              :p_estatus,
              :p_entidad_financiera_id,
              :p_monto_pago,
              :p_monto_ingreso_intereses,
              :p_monto_por_cobrar_intereses,
              :p_remanente_por_aplicar,
              :p_monto_capital_cuota,
              :p_ingreso_mora,
              :p_remanente_por_aplicar_inicial,
              :p_monto_comision_intereses,
              :p_interes_diferido,
              :p_monto_gasto,
              :p_monto_sras,
              :p_monto_excedente,
              :p_monto_desembolso,
              :p_fecha_registro,
              :p_fecha_comprobante,
              :p_prestamo_id,
              :p_factura_id,
              :p_anio,
              :p_voucher,
              :p_banco,
              :p_nombre,
              :p_tipo_transaccion,
              :p_prestamo,
              :p_reestructurado,
              :p_transaccion_id))
          return true
        end

      end

  end

end


# == Schema Information
#
# Table name: orden_abono_excedente_arrime
#
#  id                                :integer         not null, primary key
#  solicitud_id                      :integer         not null
#  prestamo_id                       :integer         not null
#  cliente_id                        :integer         not null
#  fecha_envio                       :date
#  usuario_id                        :integer         not null
#  monto_abono                       :decimal(16, 2)  default(0.0)
#  estatus_id                        :integer         not null
#  fecha_envio_banco                 :date
#  fecha_valor                       :date
#  fecha_abono_cuenta                :date
#  entidad_financiera_liquidadora_id :integer
#  numero_cuenta_liquidadora         :string(20)
#  entidad_financiera_cliente_id     :integer
#  numero_cuenta_cliente             :string(20)
#  tipo_cheque                       :string(1)
#  referencia                        :string(30)
#  numero_lote                       :string(20)
#  fecha_registro_cheque             :date
#


