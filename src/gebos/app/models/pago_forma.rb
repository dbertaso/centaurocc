# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PagosCompromiso
# Migrado a Rails 3
#
class PagoForma < ActiveRecord::Base

  self.table_name = 'pago_forma'
  
  attr_accessible :id,
                  :forma,
                  :monto,
                  :referencia,
                  :entidad_financiera_id,
                  :pago_cliente_id
                  
                  
  belongs_to :pago_cliente
  belongs_to :entidad_financiera
  
  
  def forma_w
    case self.tipo
      when 'A'
        t('Sistema.Body.Modelos.PagoForma.Tipo.abono')
      when 'C'
        t('Sistema.Body.Modelos.PagoForma.Tipo.cancelacion')
      when 'D'
        t('Sistema.Body.Modelos.PagoForma.Tipo.desembolso')
      when 'P'
        t('Sistema.Body.Modelos.PagoForma.Tipo.pago')
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
  
end

# == Schema Information
#
# Table name: pago_forma
#
#  id                    :integer         not null, primary key
#  forma                 :string(1)       default("D")
#  monto                 :float
#  referencia            :string(25)
#  entidad_financiera_id :integer
#  pago_cliente_id       :integer         not null
#

