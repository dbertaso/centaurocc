# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PagoCliente
# Migrado a Rails 3
#

class PagoCliente < ActiveRecord::Base

  self.table_name = 'pago_cliente'
  
  attr_accessible :id,
                  :fecha,
                  :modalidad,
                  :monto,
                  :cliente_id,
                  :oficina_id,
                  :reversado,
                  :fecha_contable,
                  :fecha_realizacion,
                  :numero_voucher,
                  :efectivo,
                  :entidad_financiera_id,
                  :cuenta_bcv_id
                  
  belongs_to :oficina
  belongs_to :cliente
  belongs_to :pago_cliente
  belongs_to :entidad_financiera
  belongs_to :cuenta_bcv
  has_many :cheques, :class_name=>'PagoForma'
  has_many :prestamos, :class_name=>'PagoPrestamo'  
        
        
  def modalidad_w
    case self.modalidad
      when 'A'
        I18n.t('Sistema.Body.ModalidadPago.arrime')
      when 'R'
        I18n.t('Sistema.Body.ModalidadPago.deposito')
      when 'D'
        I18n.t('Sistema.Body.ModalidadPago.domicializacion')
      when 'O'
        I18n.t('Sistema.Body.ModalidadPago.taquilla')
   end
  end
  def after_initialize
   
  end
  def efectivo_f=(valor)
    self.efectivo = valor.sub(',', '.')
  end
    
  def efectivo_f
    sprintf('%01.2f', self.efectivo).sub('.', ',') unless self.efectivo.nil?
  end
    
  def efectivo_fm
    unless self.efectivo.nil?
      valor = sprintf('%01.2f', self.efectivo).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end  
  
  def monto_f=(valor)
    self.monto = valor.sub(',', '.')
  end
    
  def monto_f
    sprintf('%01.2f', self.monto).sub('.', ',') unless self.monto.nil?
  end
    
  def monto_fm
    unless self.monto.nil?
      valor = sprintf('%01.2f', self.monto).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  def fecha_f=(fecha)
    self.fecha = fecha
  end
    
  def fecha_f
    self.fecha.strftime('%d/%m/%Y') unless self.fecha.nil?
  end
  
  def fecha_realizacion_f=(fecha)
    self.fecha_realizacion = fecha
  end
    
  def fecha_realizacion_f
    self.fecha_realizacion.strftime('%d/%m/%Y') unless self.fecha_realizacion.nil?
  end
  
  def nombre_silo
  
    silo = Silo.find_by_id(self.entidad_financiera_id)
    
    if !silo.nil?
      silo.nombre
    else
      ''
    end
    
  end
  
end


# == Schema Information
#
# Table name: pago_cliente
#
#  id                    :integer         not null, primary key
#  fecha                 :date            not null
#  modalidad             :string(1)       default("O")
#  monto                 :float
#  cliente_id            :integer         not null
#  oficina_id            :integer
#  reversado             :boolean         default(FALSE)
#  fecha_contable        :date
#  fecha_realizacion     :date            not null
#  numero_voucher        :string(20)
#  efectivo              :decimal(16, 2)  default(0.0)
#  entidad_financiera_id :integer
#  cuenta_bcv_id         :integer
#

